/**
 * @name emulate devices
 *
 * @desc Use the built in devices descriptors to emulate an Iphone 6. These are actually shortcuts for calling
 * page.setUserAgent() and page.setViewPort().
 *
 * @see {@link https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pageemulateoptions}
 */
const puppeteer = require('puppeteer')
const devices = require('puppeteer/DeviceDescriptors');

(async () => {
  const browser = await puppeteer.launch({args: ['--no-sandbox']});
  const page = await browser.newPage()
  await page.emulate(devices['iPhone 6'])
  await page.goto('https://google.com/')
  await page.screenshot({path: 'full.png', fullPage: true})
  console.log(await page.title())
  await browser.close()
})()
