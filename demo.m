clear; clc;

load('model.mat')

%% Model Kendaraan
k = 4; % kapasitas kendaraan
kendaraan = struct('kapasitas',0,'rute',{},'total_muatan',0,'jarak_ditempuh',0);
kendaraan(1).kapasitas = k;
kendaraan(1).total_muatan = 0;
kendaraan(1).jarak_ditempuh = 0;

%% Pembangkitan Solusi
n = n-1;
solusi = randperm(n)+1
r = titik(solusi);
d = permintaan(solusi);

%% Alokasi Permintaan (Split Delivery)

i=1; c=[]; ad=[]; tr=[];
while true
    c = [c,d(i)];
    if sum(c) <= k
        tr = [tr,r(i)];
        if i < n
            i = i + 1;
        else
            if numel(c) > 1
                ad = sum([ad,c(1:end-1)]);
            else
                ad = sum([ad,c]);
            end
            kendaraan(1).rute(end+1) = {[1,tr,1]};
            kendaraan(1).total_muatan = ad;
            break
        end
    else
        ad = sum([ad,c(1:end-1)]);
        kendaraan(1).rute(end+1) = {[1,tr,1]};
        kendaraan(1).total_muatan = ad;
        c=[]; tr=[];
    end
    
end


%% Evaluasi
for i=1:length(kendaraan(1).rute)
    kendaraan(1).jarak_ditempuh = kendaraan(1).jarak_ditempuh + evalCost(kendaraan(1).rute{i},dom);
end
kendaraan(1)

function cost = evalCost(route,dom)
cost = 0;
for i=1:length(route)-1
    m = route(i);
    n = route(i+1);
    cost = cost + dom(m,n);
end
end