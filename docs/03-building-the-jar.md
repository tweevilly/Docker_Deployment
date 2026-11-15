# 3. Building the jar that Docker packages

A Dockerfile doesn't build the app here. It packages a jar that already exists. So the first step is a correct Maven build.

## Maven lifecycle

Maven runs through its lifecycle phases in order, so asking for a later phase runs every phase before it.

```text
validate → compile → test → package → ...
```

What I used:

| Command | What it does for this project |
|---------|-------------------------------|
| `mvn validate` | Finishes updating the node modules and sets up the build. Because the front-end build is wired into `pom.xml`, back end and front end end up in **one deployable unit instead of two separate ones** |
| `mvn clean` | Removes old build output so nothing stale gets packaged |
| `mvn package` | Compiles everything and places the jar in the **`target/`** directory |

IntelliJ's Maven tool window does the same thing from the IDE; everything can also be run from the command line.

## The output

After `mvn package`, `target/` contains the Spring Boot jar:

```text
target/D387_sample_code-0.0.2-SNAPSHOT.jar
```

This is the exact file name the Dockerfile's `COPY` line refers to. **If it doesn't match character for character, the Docker build fails.** I now copy the name from the `target/` folder instead of typing it.

## Back end and front end on one port

The `pom.xml` includes a build plugin that runs the front-end build as part of the Maven build. The Angular app ends up bundled with the Spring Boot application, so both are served by the embedded Tomcat on port **8080**. There's no separate front-end server to deploy.

> If a front-end file changes, rebuild with Maven before testing on `localhost:8080`; otherwise you're looking at the old build.
