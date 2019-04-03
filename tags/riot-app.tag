<riot-app>
  <h1 class="title">Allô Monde!</h1>

  <div show="{message}" class="notification is-danger">
    <button type="button" class="delete" onclick="{clearMessage}"></button>
    <raw-html content="{message}" />
  </div>

  <div hide="{username}" class="columns">
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

  <div show="{username}">
    <p>Utilisateur: <b>{username}</b></p>
    <button type="button" class="button is-warning" onclick="{logout}">
      Logout
    </button>
  </div>

  <script>
    // fake it until the API implements logout (session cookie)
    logout () {
      // riotism: notice the <raw-html> tag above;
      // without it, html tags are escaped as &gt; and &lt;
      this.message = 'Ciao <b>' + this.username + '</b>'
      this.username = false
      // riotism: update is called automatically
    }

    clearMessage () {
      this.message = false
      // riotism: update is called automatically
    }

    // Generic function to submit form with "ajax"
    submit(ev) {
      ev.preventDefault()
      // use modern fetch() API (instead of xhr)
      // url is taken from the form action
      fetch(ev.target.action, {
        method: 'POST',
        // FormData() serializes the form as multipart
        // URLSearchParams() transforms it into urlencoded
        body: new URLSearchParams(new FormData(ev.target))
      })
        // if ok, text() returns the username
        // otherwise, the error is in json
        .then((res) => res.ok ? res.text() : res.json())
        .then((username) => {
          // username will actually be an error if it's an object
          // on error, set error message
          if (typeof username === 'object') throw new Error(username.message)
          // riotism: update username and clear message
          this.update({ username, message: false })
          // clear the form values
          ev.target.reset()
        })
        .catch((err) => {
          // riotism: update error message
          this.update({ message: err.message })
        })
    }
  </script>
</riot-app>
