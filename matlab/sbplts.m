function sbplts(data, idx, isdiff, yr)

  if(numel(find(idx))==0)
    return
  end
  N = size(data,1);
  if(nargin()<3)
    isdiff=false;
  end

  if(isdiff)
    xx=mid(1:N+1);
    axx = [xx(1) xx(end) -.3 .3];
  else
    xx=1:N;
    axx = [xx(1) xx(end) .2 .9];
  end
  if(nargin()==4)
    axx(3:4)=yr;
  end  

  hold on
  plot(xx,data(:,idx),'color',[.7 .7 .7])
  plot(xx,mean(data(:,idx),2),'k','linewidth',2)
  plot(xx,mean(data(:,idx),2)+std(data(:,idx),[],2),'r','linewidth',2)
  plot(xx,mean(data(:,idx),2)-std(data(:,idx),[],2),'r','linewidth',2)
  axis(axx); grid;

end

