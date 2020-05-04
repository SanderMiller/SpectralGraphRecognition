classdef NeighborFinder < handle
    %NEIGHBORFINDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        nbhMap                                   containers.Map
        revNbhMap                                containers.Map
        minVal = -1
        xNbh
        xNbhIdx
        searchIdxByNbh                           containers.Map
        nbhSelect = 0;
        nbhPerm
        numNbhs
        depletedVec
    end
    
    properties (Access = public)
        isDepleted
        x
    end
    
    methods (Access = public)
        function obj = NeighborFinder(nbhMap, xInit)
            %NEIGHBORFINDER Construct an instance of this class
            %   Detailed explanation goes here
            obj.nbhMap = nbhMap;
            obj.revNbhMap = containers.Map();
            obj.nbhPerm = nbhMap.keys;
            obj.depletedVec = boolean(zeros(length(obj.nbhPerm), 1));
            obj.isDepleted = boolean(0);
            for k = 1:length(obj.nbhPerm)
                nbh = obj.nbhPerm{k};
                vec = nbhMap(nbh);
                for l = 1:length(vec)
                    obj.revNbhMap(string(vec(l))) = nbh;
                end
                obj.searchIdxByNbh(nbh) = 1;
            end
            obj.changeX(xInit);
        end
        
        function changeX(obj, newX)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.x = newX;
            obj.xNbh = obj.revNbhMap(string(obj.x));
            obj.nbhSelect = 0;
            permVec = randperm(length(obj.nbhPerm));
            obj.nbhPerm = obj.nbhPerm(permVec);
            obj.depletedVec = obj.depletedVec(permVec);
            nbh = obj.nbhPerm{1};
            obj.xNbhIdx = 1;
            while string(nbh) ~= string(obj.xNbh)
                obj.xNbhIdx = obj.xNbhIdx + 1;
                nbh = obj.nbhPerm{obj.xNbhIdx};
            end
        end
        
        function neighbor = retNeighbor(obj)
            assert(~obj.isDepleted, "Search is depleted");
            neighbor = -1;
            while neighbor == -1 || neighbor == obj.x
                [nbh, nbhPermIdx] = obj.getNextNbh();
                neighbor = obj.getNeighborFromNbh(nbh, nbhPermIdx);
            end
            if all(obj.depletedVec)
                obj.isDepleted = 1;
            end
        end
    end
    
    methods (Access = private)
        function incrementNbhSelect(obj)
            obj.nbhSelect = obj.nbhSelect + 1;
            if obj.nbhSelect == obj.xNbhIdx
                obj.nbhSelect = obj.nbhSelect + 1;
            end
            if obj.nbhSelect > length(obj.nbhPerm)
                obj.nbhSelect = 0;
            end
        end
        
        function [nbh, nbhPermIdx] = getNextNbh(obj)
            if obj.nbhSelect == 0
                nbh = obj.xNbh;
                nbhPermIdx = obj.xNbhIdx;
            else
                nbh = obj.nbhPerm{obj.nbhSelect};
                nbhPermIdx = obj.nbhSelect;
            end
            obj.incrementNbhSelect();
        end
        
        function neighbor = getNeighborFromNbh(obj, nbh, nbhPermIdx)
            nbhVec = obj.nbhMap(nbh);
            neighbor = nbhVec(obj.searchIdxByNbh(nbh));
            obj.searchIdxByNbh(nbh) = obj.searchIdxByNbh(nbh) + 1;
            if obj.searchIdxByNbh(nbh) > length(nbhVec)
                obj.depletedVec(nbhPermIdx) = 1;
            end
        end
    end
end

