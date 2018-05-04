import './lib/mdl/material.css';
import './lib/mdl/material.js';
import './fonts.css';

import './main.css';
import './autocomplete.css';

import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

Main.embed(document.getElementById('root'));

registerServiceWorker();
