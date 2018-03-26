Magnolia_means = [0.3675148	0.5603828	0.8361494	0.0283167	0.439941	0.17586514	0.8436304	0.5978698]
Magnolia_devs = [0.076175623	0.08211232	0.042670955	0.01003537	0.087328122	0.064059986	0.045322556	0.070679589]

Catalpa_means = [0.073798108	0.761925667	0.897749	0.040809933	0.841058333	0.374450167	0.408243437	0.798522167]
Catalpa_devs = [0.052672698	0.133478527	0.086458348	0.0175569	0.102139814	0.231238411	0.191157087	0.097597446]

Celtis_means = [0.274485577	0.696785962	0.8191875	0.169868442	0.519179615	0.190600885	0.797111538	0.418777115]
Celtis_devs = [0.055670702	0.129267092	0.07390977	0.0553498	0.080837332	0.082523854	0.048463865	0.097187379]

Prunus_means = [0.683951429	0.592197357	0.749441714	0.117953133	0.264619029	0.235078771	0.938578143	0.4046245]
Prunus_devs = [0.195537492	0.17958299	0.214251969	0.215913944	0.120976903	0.157245157	0.056033168	0.159786525]


headers = {'aspect_ratio', 'rectangularity', 'convex_ratio', 'perimeter_ratio', 'sphericity', 'circularity', 'eccentricity', 'form_factor'};

for i = 1:8
    x = [0:0.002:1]
    dist1 = normpdf(x, Magnolia_means(i), Magnolia_devs(i))
    dist2 = normpdf(x, Catalpa_means(i), Catalpa_devs(i))
    dist3 = normpdf(x, Celtis_means(i), Celtis_devs(i))
    dist4 = normpdf(x, Prunus_means(i), Prunus_devs(i))
    
    subplot(8,1,i)
    plot(x, dist1)
    hold on
    plot(x, dist2)
    plot(x, dist3)
    plot(x, dist4)
    hold off
end