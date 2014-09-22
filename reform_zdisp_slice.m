function [dX, dY, dZ] = reform_zdisp_slice(zdisp_1, nodes);
% function [dX, dY, dZ] = reform_zdisp_slice(zdisp_1, nodes);
% 
% takes one time slice, that is, a 2D matrix extracted from 
% the 3D zdisp matrix.  zdisp has a structure wherein the first
% index determines the node, the second selects amoung node number, 
% X, Y and Z displacent, and the third index selects the time step.
% So the size of zdisp is NumNodes x 4 x NumTimeSteps 
%
% So your input zdisp_slice you get from zdisp like so:
% zdisp_slice=zdisp(:,:,timestep);
%
% dX, dY, and dZ are 3D matricies of node displacements extracted from 
% zdisp_slice and arranged in the format of nodes.  nodes is a 3D
% matrix generated by read_dot_dyn
%
% dX, dY, dZ can be used as inputs to scat_and_disp.m
%
                                                                                
% sort zdisp_1 by node number
zdisp_1=sortrows(zdisp_1,[1]);
                                                                                
% stretch nodes into a vector, call it t_nodes, and sort it by node number
t_nodes=nodes(:);
[t_nodes,idx]=sort(t_nodes);
                                                                                
% zdisp_1 and t_nodes are now in correspondance by node number
                                                                                
% calculate the sort index r_idx to go from the sorted back to the
% (possibly scrambled, possibly not) old order
ord = 1:length(t_nodes);
[dummy,r_idx] = sort(ord(idx));
                                                                                
% put zdisp_1 in the order t_nodes _was_ in, so that when rolled back into a 3D
% matrix it'll be in correspondance in terms of node number
zdisp_1 = zdisp_1(r_idx,:,:);
dX = zdisp_1(:,2);
dY = zdisp_1(:,3);
dZ = zdisp_1(:,4);

% Apply the same de/rescramble to t_nodes.  After this line, it should be in
% the same order as it was before it got sorted, i.e. should equal nodes(:)
t_nodes = t_nodes(r_idx);
                                                                                
% roll the vectors into appropriately shaped 3D arrays
dX = reshape(dX, size(nodes,1), size(nodes,2), size(nodes,3));
dY = reshape(dY, size(nodes,1), size(nodes,2), size(nodes,3));
dZ = reshape(dZ, size(nodes,1), size(nodes,2), size(nodes,3));
                                                                                
% Next two lines are debug lines
% Checks that the unroll-sort-unsort-reroll process is really idempotent
t_nodes = reshape(t_nodes, size(nodes,1), size(nodes, 2), size(nodes, 3));
if ~isempty(find(t_nodes~=nodes)),
    % making sure the sort/reverse sort works
    error('algorithm failure/logic error');
end;
