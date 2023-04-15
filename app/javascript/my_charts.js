
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
      data: {},
      options: {
        plugins:{
          title: {
            display: true,
            text: 'Température'
          },
        },
      }
    }
  );

  let graphOutput = new Chart(
    document.getElementById('graph-output'),
    {
      type: 'line',
      data: {},
      options: {
        plugins:{
          title: {
            display: true,
            text: 'Sortie'
          },
        },
        scales: {
          x: {
            display: true,
            title: {
              display: true,
              text: 'min'
            }
          },
          y: {
            display: true,
            title: {
              display: true,
              text: '%'
            },
            suggestedMin: 0,
            suggestedMax: 100
          }
        }
      }
    }
  );

  let courbe = new Chart(
    document.getElementById('courbe'),
    {
      type: 'line',
      data: {},
      options: {
        plugins:{
          legend: {
            display: false
          },
          title: {
            display: true,
            text: 'Proportionnel'
          },
        },
      }
    }
  );

  let courbeIntegrale = new Chart(
    document.getElementById('courbe-integrale'),
    {
      type: 'line',
      data: {},
      options: {
        plugins:{
          legend: {
            display: false
          },
          title: {
            display: true,
            text: 'Intégrale'
          },
        },
      }
    }
  );

  function fetchValues() {
    let p = parseFloat(document.getElementById('p').value)
    let integral = parseFloat(document.getElementById('i').value)
    let dead = parseFloat(document.getElementById('dead').value)
    let reset = parseFloat(document.getElementById('reset').value)
    let bias = parseFloat(document.getElementById('bias').value)
    let variation = parseFloat(document.getElementById('variation').value)
    let variation_cool = parseFloat(document.getElementById('variation_cool').value)
    let variation_heat = parseFloat(document.getElementById('variation_heat').value)
    let duree = parseFloat(document.getElementById('duree').value)
    let input = parseFloat(document.getElementById('input').value)
    let pc = parseFloat(document.getElementById('pc').value)
    let nb_pt = parseFloat(document.getElementById('nb_pt').value)
    let d_t = duree/nb_pt // delta t

    return {p, integral, dead, reset, bias, variation, variation_cool, variation_heat, duree, input, pc, nb_pt, d_t}
  }

  function runSimul() {

    let {p, integral, dead, reset, bias, variation, variation_cool, variation_heat, duree, input, pc, nb_pt, d_t} = fetchValues()

    let configs = ['p', 'i', 'dead', 'reset', 'bias', 'input', 'pc']

    configs.forEach(config => {
      document.getElementById(config).addEventListener('change', () => {
        updateCourbes()
      }, false)
    })

    function updateCourbes() {
      let {p, integral, dead, reset, bias, variation, variation_cool, variation_heat, duree, input, pc, nb_pt, d_t} = fetchValues()

      let xs = ["", pc-dead/2-p/2 + " (-PB)", pc-dead/2 + "(-DB)", pc + " (SP)", pc+dead/2 + " (DB)", pc+dead/2+p/2 + " (PB)", ""]
      let ys = [0, 0, bias, bias, bias, 100, 100]
      courbe.data = {labels: xs, datasets: [{data: ys, pointStyle: 'cross'}] }
      courbe.update()
  
      xs = ["", pc-dead/2-p/2 + " (-RB)", pc-dead/2 + "(-DB)", pc + " (SP)", pc+dead/2 + " (DB)", pc+dead/2+p/2 + " (RB)", ""]
      ys = [-integral, -integral, 0, 0, 0, integral, integral]
      courbeIntegrale.data = {labels: xs, datasets: [{data: ys, pointStyle: 'cross'}] }
      courbeIntegrale.update()
    }
    updateCourbes()

    const pvs = []
    const outs = []
    const biases = []
    console.log(nb_pt)
    let pv = input
    let out = bias
    for (let i = 0; i < nb_pt; i++) {
      pv += variation*d_t + variation_cool*d_t*scale(out, 50, 0, 100, 1) + variation_heat*d_t*scale(out, 0, 1, 50, 0)
      pvs.push(pv)
      if (Math.abs(pv-pc)<dead/2) {
        out = bias
      } else if (pv-pc > 0) {
        out = scale(pv, pc+dead/2, bias, pc+p/2+dead/2, 100)
      } else {
        out = scale(pv, pc-dead/2, bias, pc-p/2-dead/2, 0)
      }
      outs.push(out)
      if (pv > pc) {
        bias = Math.min(bias + integral*d_t*scale(pv, pc+dead/2, 0, pc+dead/2+reset/2, 1), 100)
      } else {
        bias = Math.max(bias - integral*d_t*scale(pv, pc-dead/2-reset/2, 1, pc-dead/2, 0), 0)
      }
      biases.push(bias)
    }
  
    graph.data = {
      labels: pvs.map((e,i) => (d_t*i).toFixed(2)),
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
      labels: outs.map((e,i) => (d_t*i).toFixed(2)),
      datasets: [
        {
          label: 'Output',
          data: outs,
          pointStyle: false,
          borderColor: '#ffc107',
          backgroundColor: '#ffc107',
        },
        {
          label: 'Bias',
          data: biases,
          pointStyle: false,
          borderColor: '#F7FF00',
          backgroundColor: '#F7FF00',
        },
        {
          label: 'Cooling',
          data: outs.map(out => scale(out, 50, 0, 100, 100)),
          pointStyle: false,
          borderColor: '#0000FF',
          backgroundColor: '#0000FF',
        },
        {
          label: 'Heating',
          data: outs.map(out => scale(out, 0, 100, 50, 0)),
          pointStyle: false,
          borderColor: '#FF0000',
          backgroundColor: '#FF0000',
        }
      ]
    }
    graphOutput.update()

  }

  runSimul()
  document.getElementById('runSimulBtn').addEventListener('click', runSimul, false)

});