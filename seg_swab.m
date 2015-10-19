function segment = bottomUp(data,num_segments,forceplot)
% not my code
% This function approximates a time series by a sequence of piecewise linear segments. 
% This version is uncommented, email the author for details.

left_x = [1 : 2 : size(data,1)-1];
right_x      = left_x + 1;
right_x(end) = size(data,1);
number_of_segments = length(left_x );

for i = 1 : number_of_segments 
   segment(i).lx = left_x(i);
   segment(i).rx = right_x(i);
   segment(i).mc = inf;
end;

for i = 1 : number_of_segments - 1
   coef = polyfit([segment(i).lx :segment(i+1).rx]',data(segment(i).lx :segment(i+1).rx),1);
   best = (coef(1)*( [segment(i).lx :segment(i+1).rx]' ))+coef(2);
   segment(i).mc = sum((data([segment(i).lx :segment(i+1).rx]')-best).^2);
end;

while  length(segment) > num_segments  
   [value, i ] = min([segment(:).mc]);

   if i > 1 & i < length(segment) -1								
    	coef = polyfit([segment(i).lx :segment(i+2).rx]',data(segment(i).lx :segment(i+2).rx),1);
    	best = (coef(1)*( [segment(i).lx :segment(i+2).rx]' ))+coef(2);
        segment(i).mc = sum((data([segment(i).lx :segment(i+2).rx]')-best).^2);
        segment(i).rx = segment(i+1).rx;
    	segment(i+1) = [];
    	i = i - 1;
        coef = polyfit([segment(i).lx :segment(i+1).rx]',data(segment(i).lx :segment(i+1).rx),1);
    	best = (coef(1)*( [segment(i).lx :segment(i+1).rx]' ))+coef(2);
      segment(i).mc = sum((data([segment(i).lx :segment(i+1).rx]')-best).^2);
   elseif i == 1
	coef = polyfit([segment(i).lx :segment(i+2).rx]',data(segment(i).lx :segment(i+2).rx),1);
    	best = (coef(1)*( [segment(i).lx :segment(i+2).rx]' ))+coef(2);
    	segment(i).mc = sum((data([segment(i).lx :segment(i+2).rx]')-best).^2);
	 segment(i).rx = segment(i+1).rx;
        segment(i+1) = [];      
   else
      segment(i).rx = segment(i+1).rx;
      segment(i).mc = inf;
      segment(i+1) = [];
      i = i - 1;
      coef = polyfit([segment(i).lx :segment(i+1).rx]',data(segment(i).lx :segment(i+1).rx),1);
      best = (coef(1)*( [segment(i).lx :segment(i+1).rx]' ))+coef(2);
      segment(i).mc = sum((data([segment(i).lx :segment(i+1).rx]')-best).^2);
   end;
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