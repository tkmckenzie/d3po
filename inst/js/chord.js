const outerRadius = Math.min(width, height) * 0.45;
const innerRadius = outerRadius * 0.9;
const bandWidth = (outerRadius - innerRadius) / 2;

chord = d3.chord()
	.padAngle(0.05)
	.sortSubgroups(d3.descending)
	.sortChords(d3.descending);

arc = d3.arc()
	.innerRadius(innerRadius)
	.outerRadius(outerRadius);

label_arc = d3.arc()
  .innerRadius(outerRadius)
  .outerRadius(outerRadius);

ribbon = d3.ribbon()
	.radius(innerRadius);

const range = d3.range(0, 1, 1 / (data.labels.length - 1)).concat([1]);
const colors = range.map(d3.interpolateSpectral);
color = d3.scaleOrdinal(colors)
  .domain(data.labels);

svg.attr("viewBox", [-width / 2, -height / 2, width, height])
  .attr("font-size", 10)
  .attr("font-family", "sans-serif");

const chords = chord(data.matrix);

const group = svg.append("g")
	.selectAll("g")
	.data(chords.groups)
	.enter().append("g");

group.append("path")
	.attr("fill", d => color(d.index))
	.attr("stroke", d => d3.rgb(color(d.index)).darker())
	.attr("d", arc);

svg.selectAll(".donutArcSlices")
  .data(chords.groups)
  .enter().append("path")
  .attr("class", "donutArcSlices")
  .attr("d", arc)
  .style("fill", function(d, i) {return color(i);})
  .each(function(d, i){
    var firstArcSection = /(^.+?)L/;
    var newArc = firstArcSection.exec(d3.select(this).attr("d"))[1];
    newArc = newArc.replace(/,/g , " ");
    
    svg.append("path")
      .attr("class", "hiddenDonutArcs")
      .attr("id", "arcID_" + i)
      .attr("d", newArc)
      .attr("fill", "none");
  });
  
group.append("text")
  .attr("dy", -10)
  .append("textPath")
    .attr("startOffset","50%")
    .attr("text-anchor","middle")
    .attr("xlink:href", function(d, i){return "#arcID_" + i;})
  .text(function(d) {return data.labels[d.index];});

svg.append("g")
		.attr("fill-opacity", 0.67)
	.selectAll("path")
	.data(chords)
	.enter().append("path")
		.attr("d", ribbon)
		.attr("fill", d => color(d.target.index))
		.attr("stroke", d => d3.rgb(color(d.target.index)).darker());
