function p = makeParticles(dispersion,streak,Q,N,filen)

% dispersion in m
% streak in umx/degS
% Q in pC

if nargin < 5
    [filen baseDir] = uigetfile('ProfMon-*.mat','Load ProfMon file');
    if ~filen
        return
    end
    fn = [baseDir filen];
    load(fn)
else
    load(filen)
end
img = double(flipud(flipud(data.img).'));
img = crop2(img);
Nsamp = 10;
noise = std(reshape(img(1:Nsamp,1:Nsamp),1,Nsamp^2));
m = mean(reshape(img(1:Nsamp,1:Nsamp),1,Nsamp^2));
img = med2d(img,4);
img = img - m - 3*noise;
img(img < 0) = 0;
img = img./sum(sum(img));

px2mm = data.res/(streak/0.9726)*0.3;
px2perc = data.res/dispersion*1e-4;
p = particles2D(img, N).';
toffs = mean(p(:,1));
doffs = mean(p(:,2));
p(:,1) = p(:,1) - toffs;
p(:,2) = p(:,2) - doffs;
p(:,1) = p(:,1)*px2mm;
p(:,2) = p(:,2)*px2perc;


curr = sum(img,1);
t = ((1:size(img,2))-toffs)*px2mm;
curr = Q*curr/abs(px2mm)*0.3;
eproj = sum(img,2).';
dE = ((1:size(img,1))-doffs)*px2perc;

f = figure('color','w','windowstyle','docked');
figure(f)
ax(1) = subplot(3,1,[1,2]);
ax(2) = subplot(3,1,3);
imagesc(t,dE,img,'parent',ax(1))
colormap(ax(1),chrisColor);
axis(ax(1),'xy')
set(ax(1),'fontname','times','fontsize',14)
ylabel(ax(1),'\delta (%)')
title(ax(1),filen,'fontsize',14,'interpreter','none')
%xlim(ax(1),[-1 1]*7);
%ylim(ax(1),[-5 5]);
xl = get(ax(1),'xlim');
lo = find(eproj/max(eproj) >= 0.02,1,'first');
lo = max([1,lo-20]);
hi = find(eproj/max(eproj) >= 0.02,1,'last');
hi = min([length(eproj),hi+20]);
set(ax(1),'ylim',[dE(lo), dE(hi)]);
yl = get(ax(1),'ylim');
eproj = 0.25*(eproj/max(eproj)* diff(xl)) + xl(1);
hold(ax(1),'on')
plot(ax(1), eproj,dE,'-k','linewidth',2)
hold(ax(1),'off')
plot(ax(2), t,curr,'-k','linewidth',2)
xlim(ax(2),xl)
yl = get(ax(2),'ylim');
set(ax(2),'ylim',[0 yl(2)]*1.05);
set(ax(2),'fontname','times','fontsize',14)
xlabel(ax(2),'{\itz} (mm)')
ylabel(ax(2),'{\itI} (A)')
title(ax(2),'Distribution preview, [ENTER] to save')
drawnow
pause
title(ax(2),'')
[fn, pn] = uiputfile('*.zd','Save LiTrack zd output...');
if ischar(fn)
    dlmwrite([pn fn], [p(:,1),p(:,2)],'delimiter',' ','precision',13);
else
    disp('No output file chosen. No LiTrack file created.')
end


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

function part = particles2D(img, N)
if ~isfloat(img);img = double(img);end;
xproj = sum(img,1);
xproj(xproj == 0) = max(xproj)*1e-12;
xproj = xproj./sum(xproj);
cumx = cumsum(xproj);
part = rand(2,N); %uniform random in x-y
part(1,:) = interp1(cumx,1:length(cumx),part(1,:),'pchip'); % x now distributed by marginal
cumy = zeros(size(img));
for k = 1:size(img,2)
    ysli = img(:,k);
    if ~any(ysli)
        ysli = ones(size(ysli));
    end
    ysli(ysli==0) = max(ysli)*1e-12;
    ysli = ysli./sum(ysli);
    cumy(:,k) = cumsum(ysli);
end
[~,bin] = histc(part(1,:),linspace(-0.5,size(img,2)+0.5,size(img,2)+1)); %which bin for each?
y = (1:size(img,1)).';
for k = unique(bin) %only do bins with particles
    if k ==0;continue;end
    incl = find(k == bin); %particles in this bin
    %if ~isempty(incl)
        part(2,incl) = interp1(cumy(:,k),y,part(2,incl),'pchip');
    %end
end




function [newdata,xpix,ypix] = crop2(data)
% Crop a 2D array with GUI.
% Inputs:
%   data = 2D array of data
% Outputs:
%   newdata = Cropped 2D data
%   xpix = Indices of the columns included in crop (dimension/size
%           corresponds to second dimension of newdata array, new x-axis)
%   ypix = Indices of the rows included in crop (dimension/size 
%           corresponds to first dimension of newdata array, new y-axis)
%
% If the user makes no changes or exits for any reason, the outputs equal
% the inputs. Note that it's possible to crop down to a single point.
sz = size(data);
if length(sz) > 2
    error('Dimensionality of input data cannot exceed 2.')
end
xold = 1:sz(2);
yold = 1:sz(1);
f = figure('color','w','toolbar','none','name','Crop 2D array');
%going to have two side-by-side figures, so just some footwork to setup a
%2:1 aspect ratio for the figure.
s = get(f,'position');
set(f,'units','pixels','position',[s(1), s(2), s(4)*2, s(4)])
%canc = 0; %(used to use this for an exit flag in the loop)
while 1 %a little dangerous. pretty sure the user can always hit a break, though.
    figure(f)
    subplot(1,2,1)
    imagesc(abs(data))
    axis xy
    colormap(chrisColor)
    cl = caxis; %save the original coloring for rending the cropped image
    if (size(data,2)/size(data,1)<10)&&(size(data,1)/size(data,2)<10)
        axis image %if the aspect ratio isn't super narrow, set axes for dx/dy spacings = 1:1.
        title('Select first corner or [Esc] to skip crop.')
    else
        title([{'Select first corner or [Esc] to skip crop.'},{'(Axes not square.)'}])
    end
    [x1,y1,button] = ginput(1);
    if isempty(button) %can happen if they push [enter]
        continue
    end
    if any(button == [1,2,3])&&~isempty(x1)&&~isempty(y1)  %user clicked and a point was selected
        x1 = max([.51,x1]);  %make sure they stayed inside the plotting region
        x1 = min([x1,sz(2)+.49]); %if any are out of bounds, it pushes their selection...
        y1 = max([.51,y1]); %... back into the nearest valid edge of the plot area
        y1 = min([y1,sz(1)+.49]); %so if you want to go to the edge, click ...
        hold on; %...outside the limiting corner of the plot
        plot([0 sz(2)+1],[y1 y1],'-g',[x1 x1],[0 sz(1)+1],'-g') %plots first crosshair
        hold off;
        title('Select second corner or [Esc] to skip crop.')
        [x2,y2,button] = ginput(1);
        title([]);
        if isempty(button) %can happen if they push [enter]
            continue
        end
        if any(button == [1,2,3])&&~isempty(x2)&&~isempty(y2) %for second click, logic is same as above
            x2 = max([.51,x2]);
            x2 = min([x2,sz(2)+.49]);
            y2 = max([.51,y2]);
            y2 = min([y2,sz(1)+.49]);
            hold on;
            plot([0 sz(2)+1],[y2 y2],'-g',[x2 x2],[0 sz(1)+1],'-g') %add second crosshair
            hold off;
            x = [min(round([x1,x2])) max(round([x1,x2]))]; %sort out which corners were the limits
            y = [min(round([y1,y2])) max(round([y1,y2]))];
            newdata = data(y(1):y(2),x(1):x(2)); %crop up the selection
            xpix = xold(x(1):x(2)); %...and the axis indexes chosen. the calling
            ypix = yold(y(1):y(2)); %...function may need to know the region
            figure(f)
            subplot(1,2,2)
            h = imagesc(x(1):x(2),y(1):y(2),abs(newdata)); %show the cropped data for comparison
            axis xy
            colormap(chrisColor)
            if (size(newdata,2)/size(newdata,1)<10)&&(size(newdata,1)/size(newdata,2)<10)
                axis image
                title('Cropped selection') %if the aspect ratio isn't super narrow, set axes for dx/dy spacings = 1:1.
            else
                title('Cropped selection (axes not square)')
            end
            caxis(cl) %use same color scaling for comparison
            button = questdlg('Accept cropped data?','Crop','Accept','Try again','Cancel','Accept');
            delete(h) %clear the cropped image
            switch button
                case 'Accept'
                    break
                case 'Try again'
                    continue
                case 'Cancel'
                    newdata = data;
                    xpix = xold;
                    ypix = yold;
                    break
            end
        elseif button == 27
            newdata = data;
            xpix = xold;
            ypix = yold;
            break
        else
            continue;
        end
    elseif button == 27
        newdata = data;
        xpix = xold;
        ypix = yold;
        break
    else
        continue
    end
end
close(f) %clean up our figure window
