# Elm Msg mapping issue
A basic multi-page SPA app SSCCE

### What's happening here?

I think Elm is mapping a `Msg` from the Home page into the `Settings` page.  
The compiler would recognize this as invalid, but the Elm runtime is allowing this.  

Something very relevant here: This is only reproducable in Chrome due to how 
the `focusout` event is fired off once the DOM element is removed. Other browsers
do not behave this way. `preventDefaultOn "mousedown"` is very important as
this prevents the textfield from losing focus when `mousedown` hits the "Go to Settings" link.

**Here is what I think the flow is:**
1. Focusing `input` element causes `Note.Msg (EditorFocused True)`.
2. Mousedown on "Go to Settings" link causes `Note.Msg NoOp` to fire. Input still has focus.
3. Mouseup on link causes the page to change to `/settings`.
4. The `input` is removed from the DOM on page change and the `focusout` event is fired (only in Chrome).
5. `EditorFocused False` is fired but caught by `Settings.Msg`
6. The settings update function does not recognize the `EditorFocused` Msg, 
but the way the Elm compiler generates the final match in a case statements results in the Msg being caught in the `default` case,
aka `TheDefaultCase { wat : { hereIsAnElmException : Int } }`
7. The code attempts to access `constructorValue.wat.hereIsAnElmException`.
`constructorValue` is actually a `Boolean` off of `EditorFocused` so an exception is thrown.

![image](https://user-images.githubusercontent.com/15849320/119717049-10cdfd00-be23-11eb-8d71-b83c0c9fb507.png)  


**Note:** If you disable the offending code in `Settings` under `Msg.TheDefaultCase`, you an invalid `Msg` type propagating to `Settings.update`
Screen Shot 2021-05-26 at 1.28.36 PM![image](https://user-images.githubusercontent.com/15849320/119720147-d8c8b900-be26-11eb-863c-f97d76acc805.png)


### Run
1. Install deps and start dev server
```
yarn install
yarn dev
```
2. Open http://localhost:1234 **in Chrome**
3. Click into textfield.
4. Click "Go to Settings" link.
5. Look at console for the exception.

