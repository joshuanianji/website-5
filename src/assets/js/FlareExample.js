import * as Flare from '@2dimensions/flare-js/build/Flare.min';
require('@2dimensions/flare-js/canvaskit/canvaskit');
import { vec2, mat2d } from 'gl-matrix';

const _ViewCenter = [512, 384];
const _Scale = 1;
const _ScreenScale = 2.0;

const _ScreenMouse = vec2.create();
const _WorldMouse = vec2.create();

export class FlareExample {
    /**
    * @constructs FlareExample
    * 
    * @param {Element} canvas - a canvas element object on the html page that's rendering this example.
    * @param {onReadyCallback} ready - callback that's called after everything's been properly initialized.
    */
    constructor(canvas, ready) {
        /** Build and initialize the Graphics object. */
        this._Graphics = new Flare.Graphics(canvas);
        this._height = canvas.offsetHeight;
        this._width = canvas.offsetWidth;
        this._Graphics.initialize(() => {
            this._LastAdvanceTime = Date.now();
            this._ViewTransform = mat2d.create();
            this._AnimationInstance = null;
            this._Animation = null;
            this._SoloSkaterAnimation = null;

            /** Start the render loop. */
            this._ScheduleAdvance();
            this._Advance();

            /** Call-back. */
            ready();
        }, "../build/");

        this._Graphics.setSize(this._width * 4, this._height * 4);
    }


    /**
     * Advance the current viewport and, if present, the AnimationInstance and Actor.
     * 
     * @param {Object} _This - the current viewer.
     */
    _Advance() {
        const now = Date.now();
        const elapsed = (now - this._LastAdvanceTime) / 1000.0;
        this._LastAdvanceTime = now;

        const actor = this._ActorInstance;

        if (this._AnimationInstance) {
            const ai = this._AnimationInstance;
            /** Compute the new time and apply it */
            ai.time = ai.time + elapsed;
            ai.apply(this._ActorInstance, 1.0);
        }

        if (actor) {
            const graphics = this._Graphics;

            const w = graphics.viewportWidth;
            const h = graphics.viewportHeight;

            const vt = this._ViewTransform;
            vt[0] = _Scale;
            vt[3] = _Scale;
            vt[4] = (-_ViewCenter[0] * _Scale + w / 2);
            vt[5] = (-_ViewCenter[1] * _Scale + h / 2);
            /** Advance the actor to its new time. */
            actor.advance(elapsed);
        }

        this._Draw();
        /** Schedule a new frame. */
        this._ScheduleAdvance();
    }
    /**
     * Performs the drawing operation onto the canvas.
     * 
     * @param {Object} viewer - the object containing the reference to the Actor that'll be drawn.
     * @param {Object} graphics - the renderer.
     */
    _Draw() {
        if (!this._Actor) {
            return;
        }

        this.graphics.clear([1, 1, 1, 1.0]);
        this.graphics.setView(this._ViewTransform);
        this._ActorInstance.draw(graphics);
        this.graphics.flush();
    }

    /** Schedule the next frame. */
    _ScheduleAdvance() {
        clearTimeout(this._AdvanceTimeout);
        window.requestAnimationFrame(() => {
            this._Advance();
        });
    }
    /**
     * Loads the Flare file from disk.
     * 
     * @param {string} url - the .flr file location.
     * @param {onSuccessCallback} callback - the callback that's triggered upon a successful load.
     */
    load(url, callback) {
        const loader = new Flare.ActorLoader();
        loader.load(url, function (actor) {
            if (!actor || actor.error) {
                callback(!actor ? null : actor.error);
            }
            else {
                this.setActor(actor);
                callback();
            }
        });
    };


    /**
     * Cleans up old resources, and then initializes Actors and Animations, storing the instance references for both.
     * This is the final step of the setup process for a Flare file.
     */
    setActor(actor) {
        /** Cleanup */
        if (this._Actor) {
            this._Actor.dispose(this._Graphics);
        }
        if (this._ActorInstance) {
            this._ActorInstance.dispose(this._Graphics);
        }
        /** Initialize all the Artboards within this Actor. */
        actor.initialize(this._Graphics);

        /** Creates new ActorArtboard instance */
        const actorInstance = actor.makeInstance();
        actorInstance.initialize(this._Graphics);

        this._Actor = actor;
        this._ActorInstance = actorInstance;

        if (actorInstance) {
            /** ActorArtboard.initialize() */
            actorInstance.initialize(this._Graphics);
            if (actorInstance._Animations.length) {
                /** Instantiate the Animation. */
                this._Animation = actorInstance._Animations[0];
                this._AnimationInstance = new Flare.AnimationInstance(this._Animation._Actor, this._Animation);

                if (!this._AnimationInstance) {
                    console.log("NO ANIMATION IN HERE!?");
                    return;
                }

            }
        }
    };


}




