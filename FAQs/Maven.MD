1) Maven build lifecycles: 
There are three built-in build lifecycles: default, clean and site. 
The default lifecycle handles your project deployment, 
the clean lifecycle handles project cleaning, 
while the site lifecycle handles the creation of your project's site documentation.

the default lifecycle comprises of the following phases:
- validate - validate the project is correct and all necessary information is available
- compile - compile the source code of the project
- test - test the compiled source code using a suitable unit testing framework. These tests should not require the code be packaged or deployed
- package - take the compiled code and package it in its distributable format, such as a JAR.
- verify - run any checks on results of integration tests to ensure quality criteria are met
- install - install the package into the local repository, for use as a dependency in other projects locally
- deploy - done in the build environment, copies the final package to the remote repository for sharing with other developers and projects.

2) Types of repositories in Maven:
Maven repository are of three types. The following illustration will give an idea regarding these three types.

- local - Maven local repository is a folder location on your machine. It gets created when you run any maven command for the first time.
- central - Maven central repository is repository provided by Maven community. It contains a large number of commonly used libraries.
- remote - Sometimes, Maven does not find a mentioned dependency in central repository as well. It then stops the build process and output error message to console. To prevent such situation, Maven provides concept of Remote Repository, which is developer's own custom repository containing required libraries or other project jars.

Maven local repository by default get created by Maven in %USER_HOME% directory. To override the default location, mention another path in Maven settings.xml file available at %M2_HOME%\conf directory.

When Maven does not find any dependency in local repository, it starts searching in central repository using following URL − https://repo1.maven.org/maven2/

3) What is POM?
POM stands for Project Object Model. It is an XML file that resides in the base directory of the project as pom.xml.
The POM contains information about the project and various configuration detail used by Maven to build the project(s).
POM also contains the goals and plugins. While executing a task or goal, Maven looks for the POM in the current directory. It reads the POM, gets the needed configuration information, and then executes the goal. 

4) What is Build Profile?
A Build profile is a set of configuration values, which can be used to set or override default values of Maven build. Using a build profile, you can customize build for different environments such as Production v/s Development environments.

Profiles are specified in pom.xml file using its activeProfiles/profiles elements and are triggered in variety of ways. Profiles modify the POM at build time, and are used to give parameters different target environments (for example, the path of the database server in the development, testing, and production environments).

Build profiles are majorly of three types.
Per Project - Defined in the project POM file, pom.xml
Per User - Defined in Maven settings xml file (%USER_HOME%/.m2/settings.xml)
Global - Defined in Maven global settings xml file (%M2_HOME%/conf/settings.xml)

5) What are Maven Plugins?
Maven is actually a plugin execution framework where every task is actually done by plugins. Maven Plugins are generally used to −

create jar file
create war file
compile code files
unit testing of code
create project documentation
create project reports

A plugin generally provides a set of goals, which can be executed using the following syntax −

mvn [plugin-name]:[goal-name]
mvn compiler:compile

Plugin Types
Maven provided the following two types of Plugins −
1. Build plugins - They execute during the build process and should be configured in the <build/> element of pom.xml.
	
2. Reporting plugins - They execute during the site generation process and they should be configured in the <reporting/> element of the pom.xml.

Following is the list of few common plugins −
1. clean - Cleans up target after the build. Deletes the target directory.

2. compiler - Compiles Java source files.

3. surefire - Runs the JUnit unit tests. Creates test reports.

4. jar - Builds a JAR file from the current project.

5. war - Builds a WAR file from the current project.

6. javadoc - Generates Javadoc for the project.

7. antrun - Runs a set of ant tasks from any phase mentioned of the build.


6) What are types of maven dependencies:
There are two types of Maven dependencies:

1. Direct: These are dependencies defined in your pom.xml file under the <dependencies/> section.

2. Transitive: These are dependencies that are dependencies of your direct dependencies.

Transitive dependency feature is facilitated by reading the project files of your dependencies from the remote repositories specified. In general, all dependencies of those projects are used in your project, as are any that the project inherits from its parents, or from its dependencies, and so on.

when a library, say A, depends upon other library, say B. In case another project C wants to use A, then that project requires to use library B too.

7) What is multi module project in Maven:
A multi-module project is built from an aggregator POM that manages a group of submodules. In most cases, the aggregator is located in the project's root directory and must have packaging of type pom.

Now, the submodules are regular Maven projects, and they can be built separately or through the aggregator POM.

For multimodule project for parent, the packaging should be POM in pom.xml. Also, need to add the modules
<packaging>pom</packaging>

<modules>
   <module>module1</module1>
   <module>module2</module2>
<modules>

For child, we need to mention the parent module in child pom.xml
<parent>
  <groupId>module1</groupId>
  <artifactId>module1-main</artifactId>
  <version>1.0</version>
</parent>

We can also use dependency management using groupdId and artifacrId if there are more submodules. 

8) What is quality gates vs quality profiles?

Quality Profiles are a core component of SonarQube where you define sets of Rules that, when violated, raise issues on your codebase (example: Methods should not have a Cognitive Complexity higher than 15). Each individual language has its own Quality Profile.


With the Quality Gate, you can enforce ratings (reliability, security, security review, and maintainability) based on metrics on overall code and new code. These metrics are part of the default quality gate. 
