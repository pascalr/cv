
// TODO: Optimize and only import what is needed
import Chart from 'chart.js/auto' // OPTIMIZE: Don't import everything?

function scale(input, inputMin, outputMin, inputMax, outputMax) {
  var scaledInput = (input - inputMin) / (inputMax - inputMin);
  var scaledOutput = scaledInput * (outputMax - outputMin) + outputMin;
  var min = Math.min(outputMin, outputMax)
  var max = Math.max(outputMin, outputMax)

  if (scaledOutput > max) {
    return max
  } else if (scaledOutput < min) {
    return min
  }
  return scaledOutput;
}

document.addEventListener("DOMContentLoaded", function() {

  let graph = new Chart(
    document.getElementById('graph'),
    {
      type: 'line',
      data: {}
    }
  );

  let graphOutput = new Chart(
    document.getElementById('graph-output'),
    {
      type: 'line',
      data: {}
    }
  );

  function runSimul() {

    let p = parseFloat(document.getElementById('p').value)
    let integral = parseFloat(document.getElementById('i').value)
    let dead = parseFloat(document.getElementById('dead').value)
    let reset = parseFloat(document.getElementById('reset').value)
    let bias = parseFloat(document.getElementById('bias').value)
    let variation = parseFloat(document.getElementById('variation').value)
    let variation_cool = parseFloat(document.getElementById('variation_cool').value)
    let variation_heat = parseFloat(document.getElementById('variation_heat').value)
    let interval = parseFloat(document.getElementById('interval').value)
    let input = parseFloat(document.getElementById('input').value)
    let pc = parseFloat(document.getElementById('pc').value)
    let nb_pt = parseFloat(document.getElementById('nb_pt').value)
    let interval_calcul = parseFloat(document.getElementById('interval_calcul').value)
    let k = interval_calcul / interval

    const pvs = []
    const outs = []
    const biases = []
    console.log(nb_pt)
    let pv = input
    let out = bias
    for (let i = 0; i < nb_pt; i++) {
      pv += variation*k + variation_cool*k*scale(out, 50, 0, 100, 1) + variation_heat*k*scale(out, 0, 1, 50, 0)
      pvs.push(pv)
      if (Math.abs(pv-pc)<dead/2) {
        out = bias
      } else if (pv-pc > 0) {
        out = scale(pv, pc+dead/2, bias, pc+p/2+dead/2, 100)
      } else {
        out = scale(pv, pc-dead/2, bias, pc-p/2-dead/2, 0)
      }
      outs.push(out)
      if (out > bias) {
        bias = Math.min(bias + integral * interval_calcul, 100)
      } else {
        bias = Math.max(bias - integral * interval_calcul, 0)
      }
      biases.push(bias)
    }
  
    graph.data = {
      labels: pvs.map((e,i) => (interval_calcul*i).toFixed(2)),
      datasets: [
        {
          label: 'Entrée',
          data: pvs,
          pointStyle: false,
        },
        {
          label: 'Consigne',
          data: pvs.map(i => pc),
          pointStyle: false,
        },
      ]
    }
    graph.update()


    graphOutput.data = {
      labels: outs.map((e,i) => (interval_calcul*i).toFixed(2)),
      datasets: [
        {
          label: 'Output',
          data: outs,
          pointStyle: false,
        },
        {
          label: 'Bias',
          data: biases,
          pointStyle: false,
        },
        {
          label: 'Cooling',
          data: outs.map(out => scale(out, 50, 0, 100, 100)),
          pointStyle: false,
        },
        {
          label: 'Heating',
          data: outs.map(out => scale(out, 0, 100, 50, 0)),
          pointStyle: false,
        }
      ]
    }
    graphOutput.update()

  }

  runSimul()
  document.getElementById('runSimulBtn').addEventListener('click', runSimul, false)

});