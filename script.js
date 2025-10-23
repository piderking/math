document.addEventListener('DOMContentLoaded', () => {
    const EQUATION_SELECTOR = '.equation';
    const CUSTOM_MENU_ID = 'custom-math-context-menu';

    // Object to hold the data of the clicked equation
    let currentData = {
        latex: '',
        typ: ''
    };

    // --- 1. Menu Creation and Setup ---

    /**
     * Creates and returns the custom context menu element.
     * @returns {HTMLElement} The custom menu DIV.
     */
    function createCustomMenu() {
        const menu = document.createElement('div');
        menu.id = CUSTOM_MENU_ID;
        menu.className = 'custom-context-menu';
        menu.style.position = 'fixed';
        menu.style.display = 'none';

        // Item 1: Copy TeX
        const copyLatex = document.createElement('div');
        copyLatex.className = 'menu-item copy-tex';
        copyLatex.textContent = 'Copy TeX';
        
        // Item 2: Copy Typ
        const copyTyp = document.createElement('div');
        copyTyp.className = 'menu-item copy-typ';
        copyTyp.textContent = 'Copy Typ'; // Changed from Typography to Typ for brevity
        
        menu.appendChild(copyLatex);
        menu.appendChild(copyTyp);
        document.body.appendChild(menu);
        return menu;
    }

    // Get or create the custom menu
    let customMenu = document.getElementById(CUSTOM_MENU_ID);
    if (!customMenu) {
        customMenu = createCustomMenu();
    }
    
    /**
     * Hides the custom context menu and clears stored data.
     */
    function hideMenu() {
        customMenu.style.display = 'none';
        currentData.latex = '';
        currentData.typ = '';
    }

    /**
     * Copies the specified text to the clipboard.
     * @param {string} textToCopy - The string to be copied (TeX or Typ).
     */
    function copyText(textToCopy) {
        navigator.clipboard.writeText(textToCopy)
            .then(() => {
                console.log(`Successfully copied: ${textToCopy}`);
            })
            .catch(err => {
                console.error('Failed to copy text:', err);
                // Fallback for older browsers or if permission fails
                // alert(`Could not copy. Please copy manually:\n${textToCopy}`);
            });
        hideMenu();
    }

    // --- 2. Event Listeners ---

    // Global click listener to hide the menu when clicking anywhere else
    document.addEventListener('click', hideMenu);

    // Listener for the custom menu item click
    customMenu.addEventListener('click', (event) => {
        const target = event.target;
        
        if (target.classList.contains('copy-tex') && currentData.latex) {
            copyText(currentData.latex);
        } else if (target.classList.contains('copy-typ') && currentData.typ) {
            copyText(currentData.typ);
        }
    });

    // Main contextmenu listener
    document.addEventListener('contextmenu', (event) => {
        const equationElement = event.target.closest(EQUATION_SELECTOR);

        if (equationElement) {
            // 1. Prevent the default browser context menu
            event.preventDefault();
            event.stopPropagation();

            // 2. Get the LaTeX and Typ data
            const latex = equationElement.getAttribute('data-latex');
            const typ = equationElement.getAttribute('data-typ');
            
            if (latex || typ) { // Only show menu if at least one data attribute is present
                currentData.latex = latex || ''; // Store data, default to empty string if missing
                currentData.typ = typ || '';

                // Enable/disable menu items based on data presence (optional, but good practice)
                customMenu.querySelector('.copy-tex').style.display = latex ? 'block' : 'none';
                customMenu.querySelector('.copy-typ').style.display = typ ? 'block' : 'none';
                
                // 3. Position and Show the custom menu
                const x = event.clientX;
                const y = event.clientY;
                
                customMenu.style.left = `${x}px`;
                customMenu.style.top = `${y}px`;
                customMenu.style.display = 'block';
                
                // Basic check to keep menu on screen
                const rect = customMenu.getBoundingClientRect();
                if (x + rect.width > window.innerWidth) {
                    customMenu.style.left = `${window.innerWidth - rect.width}px`;
                }
                if (y + rect.height > window.innerHeight) {
                    customMenu.style.top = `${window.innerHeight - rect.height}px`;
                }
                
            } else {
                // If the element has the class but no data, fall back to default behavior
                hideMenu();
            }

        } else {
            // If the right-click was not on an equation, ensure custom menu is hidden
            hideMenu();
            // Allow the default browser context menu to show
        }
    });
});