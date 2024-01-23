function outmask = support_restrictMaskToNumVals(inmask, numpass, valtopass, align)

    if valtopass == true
        outmask = false(length(inmask),1);
    else
        outmask = true(length(inmask),1);
    end
    
    wherevals = find(inmask==valtopass);
    
    if align == 1
        wherevals = wherevals(1:numpass,1);
    else
        wherevals = wherevals((length(wherevals)-numpass+1):length(wherevals),1);
    end
    
    outmask(wherevals) = valtopass;

end