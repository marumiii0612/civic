import "@hotwired/turbo-rails"
// import "controllers" // Stimulus未使用ならコメントアウト

function toggleMenu(){
  const menu = document.querySelector('.header-list');
  const btn  = document.querySelector('.hamburger');
  const expanded = btn.getAttribute('aria-expanded') === 'true';

  menu.classList.toggle('active');
  btn.classList.toggle('is-open');
  btn.setAttribute('aria-expanded', (!expanded).toString());
  menu.setAttribute('aria-hidden', expanded.toString());
}

window.toggleMenu = toggleMenu;