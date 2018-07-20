within AixLib.Building.Benchmark;
model FullModel
  Weather weather
    annotation (Placement(transformation(extent={{50,82},{70,102}})));
  Buildings.Office office
    annotation (Placement(transformation(extent={{30,0},{92,60}})));
  Generation.Generation generation
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Transfer.Transfer_TBA.Full_Transfer_TBA full_Transfer_TBA
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Transfer.Transfer_RLT.Full_Transfer_RLT full_Transfer_RLT
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=10)
    annotation (Placement(transformation(extent={{-34,62},{-14,82}})));
equation
  connect(weather.AirTemp, office.HeatPort_OutdoorTemp) annotation (Line(points={{60,82},
          {60,60},{61,60}},                   color={191,0,0}));
  connect(weather.WindSpeed_North, office.WindSpeedPort_North) annotation (Line(
        points={{70,100},{100,100},{100,54},{92,54}},
                                                    color={0,0,127}));
  connect(weather.WindSpeed_East, office.WindSpeedPort_East) annotation (Line(
        points={{70,96},{100,96},{100,45},{92,45}}, color={0,0,127}));
  connect(weather.WindSpeed_South, office.WindSpeedPort_South) annotation (Line(
        points={{70,92},{100,92},{100,36},{92,36}}, color={0,0,127}));
  connect(weather.WindSpeed_West, office.WindSpeedPort_West) annotation (Line(
        points={{70,88},{100,88},{100,27},{92,27}}, color={0,0,127}));
  connect(office.WindSpeedPort_Hor, weather.WindSpeed_Hor) annotation (Line(
        points={{85.8,60},{86,60},{86,84},{70,84}}, color={0,0,127}));
  connect(generation.Fluid_out_cold, full_Transfer_TBA.Fluid_in_cold)
    annotation (Line(points={{-60,-54},{-40,-54},{-40,-80},{40,-80},{40,-80},{
          40,-54},{60,-54}},
        color={0,127,255}));
  connect(generation.Fluid_in_cold, full_Transfer_TBA.Fluid_out_cold)
    annotation (Line(points={{-60,-58},{-40,-58},{-40,-80},{40,-80},{40,-58},{
          60,-58}},
        color={0,127,255}));
  connect(full_Transfer_TBA.HeatPort_TBA, office.Heatport_TBA) annotation (Line(
        points={{70,-40},{70,-20},{85.8,-20},{85.8,0}}, color={191,0,0}));
  connect(generation.Fluid_out_hot, full_Transfer_RLT.Fluid_in_hot) annotation (
     Line(points={{-60,-42},{-6,-42},{-6,-42},{0,-42}}, color={0,127,255}));
  connect(generation.Fluid_in_hot, full_Transfer_RLT.Fluid_out_hot) annotation (
     Line(points={{-60,-46},{-8,-46},{-8,-46},{0,-46}}, color={0,127,255}));
  connect(full_Transfer_RLT.Fluid_in_cold, generation.Fluid_out_cold)
    annotation (Line(points={{0,-54},{-60,-54}}, color={0,127,255}));
  connect(full_Transfer_RLT.Fluid_out_cold, generation.Fluid_in_cold)
    annotation (Line(points={{0,-58},{-60,-58}}, color={0,127,255}));
  connect(generation.Fluid_in_hot, generation.Fluid_out_warm)
    annotation (Line(points={{-60,-46},{-60,-48}}, color={0,127,255}));
  connect(generation.Fluid_out_warm, full_Transfer_TBA.Fluid_in_warm)
    annotation (Line(points={{-60,-48},{-40,-48},{-40,-80},{40,-80},{40,-47.4},
          {60,-47.4}}, color={0,127,255}));
  connect(full_Transfer_TBA.Fluid_out_warm, generation.Fluid_in_warm)
    annotation (Line(points={{60,-51.4},{40,-51.4},{40,-80},{-40,-80},{-40,-52},
          {-60,-52}}, color={0,127,255}));
  connect(weather.SolarRadiation_OrientedSurfaces1, office.SolarRadiationPort_North)
    annotation (Line(points={{51,99},{22,99},{22,54},{30,54}}, color={255,128,0}));
  connect(full_Transfer_RLT.Air_in, weather.Air_out)
    annotation (Line(points={{6,-40},{6,90},{50,90}}, color={0,127,255}));
  connect(realExpression.y, weather.m_flow_in1)
    annotation (Line(points={{-13,72},{55,72},{55,82}}, color={0,0,127}));
  connect(office.Air_out, weather.Air_in) annotation (Line(points={{36.2,0},{36,
          0},{36,-6},{14,-6},{14,86},{50,86}}, color={0,127,255}));
  connect(office.Air_in, full_Transfer_RLT.Air_out) annotation (Line(points={{
          48.6,0},{48.6,-20},{14,-20},{14,-40}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=5000, Interval=1));
end FullModel;
