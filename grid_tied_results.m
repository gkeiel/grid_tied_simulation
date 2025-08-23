% result plots
f_save = 0;
t   = v_c(:,1);
v_o = v_ref(:,2);


%% output voltage
fig = 1;
figure(fig)
plot(t,v_c(:,2),'k')
xlabel('Time (s)')
ylabel('Voltage (V)')
legend('Ouput voltage')
grid on
if f_save == 1
    save('v_c','t','v_c');
end


%% inductor current
fig = fig +1;
figure(fig)
plot(t,i_L(:,2),'k')
xlabel('Time (s)')
ylabel('Current (A)')
legend('Inductor current')
grid on
if f_save == 1
    save('i_L','t','i_L');
end
    

%% output current
fig = fig +1;
figure(fig)
plot(t,i_o(:,2))
hold on
plot(t,i_o(:,3))
xlabel('Time (s)')
ylabel('Current (A)')
legend('Reference current','Ouput current')
grid on
if f_save == 1
    save('i_o','t','i_o');
end


%% control signal
fig = fig +1;
figure(fig)
plot(t,u(:,3))
hold on
plot(t,u(:,2),'r--')
hold on
plot(t,u(:,4),'r--')
xlabel('Time (s)')
ylabel('Voltage (V)')
legend('Control signal')
grid on
if f_save == 1
    save('u','t','u');
end