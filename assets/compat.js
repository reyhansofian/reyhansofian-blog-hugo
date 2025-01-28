// Fix FontAwesome 4 => 6 compatibility
document.addEventListener('DOMContentLoaded', () => {
  const iconMap = {
    'fa-github': 'fa-brands fa-github',
    'fa-twitter': 'fa-brands fa-twitter',
    // Add other icon mappings from your theme
  };

  Object.entries(iconMap).forEach(([oldClass, newClass]) => {
    document.querySelectorAll(`.${oldClass}`).forEach(el => {
      el.classList.remove(oldClass);
      el.classList.add(...newClass.split(' '));
    });
  });
});
