# Pricing

This project is creating free and open-source software under the MIT license.
There are plenty of ways to run the workflow locally after downloading the [data](/background-gfm.html#data).
However, the workflow can be also be executed with [openEO at EODC](https://editor.openeo.org/?server=openeo.eodc.eu%2Fopeneo%2F1.2.0%2F) by enabling experimental processes and searching for 'rqadeforestation'.

## Price calculator

Please enter the spatio-temporal extent to be processed.
The price will be estimated automatically.
Please note that these results are not official offerings from any cloud provider.
Ressource estimation were based on the Sentinel-1 Sigma0 collection at 20m resolution in Equi7 projection at the EODC cloud.

<ClientOnly>

<form @submit.prevent="onSubmit" class="form-horizontal">
  <div class="form-floating">
    <label for="start">Start date</label><br />
    <input id="start" type="date" v-model="start" class="form-control" value="01/01/2024" required />
  </div>

  <div class="form-floating">
    <label for="end">End date</label><br />
    <!-- enforce end >= start on the client -->
    <input id="end" type="date" v-model="end" :min="start" class="form-control" required />
  </div>

  <div class="form-floating">
    <label for="n_tiles">Number of Equi7 tiles</label><br />
    <input
      id="n_tiles"
      type="number"
      v-model.number="n_tiles"
      min="1"
      step="1"
      inputmode="numeric"
      class="form-control"
      required
    />
  </div>

  <div v-if="error" style="color:#b00020;margin-top:0.4rem">{{ error }}</div>

  <tbody class="form-floating mt-3 ">
    <tr>
    <td>
    <strong>Estimated memory usage:</strong>
    </td>
    <td>
      {{ price }} GB
    </td>
    </tr>
    <tr>
    <td>
    <strong>Estimated runtime on one vCPU:</strong>
    </td>
    <td>
      {{ price }} min
    </td>
  </tr>
  </tbody>
</form>


</ClientOnly>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'

const start = ref('')
const end = ref('')
const n_tiles = ref(1)
const submitted = ref(false)
const error = ref('')
let price = 1337

const valid = computed(() => {
  if (!start.value || !end.value) return false
  if (start.value > end.value) return false
  if (!Number.isInteger(n_tiles.value) || n_tiles.value < 0) return false
  return true
})

watch([start, end, n_tiles], () => {
  error.value = ''
  if (start.value && end.value && start.value > end.value) {
    error.value = 'Start date must be on or before end date.'
  }
  if (!Number.isInteger(n_tiles.value)) {
    error.value = 'Count must be an integer.'
  }

  let days = (Date.parse(end.value) - Date.parse(start.value)) * 1e-3 / 60 / 60 / 24 / 365

  price = n_tiles.value * days * 100 * 1.00123
  price = Math.round(price * 100) / 100
})

onMounted(() => {
  start.value = "2022-01-01"
  end.value = "2023-01-01"
})
</script> 