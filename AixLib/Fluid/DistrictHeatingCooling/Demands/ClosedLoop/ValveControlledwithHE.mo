within AixLib.Fluid.DistrictHeatingCooling.Demands.ClosedLoop;
model ValveControlledwithHE
  "Substation with fixed dT and Heat Exchanger"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model for water"
      annotation (choicesAllMatching = false);
  extends AixLib.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow(start=0),
    final dp(start=0),
    final allowFlowReversal=false,
    final m_flow_nominal = Q_flow_nominal/cp_default/dTDesign);

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(
    min=0) "Nominal heat flow rate added to medium (Q_flow_nominal > 0)";

  parameter Modelica.SIunits.Temperature TReturn
    "Fixed return temperature";

  parameter Modelica.SIunits.TemperatureDifference dTDesign(
    displayUnit="K")
    "Design temperature difference for the substation's heat exchanger";

  parameter Modelica.SIunits.TemperatureDifference dT_building(
    displayUnit= "K")
    "Design temperature difference for the building";

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=30000
    "Pressure difference at nominal flow rate"
    annotation(Dialog(group="Design parameter"));

  parameter Real deltaM=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance"));
  parameter Modelica.SIunits.Time tau=30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Dialog(tab="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation (Dialog(tab="Dynamics"));

  final parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default properties";
protected
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";

public
  Modelica.Blocks.Interfaces.RealInput Q_flow_input "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-138,68},{-98,108}})));
  Sensors.TemperatureTwoPort senT_supply_pri(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    tau=1) "Supply flow temperature sensor"
    annotation (Placement(transformation(extent={{-82,2},{-62,22}})));
  Actuators.Valves.TwoWayPressureIndependent valve(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    l2=1e-9,
    l=0.05,
    dpValve_nominal(displayUnit="bar") = 50000,
    use_inputFilter=false)
            "Control valve"
    annotation (Placement(transformation(extent={{-36,22},{-16,2}})));
  Modelica.Blocks.Interfaces.RealOutput dpOut
    "Output signal of pressure difference"
    annotation (Placement(transformation(extent={{98,70},{118,90}})));

  Modelica.Blocks.Continuous.LimPID PID(
    yMax=1,
    k=1,
    Ti=0.5,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMin=0.1)
             annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-50,-26})));
  Sensors.TemperatureTwoPort senT_return_pri(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    tau=1) annotation (Placement(transformation(extent={{64,2},{84,22}})));
  Sensors.TemperatureTwoPort senT_supply_sec(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    tau=0) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-12,-26})));

  Sources.FixedBoundary bou(
     redeclare package Medium = Medium,
    use_p=true,
    use_T=false,
    nPorts=1)
    annotation (Placement(transformation(extent={{-46,-64},{-26,-44}})));

  Modelica.Blocks.Sources.TimeTable T_set(table=[0,273.15 + 36; 7.0e+06,273.15 +
        36; 7.0e+06,273.15 + 35; 1.2e+07,273.15 + 35; 1.2e+07,273.15 + 25; 2.2e+07,
        273.15 + 25; 2.2e+07,273.15 + 35; 2.7e+07,273.15 + 35; 2.7e+07,273.15 +
        36; 3.1536e+07,273.15 + 36])
    annotation (Placement(transformation(extent={{-106,-58},{-86,-38}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{94,-66},{74,-46}})));
  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{124,-74},{104,-54}})));
  Movers.FlowControlled_m_flow fan(redeclare package Medium = Medium,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=2*m_flow_nominal)                                  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={2,-54})));
  MixingVolumes.MixingVolume vol(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=2*m_flow_nominal,
    T_start=293.15,
    V=0.5)
         annotation (Placement(transformation(extent={{56,-46},{36,-66}})));
  Sensors.TemperatureTwoPort senT_return_sec(
     m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    tau=0)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={40,-14})));
  HeatExchangers.DynamicHX1 dynamicHX(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0,
    Q_nom=m_flow_nominal*cp_default*20,
    m2_flow_nominal=2*m_flow_nominal,
    T1_start=323.15,
    T2_start=288.15,
    dT_nom=20) annotation (Placement(transformation(extent={{8,-4},{28,16}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=10)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-68,72})));
  Modelica.Blocks.Math.Add dT(k2=-1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-68,44})));
  Modelica.Blocks.Math.Gain gain1(k=m_flow_nominal*cp_default)
    annotation (Placement(transformation(extent={{-44,44},{-24,64}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.Blocks.Interfaces.RealOutput HeatMeter
    annotation (Placement(transformation(extent={{98,42},{118,62}})));
  Modelica.Blocks.Sources.Constant const(k=2*m_flow_nominal)
    annotation (Placement(transformation(extent={{-46,-98},{-26,-78}})));
equation

  dpOut = dp;

  connect(port_a, senT_supply_pri.port_a)
    annotation (Line(points={{-100,0},{-92,0},{-92,12},{-82,12}},
                                                color={0,127,255}));
  connect(senT_supply_pri.port_b, valve.port_a)
    annotation (Line(points={{-62,12},{-36,12}},
                                               color={0,127,255}));
  connect(senT_return_pri.port_b, port_b)
    annotation (Line(points={{84,12},{92,12},{92,0},{100,0}},
                                              color={0,127,255}));
  connect(PID.y, valve.y)
    annotation (Line(points={{-50,-15},{-50,0},{-26,0}},
                                                   color={0,0,127}));
  connect(port_a, port_a)
    annotation (Line(points={{-100,0},{-100,0},{-100,0}}, color={0,127,255}));
  connect(T_set.y, PID.u_s)
    annotation (Line(points={{-85,-48},{-50,-48},{-50,-38}}, color={0,0,127}));
  connect(senT_supply_sec.T, PID.u_m) annotation (Line(points={{-23,-26},{-38,
          -26}},                    color={0,0,127}));
  connect(gain.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{103,-64},{92,-64},{92,-56},{94,-56}},
                                                 color={0,0,127}));
  connect(Q_flow_input, gain.u) annotation (Line(points={{-118,88},{18,88},{18,96},
          {126,96},{126,-64}}, color={0,0,127}));
  connect(senT_supply_sec.port_b, fan.port_a)
    annotation (Line(points={{-12,-36},{-12,-54},{-8,-54}},color={0,127,255}));
  connect(prescribedHeatFlow.port, vol.heatPort) annotation (Line(points={{74,-56},
          {56,-56}},                   color={191,0,0}));
  connect(fan.port_b, vol.ports[1]) annotation (Line(points={{12,-54},{22,-54},{
          22,-46},{48,-46}},color={0,127,255}));
  connect(valve.port_b, dynamicHX.port_a1)
    annotation (Line(points={{-16,12},{8,12}},color={0,127,255}));
  connect(dynamicHX.port_b1, senT_return_pri.port_a)
    annotation (Line(points={{28,12},{64,12}}, color={0,127,255}));
  connect(senT_return_sec.port_b, dynamicHX.port_a2)
    annotation (Line(points={{40,-4},{40,0},{28,0}},   color={0,127,255}));
  connect(dynamicHX.port_b2, senT_supply_sec.port_a) annotation (Line(points={{8,0},{
          -12,0},{-12,-16}},                  color={0,127,255}));
  connect(vol.ports[2], senT_return_sec.port_a)
    annotation (Line(points={{44,-46},{40,-46},{40,-24}},color={0,127,255}));
  connect(bou.ports[1], fan.port_a) annotation (Line(points={{-26,-54},{-8,-54}},
                                color={0,127,255}));
  connect(senT_supply_pri.T, dT.u1) annotation (Line(points={{-72,23},{-74,23},
          {-74,32},{-74,32}}, color={0,0,127}));
  connect(senT_return_pri.T, dT.u2) annotation (Line(points={{74,23},{8,23},{8,
          22},{-62,22},{-62,32}}, color={0,0,127}));
  connect(dT.y, gain1.u) annotation (Line(points={{-68,55},{-50,55},{-50,54},{
          -46,54}}, color={0,0,127}));
  connect(gain1.y, product.u1) annotation (Line(points={{-23,54},{-8,54},{-8,56},
          {8,56}}, color={0,0,127}));
  connect(valve.y_actual, product.u2)
    annotation (Line(points={{-21,5},{-4,5},{-4,44},{8,44}}, color={0,0,127}));
  connect(product.y, HeatMeter) annotation (Line(points={{31,50},{70,50},{70,52},
          {108,52}}, color={0,0,127}));
  connect(Q_flow_input, greaterThreshold.u) annotation (Line(points={{-118,88},
          {-132,88},{-132,86},{-144,86},{-144,72},{-80,72}},   color={0,0,127}));
  connect(greaterThreshold.y, dynamicHX.u) annotation (Line(points={{-57,72},{
          -14,72},{-14,74},{22.4,74},{22.4,15.2}}, color={255,0,255}));
  connect(const.y, fan.m_flow_in) annotation (Line(points={{-25,-88},{-14,-88},
          {-14,-86},{2,-86},{2,-66}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}}),
        graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,-4},{-14,24}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,-4},{44,24}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,-54},{44,-26}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,-54},{-14,-26}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{52,70},{96,50}},
          lineColor={0,0,127},
          textString="PPum"),
        Polygon(
          points={{-86,38},{-86,-42},{-26,-2},{-86,38}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-8,40},{72,-40}},
          lineColor={238,46,47},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
A simple substation model using a fixed return temperature and the actual supply temperature
to calculate the mass flow rate drawn from the network. This model uses a linear control
valve to set the mass flow rate.

Please consider that this model is still in an early testing stage. The behavior is not 
verified. It seems that behavior may be problematic for low demands. In such cases, the
actual mass flow rate differs significantly from the set value.
</p>
</html>", revisions="<html>
<ul>
<li>
March 3, 2018, by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-100},{120,100}})));
end ValveControlledwithHE;