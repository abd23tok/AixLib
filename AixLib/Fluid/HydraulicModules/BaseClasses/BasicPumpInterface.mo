within AixLib.Fluid.HydraulicModules.BaseClasses;
partial model BasicPumpInterface "Pump interface for different pump types"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    annotation (__Dymola_choicesAllMatching=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}),
        iconTransformation(extent={{110,-10},{90,10}})));
  PumpBus pumpBus annotation (
      Placement(transformation(extent={{-20,80},{20,120}}), iconTransformation(
          extent={{-20,80},{20,120}})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{20,-70},{60,-85},{20,-100},{20,-70}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=showDesignFlowDirection),
        Polygon(
          points={{20,-75},{50,-85},{20,-95},{20,-75}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=system.allowFlowReversal),
        Line(
          points={{55,-85},{-60,-85}},
          color={0,128,255},
          visible=showDesignFlowDirection),
        Ellipse(
          extent={{-80,90},{80,-70}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,161,107}),
        Polygon(
          points={{-28,64},{-28,-40},{54,12},{-28,64}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={220,220,220})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>2018-03-01 by Peter Matthes:<br>Improved parameter setup of pump model. Ordering in GUI, disabled some parameters that should be used not as input but rather as outputs (m_flow_start, p_a_start and p_b_start) and much more description in the parameter doc strings to help the user make better decisions.</li>
<li>2018-02-01 by Peter Matthes:<br>Fixes option choicesAllMatching=true for controller. Needs to be __Dymola_choicesAllMatching=true. Sets standard control algorithm to n_set (<code><span style=\"color: #ff0000;\">PumpControlNset</span></code>).</li>
<li>2018-01-30 by Peter Matthes:<br>* Renamed speed controlled pump model (red) from PumpNbound into PumpN as well as PumpPhysicsNbound into PumpPhysicsN. &quot;N&quot; stands for pump speed.<br>* Moved efficiencyCharacteristic package directly into BaseClasses. This is due to moving the older pump model and depencencies into the Deprecated folder.</li>
<li>2018-01-29 by Peter Matthes:<br>* Removes parameter useABCcurves as that is the default to calculate speed and is only needed in the blue pump (PumpH) to calculate power from speed and volume flow. Currently there is no other way to compute speed other than inverting function H = f(Q,N) . This can only be done with the quadratic ABC formula. Therefore, an assert statement has been implemented instead to give a warning when you want to compute power but you use more that the ABC coefficients in cHQN.<br>* Moves the energyBanlance and massBalance to the Assumptions tab as done in the PartialLumpedVolume model.<br>* Removes replaceable function for efficiency calculation. There is only one formula at the moment and no change in sight so that we can declutter the GUI.<br>* Removes parameter Nnom and replaces it with Nstart. As discussed with Wilo Nnom is not very useful and it can be replaced with a start value. The default value has been lowered to a medium speed to avoid collision with the speed/power limitation. For most pumps the maximum speed is limited for increasing volume flows to avoid excess power consumption.<br>* Increases Qnom from 0.5*Qmax to 0.67*Qmax as this would be a more realistic value.</li>
<li>2018-01-26 by Peter Matthes:<br>* In calculation of m_flow_start changes reference to X_start into physics.X_start.<br>* Changes Nnom from 80 &percnt; to 100 &percnt; of Nmax.</li>
<li>2018-01-15 by Peter Matthes:<br>Changes minimum mass flow rate in ports to +/-<code>1.5*<span style=\"color: #ff0000;\">max</span>(pumpParam.maxMinSpeedCurves[:,&nbsp;1])</code> in order to reduce search space.</li>
<li>2018-01-10 by Peter Matthes:<br>Adds parameter T_start to be compatible with PumpPyhsicsNbound model. This way this parameter can be transfert automatically when changing classes.</li>
<li>2017-12-12 by Peter Matthes:<br>Changes parameter name n_start into Nnom.</li>
<li>2017-12-05 by Peter Matthes:<br>Initial implementation (derived from Pump model with limitation of pump head). Changes nominal volume flow rate to &quot;Qnom=0.5*max(pumpParam.maxMinSpeedCurves[:,1])&quot;.</li>
</ul>
</html>", info="<html>
<h4>Main equations</h4>
<p>xxx </p>
<h4>Assumption and limitations</h4>
<p>Note assumptions such as a specific definition ranges for the model, possible medium models, allowed combinations with other models etc. There might be limitations of the model such as reduced accuracy under specific circumstances. Please note all those limitations you know of so a potential user won&apos;t make too serious mistakes </p>
<h4>Typical use and important parameters</h4>
<p>xxx </p>
<h4>Options</h4>
<p>xxx </p>
<h4>Dynamics</h4>
<p>Describe which states and dynamics are present in the model and which parameters may be used to influence them. This need not be added in partial classes. </p>
<h4>Validation</h4>
<p>Describe whether the validation was done using analytical validation, comparative model validation or empirical validation. </p>
<h4>Implementation</h4>
<p>xxx </p>
<h4>References</h4>
<p>xxx </p>
</html>"));
end BasicPumpInterface;
