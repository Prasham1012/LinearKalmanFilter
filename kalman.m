
tf=50;
t0=0;
dt = 0.1;

observationmodel = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1]

positionmeasurementmean = 0;
positionmeasurementstd = 10;
positionmeasurementerror = positionmeasurementstd.*randn(2,501)

velocitymeasurementmean = 0;
velocitymeasurementstd = 0.1;
velocitymeasurementerror = velocitymeasurementstd.*randn(2,501)

observationnoise = vertcat(positionmeasurementerror, velocitymeasurementerror)

positionstatemean = 0;
positionstatestd = 1;

velocitystatemean = 0;
velocitystatestd = 0.01;

statetransition=[1,0,dt,0;0,1,0,dt;0,0,1,0;0,0,0,1];

posteriorestimatecovariance = [1,0,0,0;0,1,0,0;0,0,0.0001,0;0,0,0,0.0001];
estimatecovariance = [1,0,0,0;0,1,0,0;0,0,0.0001,0;0,0,0,0.0001];
observationcovariance = [100,0,0,0;0,100,0,0;0,0,0.01,0;0,0,0,0.01];

prefitcovariance = observationmodel*posteriorestimatecovariance*transpose(observationmodel) + observationcovariance;

kalmangain = posteriorestimatecovariance*transpose(observationmodel)*((prefitcovariance)\(observationmodel));

time = t0:dt:tf 
n = (tf - t0)/dt;

for j=1:n+1
statepositionsless(:,j)=[0;0;10;10];
measuredpositions(:,j)=[0;0;10;10];
estimatedpositions(:,j)=[0;0;10;10];
statepositions(:,j)=[0;0;10;10];
measurementresidual(:,j)=[0;0;0;0];
end

for j=2:n+1
    statepositionsless(:,j) = statetransition*statepositions(:,j-1);
    posteriorestimatecovariance = statetransition*posteriorestimatecovariance*transpose(statetransition);
    measuredpositions(:,j) = observationmodel*statepositionsless(:,j) + observationnoise(:,j);
    estimatedpositions(:,j) = measuredpositions(:,j) - observationmodel*statepositionsless(:,j);
    prefitcovariance = observationmodel*posteriorestimatecovariance*transpose(observationmodel) + observationcovariance;
    kalmangain = posteriorestimatecovariance*transpose(observationmodel)*((prefitcovariance)\(observationmodel));
    statepositions(:,j) = statepositionsless(:,j) + kalmangain*estimatedpositions(:,j);
    estimatecovariance = (observationmodel - kalmangain*observationmodel)*posteriorestimatecovariance;
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
    