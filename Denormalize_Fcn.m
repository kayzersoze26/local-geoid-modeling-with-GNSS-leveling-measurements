
function x=Denormalize_Fcn(xN,MinX,MaxX)

x = ((xN+1)/2).*(MaxX - MinX)+MinX
end