function [rotatedData] = rotate90(data)
for i=1:size(data{1,1},1)
    rotatedData{1,1}{i,1} = rot90(data{1,1}{i,1});
end
display('Rotated by 90 degrees.');
end