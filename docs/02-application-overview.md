# 2. Application overview (Task B)

Before containerizing, I modified the Landon Hotel scheduling application. These changes are the context for the Docker work, and a few of them taught me things that mattered later.

## What I changed

| Task | Requirement | Where |
|------|-------------|-------|
| **B1 (a)** | Build resource bundles for English and French, each with a welcome message | Java back end |
| **B1 (b)** | Display both welcome messages, loading each bundle on its own thread | Back end + Angular |
| **B2** | Show each room's price in USD (`$`), CAD (`C$`) and EUR (`€`) on separate lines | `app.component.html` |
| **B3 (a)** | Write a Java method that converts times between ET, MT and UTC | Back end |
| **B3 (b)** | Display the live-presentation time in all three zones | Back end + Angular |

The three-currency display is a small template change in `app.component.html`:

```html
<strong>Price (USD): ${{room.price}}</strong><br/>
<strong>Price (CAD): C${{room.price}}</strong><br/>
<strong>Price (EUR): €{{room.price}}</strong><br/>
```

## How the multithreaded welcome message works

1. The Java side runs one thread per language; each thread loads its resource bundle and produces a welcome string (a `public static String` per thread).
2. Instead of printing from the thread, the values are exposed through **my own REST controller**.
3. Angular calls that API. `app.component.ts` has a `getWelcome` method whose result is subscribed into a `welcome` variable, and `app.component.html` renders it.

## Lessons from this part

**Code in `main` runs once.** My first version loaded the messages in startup code. That runs once per application start, so the output was fixed: a language change was never picked up because the value sat in a static variable. The fix was to **move the method into the controller**, so each request does the work.

**An Observable is not a string.** `getWelcomeMessage()` returns an `Observable`. Angular templates can't render an Observable directly unless you use the **`async` pipe**. Even after subscribing, putting a Map or object straight into the template shows `[object Object]`.

**One port, one artifact.** The Maven build also builds the Angular front end, so the final jar contains both back end and front end and serves everything on port **8080**. That's what makes it possible to ship a **single Docker image** for the whole app.
