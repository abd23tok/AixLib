within AixLib.Systems.Benchmark_fb;
model Benchmark_MODI
   extends Modelica.Icons.Example;
  AixLib.Systems.Benchmark_fb.BenchmarkBuilding benchmarkBuilding
    annotation (Placement(transformation(extent={{-36,-80},{44,-26}})));
  CCCS.Evaluation_CCCS evaluation_CCCS
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  MODI.Controlling_MODI controlling_MODI
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(benchmarkBuilding.mainBus, evaluation_CCCS.mainBus) annotation (Line(
      points={{0,-26.4},{0,10},{40,10}},
      color={255,204,51},
      thickness=0.5));
  connect(benchmarkBuilding.mainBus, controlling_MODI.mainBus) annotation (Line(
      points={{0,-26.4},{0,10},{-40,10}},
      color={255,204,51},
      thickness=0.5));
  connect(benchmarkBuilding.y, controlling_MODI.TAirOutside) annotation (Line(
        points={{-30.4,-24.6},{-30.4,14},{-39.2,14}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Benchmark_MODI;
