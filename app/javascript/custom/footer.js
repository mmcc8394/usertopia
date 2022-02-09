document.addEventListener('turbolinks:load', testing);

function testing() {
    let footer = document.getElementById('footer');
    let window_height = window.innerHeight;
    let footer_height = footer.clientHeight;
    let footer_top = footer.offsetTop + footer_height;
    if(footer_top < window_height) {
        footer.style.marginTop = (window_height - footer_top + 12) + 'px';
    }
}