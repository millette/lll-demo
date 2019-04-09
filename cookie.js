const getCookie = (k) => {
  if (!document.cookie) return
  const m = new Map(document.cookie.split("; ").map((x) => x.split("=")))
  return m.get(k)
}

export default getCookie
