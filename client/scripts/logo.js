class Logo {
    constructor() {
        this.logo = document.getElementsByClassName('logo')[0];
        this.header = document.getElementsByClassName('header')[0];
    }

    init() {
        setTimeout(() => {
            this.logo.classList.add('logo--fade-in');
            this.header.classList.add('header--slope');
        }, 1000);
    }
}

module.exports = Logo;
