function imnew = med2d(im,N)
N2 = N^2;
N = N-1;
A = 0:N;
imnew = zeros(size(im));
for j = 1:(size(im,2)-N)
    for k = 1:(size(im,1)-N)
        imnew(k,j) = median(reshape(im(k+A,j+A),1,N2));
    end
end
for j = size(im,2)+((-N+1):0)
    imnew(:,j) = median(im(:,j));
end
for k = size(im,1)+((-N+1):0)
    imnew(k,:) = median(im(k,:));
end
