# 4. The Dockerfile, explained

## Concepts I had to get straight first

| Term | What it means |
|------|---------------|
| **Image** | A read-only template containing an OS layer, a Java runtime and my jar. Built once, run many times |
| **Container** | A running instance of an image. Deleting the container doesn't delete the image |
| **Dockerfile** | The recipe for building an image, one instruction per step |
| **Build context** | The folder handed to `docker build`. `COPY` can only see files inside it |
| **Layer** | Each instruction produces a cached layer. Unchanged layers are reused on rebuilds |
| **Tag** | A name for an image, like `<user>/<image>:latest`. Pushing to Docker Hub needs the `<user>/` prefix |
| **Registry** | Where images are stored and shared (Docker Hub in this project) |
| **Port mapping** | `-p 8080:8080` connects a port on my machine to a port inside the container |

## My Dockerfile

```dockerfile
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app
COPY target/D387_sample_code-0.0.2-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

(The full commented version is in the [`Dockerfile`](../Dockerfile). Dockerfile comments must start a line with `#`, so they can't trail an instruction.)

## Line by line

**`FROM eclipse-temurin:17-jdk-jammy`**
Chooses the base image: Eclipse Temurin's OpenJDK **17** on Ubuntu "jammy". I picked 17 because `pom.xml` specifies Java 17, so the container runs the same Java version I developed against. The startup log confirms it: `Using Java 17.0.18`.

**`WORKDIR /app`**
Creates `/app` and makes it the current directory for the instructions that follow and for the running container. In the logs the app shows up as `started by root in /app`.

**`COPY target/D387_sample_code-0.0.2-SNAPSHOT.jar app.jar`**
Copies the jar from the build context (the project's `target/` folder) into the image and renames it `app.jar`, so the start command never depends on the version number.

**`ADD` vs `COPY`**
`ADD` does the same job but can also unpack archives and fetch URLs. For a plain file, `COPY` is the more predictable choice, so I kept `ADD` only as a commented-out alternative.

**`EXPOSE 8080`**
Documents that the app listens on 8080. It does **not** publish the port; that happens at run time with `-p`.

**`ENTRYPOINT ["java", "-jar", "app.jar"]`**
The command that runs when the container starts. The JSON-array (exec) form runs Java directly as the container's main process (PID 1 in the logs), so Docker can stop it cleanly.

## Why the port shouldn't stay hard-coded

Locally, port 8080 is fine. On Azure or AWS the platform may supply its own port, so the app should **read the port from the environment** instead of having it written into the code. I made that change in my final commits (*"Removed hardcoded port import location"*).

A common Spring Boot pattern for this, shown as an example of the idea and not as a copy of my code:

```properties
# application.properties
server.port=${PORT:8080}
```

This uses the `PORT` environment variable when it exists and falls back to 8080 locally.
