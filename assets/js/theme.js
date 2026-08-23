(() => {
  const button = document.querySelector('.theme-toggle');
  if (!button) return;
  button.addEventListener('click', () => {
    const current = document.documentElement.dataset.theme === 'dark' ? 'dark' : 'light';
    const next = current === 'dark' ? 'light' : 'dark';
    document.documentElement.dataset.theme = next;
    try { localStorage.setItem('theme', next); } catch (error) { /* storage may be disabled */ }
  });
})();
document.addEventListener('click', (event) => {
  const el = event.target.closest('[data-upi]');
  if (!el) return;
  const text = el.getAttribute('data-upi') || '';
  const mark = () => {
    el.dataset.copied = '1';
    clearTimeout(el._copyTimer);
    el._copyTimer = setTimeout(() => delete el.dataset.copied, 1200);
  };
  const fallback = () => {
    const ta = document.createElement('textarea');
    ta.value = text;
    document.body.appendChild(ta);
    ta.select();
    try { document.execCommand('copy'); } catch (error) { /* ignore */ }
    document.body.removeChild(ta);
    mark();
  };
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(text).then(mark).catch(fallback);
  } else {
    fallback();
  }
});
