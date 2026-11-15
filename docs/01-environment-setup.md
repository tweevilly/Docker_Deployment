# 1. Environment setup

The checklist I used to get a Java + Angular + Docker toolchain working on Windows.

## Versions

| Tool | Version / note | Where I checked |
|------|----------------|-----------------|
| Java | 17 | `<java.version>17</java.version>` in `pom.xml` |
| Angular | `@angular/core` ^14.1.0, `@angular/cli` ~14.1.3 | `package.json` |
| Node.js | 20 LTS (v20.20.0) | `node -v` |
| Docker Desktop | latest stable | |

> **Node.js is a runtime, not an npm dependency.** It should not be listed as a dependency in `package.json`. Putting it there is a common student-project mistake and it causes confusion.

## Docker Desktop

- Installed the latest stable Docker Desktop.
- It needed a **Linux kernel update** (the WSL 2 component) before the engine would start.
- I had to accept Docker's **subscription service agreement** on first launch.
- I enabled **Expose daemon on tcp://localhost:2375 without TLS** so IntelliJ's Docker plugin could connect.

> ⚠️ **Security:** that last setting leaves the Docker daemon open without authentication to anything on the machine that can reach port 2375. Only turn it on if a tool needs it, and switch it off afterwards.

## IntelliJ IDEA plugins

*Settings → Plugins*

| Required | Optional |
|----------|----------|
| Git | Lombok (many Spring projects need it) |
| Docker | Database Tools (if connecting to MySQL) |
| Node.js | |
| Angular and TypeScript | |
| Spring Boot | |

If the project uses Lombok, check that **annotation processing is enabled**; otherwise the code fails to compile even though it looks correct.

## Clone the project

1. Open IntelliJ and choose **Get from Version Control**.
2. Select **Git** and paste the repository's HTTPS URL.
3. Choose a local directory and click **Clone**.

IntelliJ clones the repo, detects Maven and imports the Spring project automatically.

## Smoke tests

**Back end**
1. Open the main application class (`D387SampleCodeApplication.java`) and click **Run**.
2. Confirm Spring Boot starts and there are no Java-version errors.

**Front end** (from the Angular folder, `src/main/UI`)
```powershell
npm install
ng serve
```
`ng serve` starts Angular's live development server on `http://localhost:4200`. The packaged application, with the front end built into the Spring Boot jar, is served from `http://localhost:8080`.

## Day-to-day workflow

- Edit the front end in the **UI** folder.
- `ng build` compiles the front end on its own.
- `mvn spring-boot:run` runs the back end from the command line.
- Front-end changes made by hand are not visible on `localhost:8080` until the Maven build has run, because Maven is what builds the Angular app into the jar.
