module.exports = (bundler) => ({
  after(app, server) {
    app.get("/script.js", (req, res) => {
      const js = [...bundler.bundleHashes.keys()].find((s) => s.endsWith(".js"))
      res.sendFile(js)
    })
  },
  proxy: {
    "/api/*": {
      target: "http://localhost:3000",
      pathRewrite: {
        "^/api/": "/",
      },
    },
  },
})
