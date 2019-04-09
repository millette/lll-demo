<riot-app>
  <h1 class="title">Allô Monde!</h1>

  <div if="{message}" class="notification is-danger">
    <button type="button" class="delete" onclick="{clearMessage}"></button>
    <raw-html content="{message}" />
  </div>

  <div if="{loaded && !username}" class="columns">
    <div class="column">
      <h2 class="title is-4">Login</h2>
      <form method="post" action="/api/login" onsubmit="{submit}">
        <label class="label">
          username or email
          <input class="input" required type="text" name="username" />
        </label>
        <label class="label">
          password
          <input class="input" required type="password" name="password" />
        </label>
        <button class="button is-primary">Login</button>
      </form>
    </div>
    <div class="column">
      <h2 class="title is-4">Register</h2>
      <form method="post" action="/api/register" onsubmit="{submit}">
        <label class="label">
          username
          <input class="input" required type="text" name="username" />
        </label>
        <label class="label">
          email
          <input class="input" type="email" name="email" />
        </label>
        <label class="label">
          password
          <input class="input" required type="password" name="password" />
        </label>
        <label class="label">
          password
          <input
            placeholder="(repeat)"
            class="input"
            required
            type="password"
            name="password2"
          />
        </label>
        <button class="button is-primary">Register</button>
      </form>
    </div>
  </div>

  <div if="{username}">
    <p>Utilisateur: <b>{username}</b></p>
    <button type="button" class="button is-warning" onclick="{logout}">
      Logout
    </button>
  </div>

  <script>
    this.mixin('getCookie')

    this.on('before-mount', (a, b, c) => {
      if (!this.getCookie('sessionId')) return this.update({ loaded: true })
      fetch('/api/me')
        .then((res) => res.json())
        .then(({ username }) => this.update({ loaded: true, username }))
        .catch((e) => {
          console.error(e)
          this.update({ message: "Missing backend..." })
        })
    })

    // fake it until the API implements logout (session cookie)
    logout () {
      fetch('/api/logout', {
        method: 'POST'
      })
        .then((res) => res.json())
        .then((json) => {
          this.update({
            // riotism: notice the <raw-html> tag above;
            // without it, html tags are escaped as &gt; and &lt;
            message: 'Ciao <b>' + this.username + '</b>',
            username: false
          })
        })
        .catch(console.error)
    }

    clearMessage () {
      this.message = false
      // riotism: update is called automatically
    }

    // Generic function to submit form with "ajax"
    submit(ev) {
      ev.preventDefault()
      ev.preventUpdate = true
      this.update({ message: false })
      // this.update({ message: 'Checking...' })
      // this.message = 'Checking...'
      // use modern fetch() API (instead of xhr)
      // url is taken from the form action
      fetch(ev.target.action, {
        method: 'POST',
        // FormData() serializes the form as multipart
        // URLSearchParams() transforms it into urlencoded
        body: new URLSearchParams(new FormData(ev.target))
      })
        .then((res) => {
          const ct = res.headers.get("content-type")
          let m
          if (!ct) {
            m = 'text'
          } else {
            m = ct.indexOf("application/json") === -1 ? 'text' : 'json'
          }
          return Promise.all([res, res[m]()])
        })
        .then(([res, username]) => {
          if (typeof username === 'object') throw new Error(username.message)
          if (res.status >= 500) throw new Error(username)
          // riotism: update username and clear message
          this.update({ username, message: false })
          // clear the form values
          ev.target.reset()
        })
        .catch((message) => {
          // riotism: update error message
          this.update({ message })
        })
    }
  </script>
</riot-app>
