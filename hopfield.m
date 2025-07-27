function [] = hopfield(Dist)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
imagefiles = dir('*.PNG');
nfiles = length(imagefiles) %-> #Patrones
Neuronas=nfiles*2/0.15; %-> #neuronas en funcion de # de patrones
dim=round(sqrt(Neuronas))%-> dimensiones de la imagen en funcion de #neuronas

for ii=1:nfiles %Lee todas las imagenes en la carpeta (.PNG)
   currentfilename = imagefiles(ii).name;
   currentimage = imread(currentfilename);
   images{ii} = currentimage;
   images2{ii}=currentimage;
end

for i=1:nfiles%binariza y procesa
    images{i} = im2bw(images{i}); 
    images{i} = imcomplement(images{i});
    s=regionprops(images{i});
    images{i}=imcrop(images{i},s.BoundingBox);
    images{i} = imcomplement(images{i});
end

for i=1:nfiles%cambia tamaño y normaliza (-1 a 1)
    images{i} = imresize(images{i},[dim dim]);
    images{i} = (images{i}.*2)-1;
end

for i=1:nfiles%columniza las imagenes
    images{i} = images{i}(:);
end

patrones = zeros(dim^2, nfiles);%matriz para guardar las 
%imagenes columnizadas

for i=1:nfiles
    patrones(1:dim^2,i)=images{i}; %llena patrones
%     imshow(ensamb(images{i},dim,dim),'InitialMagnification','fit');
%     pause(0.5);
end

N=size(patrones,1);%->#neuronas
M=nfiles; %->Patrones


Pi=((patrones'*patrones)^-1)*patrones';%pseudoinversa patrones
W=patrones*Pi; %Creacion matriz pesos

[im,~,~]=uigetfile('*.png');%lee la imagen escogida
prueba=imread(im);
prueba=im2bw(prueba);%binariza

prueba=imcomplement(prueba);%procesa
s=regionprops(prueba);
prueba=imcrop(prueba,s.BoundingBox);
prueba=imcomplement(prueba);

prueba=imresize(prueba,[dim dim]);%cambia tamaño


imshow(prueba,'InitialMagnification','fit');

prueba=prueba(:);

n=length(prueba);%#pixeles en la imagen

nu=round(Dist*n/100);%#cuantos distorsionará

ran=randperm(n,nu);
    for i=1:nu
        prueba(ran(i))=(prueba(ran(i))*-1)+1;
    end%Distorsion
 
prueba=ensamb(prueba,dim,dim);
 
prueba=(prueba.*2)-1;%normalizar
imshow(prueba,'InitialMagnification','fit');%imagen distorsionada
 
prueba=prueba(:);
c=0;

    while true
        c=c+1

         
        
        imshow(ensamb(prueba,dim,dim),'InitialMagnification','fit');
        drawnow
        
      

        pruebaant=prueba;%almacenar anterior
        S=W*prueba;%evaluar matriz de pesos
        for i=1:length(S)
            if S(i)==0
                S(i)==pruebaant(i)
            end
        end
        prueba=S>0;%funcion escalon 
        prueba=(prueba.*2)-1;%normalizar
        if pruebaant==prueba
           
                break
            
        end
    end
end

