function segment = topDown(data,num_segments,forceplot)
%First init 
segment.lx = 1;
segment.rx = size(data,1);
segment.mc = Inf;
function seg = topDownSeg(data,f_lx)
    SS = size(data,1);
    if(SS == 2)
        seg.lx = f_lx;
        seg.rx = f_lx + SS - 1;
        seg.mc = 0;
        return;
    end
    iter = 2;%2 to SS - 1
    min_mc = Inf;
    for iter=2:(SS - 2)
        t_seg(1).lx = 1;
        t_seg(1).rx = iter;
        coef = polyfit([t_seg(1).lx:t_seg(1).rx]',data(t_seg(1).lx :t_seg(1).rx),1);
        best = coef(1)*([t_seg(1).lx:t_seg(1).rx]') + coef(2);
        t_seg(1).mc = sum((data([t_seg(1).lx :t_seg(1).rx]') - best).^2);
        t_seg(2).lx = iter + 1;
        t_seg(2).rx = SS;
        coef = polyfit([t_seg(2).lx:t_seg(2).rx]',data(t_seg(2).lx :t_seg(2).rx),1);
        best = coef(1)*([t_seg(2).lx:t_seg(2).rx]') + coef(2);
        t_seg(2).mc = sum((data([t_seg(2).lx :t_seg(2).rx]') - best).^2);
        t_mc = t_seg(2).mc + t_seg(1).mc;
        if(min_mc > t_mc)
            min_mc = t_seg(1).mc + t_seg(2).mc;
            seg = t_seg;
        end
    end
    seg(1).lx = f_lx;
    seg(1).rx = seg(1).rx + f_lx - 1;
    seg(2).lx = seg(2).lx + f_lx - 1;
    seg(2).rx = seg(2).rx + f_lx - 1;
end

while  length(segment) < num_segments 
    t_seg = segment(1);
    t_lx  = t_seg.lx; 
    new_seg = topDownSeg(data([t_seg.lx :t_seg.rx]),t_lx);
    segment = [segment new_seg];
    segment(1) = [];
end;

%----------------------------------------------

residuals=[];

for i = 1 : length(segment) 
        coef = polyfit([segment(i).lx :segment(i).rx]',data(segment(i).lx :segment(i).rx),1);
    	best = (coef(1)*( [segment(i).lx :segment(i).rx]' ))+coef(2);
        residuals = [    residuals ; sum((data([segment(i).lx :segment(i).rx]')-best).^2)];
end;

if nargin > 2
    hold on;
    plot(data,'r');
end; 

temp = [];

for i = 1 : length(segment) 
    coef = polyfit([segment(i).lx :segment(i).rx]',data(segment(i).lx :segment(i).rx),1);
    best = (coef(1)*( [segment(i).lx :segment(i).rx]' ))+coef(2);
    segment(i).ly = best(1);
    segment(i).ry = best(end);
    segment(i).mc = [];
    if nargin > 2
        plot([segment(i).lx :segment(i).rx]', best,'b');
    end;
        temp = [temp; [segment(i).ly segment(i).ry]];
    end;

if nargin > 2
    for i = 1 : length(segment)  - 1 
        plot([segment(i).rx :segment(i+1).lx]', [ temp(i,2) temp(i+1,1)  ],'g');
    end;
end;
end