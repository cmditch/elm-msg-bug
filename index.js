import { Elm } from './src/Main.elm'

Elm.Main.init()



const testNodeRemovalBehavior = () =>
    {
        const input = document.createElement('input');
        input.addEventListener('focusin', () => console.log('I was focusin\'d'));

        /*
         We only see this 'focusout' handler fire in Chrome,
         because Safari and Firefox don't follow the spec.

         "If modifications occur to the tree during event processing,
         event flow will proceed based on the initial state of the tree."

         https://www.w3.org/TR/DOM-Level-2-Events/events.html#Events-flow-bubbling
         */
        input.addEventListener('focusout', () => console.log('I was focusout\'d because I was removed'));
        input.value = "yada yada"
        document.body.append(input);
        input.focus();
        setTimeout(() => input.remove(), 4000)
    }

/* Uncomment the function below to see how Chrome, Safari, Firefox do or do not
   fire events after an element has been removed.
*/

// testNodeRemovalBehavior()