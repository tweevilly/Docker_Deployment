# 7. Troubleshooting log

Problems I hit, in roughly the order I hit them, and what fixed them.

## Node.js and npm on Windows

**Symptoms**
- Older Node versions (14, then 18) gave me trouble. At one point `node` wasn't recognized in the terminal at all.
- After installing Node under `C:\`, `ng serve` still wouldn't compile.

**Cause**
`C:\` is a protected system location. npm needs write access for its cache, global packages and temp files, and **IntelliJ can't elevate npm** unless the whole IDE is run as administrator.

**Fix**
1. Installed **Node.js 20 LTS** with the default options, letting the installer add npm and set the PATH.
2. Restarted IntelliJ and verified with `node -v` and `npm -v` in the IntelliJ terminal (PowerShell).
3. Moved npm's global folder somewhere my user can write:

   ```powershell
   mkdir $env:USERPROFILE\npm-global
   npm config set prefix "$env:USERPROFILE\npm-global"
   npm config get prefix
   ```
4. Added that folder to my **user** PATH: *Windows + R → `sysdm.cpl` → Advanced → Environment Variables → User variables → Path → Edit → New*, then restarted IntelliJ.
5. Installed the tools from the UI folder:

   ```powershell
   cd src/main/UI
   npm install -g @angular/cli
   npm install
   ng serve
   ```

`ng serve` finally reported **Compiled successfully** and the dev server came up on `localhost:4200`.

**Takeaway:** put the global npm prefix in the user profile, and use the system PATH only for what really needs it.

## Welcome message shows `[object Object]`

`getWelcomeMessage()` returns an `Observable`. Templates can't render one directly, so use the **`async` pipe** (or subscribe in the component and bind the result). See [application overview](02-application-overview.md).

## Language change didn't update the message

The message was built once at startup and stored in a static variable. Moving the logic into a **REST controller** made it run per request.

## Front-end changes not showing on `localhost:8080`

Hand-edited front-end files only appear after the **Maven build** has run, because Maven builds Angular into the jar. Run `mvn validate` / `mvn package` again, then reload.

## Pointing `docker build` at the right place

The final argument to `docker build` is the **folder** that holds the Dockerfile, not the file. Running the command from a different folder (I used `C:\Docker`) works as long as that argument points at the project.

## Keeping the `COPY` line in sync with the jar

The jar name in the Dockerfile has to match the file in `target/` exactly, including dashes and the version. A mismatch, or forgetting to run `mvn package` first, means `COPY` has nothing to copy. My own notes spell the same jar name two slightly different ways, which shows how easy it is to get wrong. Copy the name from the folder instead of retyping it.

## App works locally but not on a cloud platform

Hard-coded port 8080. Read the port from the environment and fall back to 8080 for local runs. See [the Dockerfile notes](04-dockerfile-explained.md#why-the-port-shouldnt-stay-hard-coded).

## Docker Desktop first-run checklist

Docker Desktop needed the **Linux kernel (WSL 2) update** and acceptance of the Docker subscription service agreement before the engine was ready. `docker info` confirms the engine is up.
