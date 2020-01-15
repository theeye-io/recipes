
const https = require('https')
const token = process.env.ACCESS_TOKEN

if (!token) {
  throw new Error('ACCESS_TOKEN required')
}

const fetch = (customer, where) => {
  let queryCustomer = encodeURIComponent(customer)

  let qs = `access_token=${token}`
  for (let prop in where) {
    qs += `&where[${prop}]=${encodeURIComponent(where[prop])}`
  }

  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'supervisor.theeye.io',
      port: 443,
      path: `/${queryCustomer}/job?${qs}`,
      method: 'GET'
    }

    console.log('waiting server response')
    const req = https.request(options, res => {
      let str = ''

      res.on('data', d => {
        console.log('progress: downloaded ' + str.length + ' bytes')
        //process.stdout.write(d)
        if (d) { str += d; }
      })

      res.on('end', () => {
        console.log('progress: download completed')
        return resolve(str)
      })
    })

    req.on('error', error => {
      return reject(error)
    })

    req.end()
  })
}

const cancel = (customer, job) => {
  let queryCustomer = encodeURIComponent(customer)
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'supervisor.theeye.io',
      port: 443,
      path: `/${queryCustomer}/job/${job.id}/cancel?access_token=${token}`,
      method: 'PUT'
    }

    console.log('waiting server response')
    const req = https.request(options, res => {
      let str = ''

      res.on('data', d => {
        console.log('progress: downloaded ' + str.length + ' bytes')
        //process.stdout.write(d)
        if (d) { str += d; }
      })

      res.on('end', () => {
        console.log('progress: download completed')
        return resolve(str)
      })
    })

    req.on('error', error => {
      return reject(error)
    })

    req.end()
  })
}

module.exports = { fetch, cancel }
