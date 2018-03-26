function mean = mylocalmean(f, nhood)

% create mean filter
total = sum(sum(nhood));
h = nhood/total;
mean = imfilter(f, h, 'symmetric');

end


