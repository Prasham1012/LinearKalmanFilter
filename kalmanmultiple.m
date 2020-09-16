
tf=50;
t0=0;
dt = 0.1;

observationmodel = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1;1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1]

I = eye(8)

positionmeasurementmean1 = 0;
positionmeasurementstd1 = 10;
positionmeasurementerror1 = positionmeasurementstd1.*randn(2,501)

velocitymeasurementmean1 = 0;
velocitymeasurementstd1 = 0.1;
velocitymeasurementerror1 = velocitymeasurementstd1.*randn(2,501)

positionmeasurementmean2 = 0;
positionmeasurementstd2 = 5;
positionmeasurementerror2 = positionmeasurementstd2.*randn(2,501)

velocitymeasurementmean2 = 0;
velocitymeasurementstd2 = 0.05;
velocitymeasurementerror2 = velocitymeasurementstd2.*randn(2,501)

observationnoise = vertcat(positionmeasurementerror1, velocitymeasurementerror1, positionmeasurementerror2, velocitymeasurementerror2)

positionstatemean = 0;
positionstatestd = 1;

velocitystatemean = 0;
velocitystatestd = 0.01;

statetransition=[1,0,dt,0;0,1,0,dt;0,0,1,0;0,0,0,1];

posteriorestimatecovariance = [1,0,0,0;0,1,0,0;0,0,0.0001,0;0,0,0,0.0001];
estimatecovariance = [1,0,0,0;0,1,0,0;0,0,0.0001,0;0,0,0,0.0001];
observationcovariance = [100,0,0,0,0,0,0,0;0,100,0,0,0,0,0,0;0,0,0.01,0,0,0,0,0;0,0,0,0.01,0,0,0,0;0,0,0,0,25,0,0,0;0,0,0,0,0,25,0,0;0,0,0,0,0,0,0.0025,0;0,0,0,0,0,0,0,0.0025];

prefitcovariance = observationmodel*posteriorestimatecovariance*transpose(observationmodel) + observationcovariance;

invp = inv(prefitcovariance);
obsmt = transpose(observationmodel);
inobs = obsmt*invp;

kalmangain = posteriorestimatecovariance*obsmt*invp;

time = t0:dt:tf 
n = (tf - t0)/dt;

for j=1:n+1
statepositionsless(:,j)=[0;0;10;10];
measuredpositions(:,j)=[0;0;10;10;0;0;10;10];
estimatedpositions(:,j)=[0;0;10;10;0;0;10;10];
statepositions(:,j)=[0;0;10;10];
measurementresidual(:,j)=[0;0;0;0;0;0;0;0];
end

for j=2:n+1
    statepositionsless(:,j) = statetransition*statepositions(:,j-1);
    posteriorestimatecovariance = statetransition*posteriorestimatecovariance*transpose(statetransition);
    measuredpositions(:,j) = observationmodel*statepositionsless(:,j) + observationnoise(:,j);
    estimatedpositions(:,j) = measuredpositions(:,j) - observationmodel*statepositionsless(:,j);
    prefitcovariance = observationmodel*posteriorestimatecovariance*transpose(observationmodel) + observationcovariance;
    kalmangain = posteriorestimatecovariance*transpose(observationmodel)*inv(prefitcovariance);
    statepositions(:,j) = statepositionsless(:,j) + kalmangain*estimatedpositions(:,j);
    estimatecovariance = (eye(4) - kalmangain*observationmodel)*posteriorestimatecovariance;
    measurementresidual(:,j) = measuredpositions(:,j) - observationmodel*statepositions(:,j);
end
  

plot(time,measuredpositions(1,:))
title('Measured X-Position')
xlabel('Time(in sec)')
ylabel('X-Position(in m)')

figure(2)
plot(time,measuredpositions(2,:))
title('Measured Y-Position')
xlabel('Time(in sec)')
ylabel('Y-Position(in m)')

figure(3)
plot(time,measuredpositions(3,:))
title('Measured X-Velocity')
xlabel('Time(in sec)')
ylabel('X-Velocity(in m/s)')

figure(4)
plot(time,measuredpositions(4,:))
title('Measured Y-Velocity')
xlabel('Time(in sec)')
ylabel('Y-Velocity(in m/s)')


figure(5)
plot(time,statepositions(1,:))
title('Estimated X-Position')
xlabel('Time(in sec)')
ylabel('X-Position(in m)')

figure(6)
plot(time,statepositions(2,:))
title('Estimated Y-Position')
xlabel('Time(in sec)')
ylabel('Y-Position(in m)')

figure(7)
plot(time,statepositions(3,:))
title('Estimated X-Velocity')
xlabel('Time(in sec)')
ylabel('X-Velocity(in m/s)')

figure(8)
plot(time,statepositions(4,:))
title('Estimated Y-Velocity')
xlabel('Time(in sec)')
ylabel('Y-Velocity(in m/s)')
    