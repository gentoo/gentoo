# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source test"

inherit java-pkg-2

DESCRIPTION="General-purpose programming language with an emphasis on functional programming"
HOMEPAGE="https://clojure.org/"
SRC_URI="https://github.com/clojure/clojure/tarball/${P} -> ${P}.tar.gz"

LICENSE="EPL-1.0 Apache-2.0 BSD"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~x86 ~x86-linux"

CDEPEND="dev-java/maven-bin:3.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8"

S="${WORKDIR}/clojure-clojure-76b87a6"

DOCS=( changes.md CONTRIBUTING.md readme.txt )

# Even though some of this stuff will not be used at runtime, it is all
# required in order to satisfy the maven build system.
# The syntax of each item follows what Maven uses in its error messages, which
# makes updating the list by trial-running the ebuild easier.
# Each item may optionally consist of two words (separated by one whitespace),
# where the first word would be the remote repository, defaulting to Maven
# Central if absent.
# The basic idea is borrowed from the net-p2p/bisq-0.6.3 ebuild.
EMAVEN_ARTIFACTS=(
	asm:asm-parent:pom:3.3.1
	asm:asm:jar:3.3.1
	backport-util-concurrent:backport-util-concurrent:jar:3.1
	ch.qos.logback:logback-classic:jar:1.1.2
	ch.qos.logback:logback-core:jar:1.1.2
	ch.qos.logback:logback-parent:pom:1.1.2
	classworlds:classworlds:jar:1.1
	classworlds:classworlds:jar:1.1-alpha-2
	commons-beanutils:commons-beanutils-core:jar:1.8.3
	commons-beanutils:commons-beanutils:jar:1.6
	commons-beanutils:commons-beanutils:jar:1.7.0
	commons-cli:commons-cli:jar:1.0
	commons-cli:commons-cli:jar:1.2
	commons-codec:commons-codec:jar:1.6
	commons-collections:commons-collections:jar:2.0
	commons-collections:commons-collections:jar:2.1
	commons-collections:commons-collections:jar:3.1
	commons-collections:commons-collections:jar:3.2
	commons-collections:commons-collections:jar:3.2.1
	commons-digester:commons-digester:jar:1.6
	commons-io:commons-io:jar:1.4
	commons-io:commons-io:jar:2.4
	commons-io:commons-io:jar:2.5
	commons-lang:commons-lang:jar:2.1
	commons-lang:commons-lang:jar:2.6
	commons-logging:commons-logging-api:jar:1.1
	commons-logging:commons-logging:jar:1.0
	commons-logging:commons-logging:jar:1.0.3
	commons-logging:commons-logging:jar:1.0.4
	commons-validator:commons-validator:jar:1.2.0
	com.fasterxml.jackson.core:jackson-annotations:jar:2.3.0
	com.fasterxml.jackson.core:jackson-annotations:jar:2.3.1
	com.fasterxml.jackson.core:jackson-core:jar:2.3.1
	com.fasterxml.jackson.core:jackson-databind:jar:2.3.1
	com.fasterxml.jackson.jaxrs:jackson-jaxrs-base:jar:2.3.1
	com.fasterxml.jackson.jaxrs:jackson-jaxrs-json-provider:jar:2.3.1
	com.fasterxml.jackson.jaxrs:jackson-jaxrs-providers:pom:2.3.1
	com.fasterxml.jackson.module:jackson-module-jaxb-annotations:jar:2.3.1
	com.fasterxml:oss-parent:pom:11
	com.fasterxml:oss-parent:pom:12
	com.google.code.findbugs:jsr305:jar:2.0.1
	com.google.collections:google-collections:jar:1.0
	com.google.guava:guava-parent:pom:14.0.1
	com.google.guava:guava-parent:pom:19.0
	com.google.guava:guava:jar:14.0.1
	com.google.guava:guava:jar:19.0
	com.google:google:pom:1
	com.intellij:annotations:jar:9.0.4
	com.sun.jersey.contribs:jersey-apache-client4:jar:1.17.1
	com.sun.jersey.contribs:jersey-contribs:pom:1.17.1
	com.sun.jersey:jersey-client:jar:1.17.1
	com.sun.jersey:jersey-core:jar:1.17.1
	com.sun.jersey:jersey-project:pom:1.17.1
	com.thoughtworks.xstream:xstream-parent:pom:1.4.7
	com.thoughtworks.xstream:xstream:jar:1.4.7
	javax.inject:javax.inject:jar:1
	javax.validation:validation-api:jar:1.1.0.Final
	javax.ws.rs:jsr311-api:jar:1.1.1
	javax.xml.bind:jaxb-api:jar:2.3.0
	javax.xml.bind:jaxb-api-parent:pom:2.3.0
	javax.xml.soap:javax.xml.soap-api:jar:1.4.0
	javax.xml.ws:jaxws-api:jar:2.3.0
	joda-time:joda-time:jar:2.2
	junit:junit:jar:3.8.1
	junit:junit:jar:3.8.2
	log4j:log4j:jar:1.2.12
	net.java:jvnet-parent:pom:1
	net.java:jvnet-parent:pom:5
	org.apache.ant:ant-launcher:jar:1.8.1
	org.apache.ant:ant-nodeps:jar:1.8.1
	org.apache.ant:ant-parent:pom:1.8.1
	org.apache.ant:ant:jar:1.8.1
	org.apache.commons:commons-parent:pom:7
	org.apache.commons:commons-parent:pom:9
	org.apache.commons:commons-parent:pom:11
	org.apache.commons:commons-parent:pom:17
	org.apache.commons:commons-parent:pom:22
	org.apache.commons:commons-parent:pom:25
	org.apache.commons:commons-parent:pom:39
	org.apache.httpcomponents:httpclient:jar:4.3.5
	org.apache.httpcomponents:httpcomponents-client:pom:4.3.5
	org.apache.httpcomponents:httpcomponents-core:pom:4.3.2
	org.apache.httpcomponents:httpcore:jar:4.3.2
	org.apache.httpcomponents:project:pom:7
	org.apache.maven.doxia:doxia-core:jar:1.0
	org.apache.maven.doxia:doxia-decoration-model:jar:1.0
	org.apache.maven.doxia:doxia-logging-api:jar:1.1
	org.apache.maven.doxia:doxia-modules:pom:1.0
	org.apache.maven.doxia:doxia-module-apt:jar:1.0
	org.apache.maven.doxia:doxia-module-fml:jar:1.0
	org.apache.maven.doxia:doxia-module-xdoc:jar:1.0
	org.apache.maven.doxia:doxia-module-xhtml:jar:1.0
	org.apache.maven.doxia:doxia-sink-api:jar:1.0
	org.apache.maven.doxia:doxia-sink-api:jar:1.0-alpha-7
	org.apache.maven.doxia:doxia-sink-api:jar:1.0-alpha-10
	org.apache.maven.doxia:doxia-sink-api:jar:1.1
	org.apache.maven.doxia:doxia-sitetools:pom:1.0
	org.apache.maven.doxia:doxia-site-renderer:jar:1.0
	org.apache.maven.doxia:doxia:pom:1.0
	org.apache.maven.doxia:doxia:pom:1.0-alpha-7
	org.apache.maven.doxia:doxia:pom:1.0-alpha-10
	org.apache.maven.doxia:doxia:pom:1.1
	org.apache.maven.plugins:maven-antrun-plugin:jar:1.3
	org.apache.maven.plugins:maven-antrun-plugin:jar:1.6
	org.apache.maven.plugins:maven-assembly-plugin:jar:2.2
	org.apache.maven.plugins:maven-assembly-plugin:jar:2.2-beta-5
	org.apache.maven.plugins:maven-clean-plugin:jar:2.5
	org.apache.maven.plugins:maven-compiler-plugin:jar:3.1
	org.apache.maven.plugins:maven-dependency-plugin:jar:2.8
	org.apache.maven.plugins:maven-deploy-plugin:jar:2.7
	org.apache.maven.plugins:maven-install-plugin:jar:2.4
	org.apache.maven.plugins:maven-jar-plugin:jar:2.3.1
	org.apache.maven.plugins:maven-plugins:pom:12
	org.apache.maven.plugins:maven-plugins:pom:16
	org.apache.maven.plugins:maven-plugins:pom:18
	org.apache.maven.plugins:maven-plugins:pom:22
	org.apache.maven.plugins:maven-plugins:pom:23
	org.apache.maven.plugins:maven-plugins:pom:24
	org.apache.maven.plugins:maven-plugins:pom:30
	org.apache.maven.plugins:maven-release-plugin:jar:2.3.2
	org.apache.maven.plugins:maven-release-plugin:jar:2.4.1
	org.apache.maven.plugins:maven-resources-plugin:jar:2.6
	org.apache.maven.plugins:maven-shade-plugin:jar:3.1.0
	org.apache.maven.plugins:maven-site-plugin:jar:3.3
	org.apache.maven.plugins:maven-source-plugin:jar:2.1.2
	org.apache.maven.plugins:maven-surefire-plugin:jar:2.6
	org.apache.maven.release:maven-release:pom:2.3.2
	org.apache.maven.release:maven-release:pom:2.4.1
	org.apache.maven.reporting:maven-reporting-api:jar:2.0.2
	org.apache.maven.reporting:maven-reporting-api:jar:2.0.6
	org.apache.maven.reporting:maven-reporting-api:jar:2.0.9
	org.apache.maven.reporting:maven-reporting-api:jar:2.2.1
	org.apache.maven.reporting:maven-reporting-api:jar:3.0
	org.apache.maven.reporting:maven-reporting-impl:jar:2.0.5
	org.apache.maven.reporting:maven-reporting:pom:2.0.2
	org.apache.maven.reporting:maven-reporting:pom:2.0.6
	org.apache.maven.reporting:maven-reporting:pom:2.0.9
	org.apache.maven.reporting:maven-reporting:pom:2.2.1
	org.apache.maven.shared:file-management:jar:1.1
	org.apache.maven.shared:file-management:jar:1.2.1
	org.apache.maven.shared:maven-artifact-transfer:jar:0.9.1
	org.apache.maven.shared:maven-common-artifact-filters:jar:1.0-alpha-1
	org.apache.maven.shared:maven-common-artifact-filters:jar:1.2
	org.apache.maven.shared:maven-common-artifact-filters:jar:1.3
	org.apache.maven.shared:maven-common-artifact-filters:jar:1.4
	org.apache.maven.shared:maven-common-artifact-filters:jar:3.0.1
	org.apache.maven.shared:maven-dependency-analyzer:jar:1.4
	org.apache.maven.shared:maven-dependency-tree:jar:2.1
	org.apache.maven.shared:maven-dependency-tree:jar:2.2
	org.apache.maven.shared:maven-doxia-tools:jar:1.0.2
	org.apache.maven.shared:maven-filtering:jar:1.0-beta-4
	org.apache.maven.shared:maven-filtering:jar:1.1
	org.apache.maven.shared:maven-invoker:jar:2.0.11
	org.apache.maven.shared:maven-repository-builder:jar:1.0-alpha-2
	org.apache.maven.shared:maven-shared-components:pom:4
	org.apache.maven.shared:maven-shared-components:pom:6
	org.apache.maven.shared:maven-shared-components:pom:7
	org.apache.maven.shared:maven-shared-components:pom:8
	org.apache.maven.shared:maven-shared-components:pom:10
	org.apache.maven.shared:maven-shared-components:pom:11
	org.apache.maven.shared:maven-shared-components:pom:12
	org.apache.maven.shared:maven-shared-components:pom:15
	org.apache.maven.shared:maven-shared-components:pom:17
	org.apache.maven.shared:maven-shared-components:pom:18
	org.apache.maven.shared:maven-shared-components:pom:19
	org.apache.maven.shared:maven-shared-components:pom:20
	org.apache.maven.shared:maven-shared-components:pom:30
	org.apache.maven.shared:maven-shared-incremental:jar:1.1
	org.apache.maven.shared:maven-shared-io:jar:1.0
	org.apache.maven.shared:maven-shared-io:jar:1.1
	org.apache.maven.shared:maven-shared-utils:jar:0.1
	org.apache.maven.shared:maven-shared-utils:jar:3.1.0
	org.apache.maven.surefire:maven-surefire-common:jar:2.6
	org.apache.maven.surefire:surefire-api:jar:2.6
	org.apache.maven.surefire:surefire-booter:jar:2.6
	org.apache.maven.surefire:surefire:pom:2.6
	org.apache.maven.wagon:wagon-provider-api:jar:1.0-alpha-6
	org.apache.maven.wagon:wagon:pom:1.0-alpha-6
	org.apache.maven:maven-aether-provider:jar:3.0
	org.apache.maven:maven-archiver:jar:2.4.1
	org.apache.maven:maven-artifact-manager:jar:2.0.2
	org.apache.maven:maven-artifact-manager:jar:2.0.4
	org.apache.maven:maven-artifact-manager:jar:2.0.5
	org.apache.maven:maven-artifact-manager:jar:2.0.6
	org.apache.maven:maven-artifact-manager:jar:2.0.8
	org.apache.maven:maven-artifact-manager:jar:2.0.9
	org.apache.maven:maven-artifact-manager:jar:2.0.11
	org.apache.maven:maven-artifact-manager:jar:2.2.0
	org.apache.maven:maven-artifact-manager:jar:2.2.1
	org.apache.maven:maven-artifact:jar:2.0.2
	org.apache.maven:maven-artifact:jar:2.0.4
	org.apache.maven:maven-artifact:jar:2.0.5
	org.apache.maven:maven-artifact:jar:2.0.6
	org.apache.maven:maven-artifact:jar:2.0.8
	org.apache.maven:maven-artifact:jar:2.0.9
	org.apache.maven:maven-artifact:jar:2.0.11
	org.apache.maven:maven-artifact:jar:2.2.0
	org.apache.maven:maven-artifact:jar:2.2.1
	org.apache.maven:maven-artifact:jar:3.0
	org.apache.maven:maven-core:jar:2.0.2
	org.apache.maven:maven-core:jar:2.0.6
	org.apache.maven:maven-core:jar:2.0.9
	org.apache.maven:maven-core:jar:2.2.1
	org.apache.maven:maven-core:jar:3.0
	org.apache.maven:maven-error-diagnostics:jar:2.0.2
	org.apache.maven:maven-error-diagnostics:jar:2.0.6
	org.apache.maven:maven-error-diagnostics:jar:2.0.9
	org.apache.maven:maven-error-diagnostics:jar:2.2.1
	org.apache.maven:maven-model-builder:jar:3.0
	org.apache.maven:maven-model:jar:2.0.2
	org.apache.maven:maven-model:jar:2.0.4
	org.apache.maven:maven-model:jar:2.0.5
	org.apache.maven:maven-model:jar:2.0.6
	org.apache.maven:maven-model:jar:2.0.8
	org.apache.maven:maven-model:jar:2.0.9
	org.apache.maven:maven-model:jar:2.0.11
	org.apache.maven:maven-model:jar:2.2.0
	org.apache.maven:maven-model:jar:2.2.1
	org.apache.maven:maven-model:jar:3.0
	org.apache.maven:maven-model:jar:3.0.4
	org.apache.maven:maven-monitor:jar:2.0.2
	org.apache.maven:maven-monitor:jar:2.0.6
	org.apache.maven:maven-monitor:jar:2.0.9
	org.apache.maven:maven-monitor:jar:2.2.1
	org.apache.maven:maven-parent:pom:4
	org.apache.maven:maven-parent:pom:5
	org.apache.maven:maven-parent:pom:6
	org.apache.maven:maven-parent:pom:7
	org.apache.maven:maven-parent:pom:8
	org.apache.maven:maven-parent:pom:9
	org.apache.maven:maven-parent:pom:10
	org.apache.maven:maven-parent:pom:11
	org.apache.maven:maven-parent:pom:12
	org.apache.maven:maven-parent:pom:13
	org.apache.maven:maven-parent:pom:15
	org.apache.maven:maven-parent:pom:16
	org.apache.maven:maven-parent:pom:21
	org.apache.maven:maven-parent:pom:22
	org.apache.maven:maven-parent:pom:23
	org.apache.maven:maven-parent:pom:24
	org.apache.maven:maven-parent:pom:30
	org.apache.maven:maven-plugin-api:jar:2.0
	org.apache.maven:maven-plugin-api:jar:2.0.2
	org.apache.maven:maven-plugin-api:jar:2.0.6
	org.apache.maven:maven-plugin-api:jar:2.0.8
	org.apache.maven:maven-plugin-api:jar:2.0.9
	org.apache.maven:maven-plugin-api:jar:2.0.11
	org.apache.maven:maven-plugin-api:jar:2.2.1
	org.apache.maven:maven-plugin-api:jar:3.0
	org.apache.maven:maven-plugin-descriptor:jar:2.0.2
	org.apache.maven:maven-plugin-descriptor:jar:2.0.6
	org.apache.maven:maven-plugin-descriptor:jar:2.0.9
	org.apache.maven:maven-plugin-descriptor:jar:2.2.1
	org.apache.maven:maven-plugin-parameter-documenter:jar:2.0.2
	org.apache.maven:maven-plugin-parameter-documenter:jar:2.0.6
	org.apache.maven:maven-plugin-parameter-documenter:jar:2.0.9
	org.apache.maven:maven-plugin-parameter-documenter:jar:2.2.1
	org.apache.maven:maven-plugin-registry:jar:2.0.2
	org.apache.maven:maven-plugin-registry:jar:2.0.6
	org.apache.maven:maven-plugin-registry:jar:2.0.8
	org.apache.maven:maven-plugin-registry:jar:2.0.9
	org.apache.maven:maven-plugin-registry:jar:2.0.11
	org.apache.maven:maven-plugin-registry:jar:2.2.0
	org.apache.maven:maven-plugin-registry:jar:2.2.1
	org.apache.maven:maven-profile:jar:2.0.2
	org.apache.maven:maven-profile:jar:2.0.4
	org.apache.maven:maven-profile:jar:2.0.5
	org.apache.maven:maven-profile:jar:2.0.6
	org.apache.maven:maven-profile:jar:2.0.8
	org.apache.maven:maven-profile:jar:2.0.9
	org.apache.maven:maven-profile:jar:2.0.11
	org.apache.maven:maven-profile:jar:2.2.0
	org.apache.maven:maven-profile:jar:2.2.1
	org.apache.maven:maven-project:jar:2.0.2
	org.apache.maven:maven-project:jar:2.0.4
	org.apache.maven:maven-project:jar:2.0.5
	org.apache.maven:maven-project:jar:2.0.6
	org.apache.maven:maven-project:jar:2.0.8
	org.apache.maven:maven-project:jar:2.0.9
	org.apache.maven:maven-project:jar:2.0.11
	org.apache.maven:maven-project:jar:2.2.0
	org.apache.maven:maven-project:jar:2.2.1
	org.apache.maven:maven-repository-metadata:jar:2.0.2
	org.apache.maven:maven-repository-metadata:jar:2.0.4
	org.apache.maven:maven-repository-metadata:jar:2.0.5
	org.apache.maven:maven-repository-metadata:jar:2.0.6
	org.apache.maven:maven-repository-metadata:jar:2.0.8
	org.apache.maven:maven-repository-metadata:jar:2.0.9
	org.apache.maven:maven-repository-metadata:jar:2.0.11
	org.apache.maven:maven-repository-metadata:jar:2.2.0
	org.apache.maven:maven-repository-metadata:jar:2.2.1
	org.apache.maven:maven-repository-metadata:jar:3.0
	org.apache.maven:maven-settings-builder:jar:3.0
	org.apache.maven:maven-settings:jar:2.0.2
	org.apache.maven:maven-settings:jar:2.0.4
	org.apache.maven:maven-settings:jar:2.0.5
	org.apache.maven:maven-settings:jar:2.0.6
	org.apache.maven:maven-settings:jar:2.0.8
	org.apache.maven:maven-settings:jar:2.0.9
	org.apache.maven:maven-settings:jar:2.0.11
	org.apache.maven:maven-settings:jar:2.2.0
	org.apache.maven:maven-settings:jar:2.2.1
	org.apache.maven:maven-settings:jar:3.0
	org.apache.maven:maven-toolchain:jar:1.0
	org.apache.maven:maven-toolchain:jar:2.0.9
	org.apache.maven:maven:pom:2.0
	org.apache.maven:maven:pom:2.0.2
	org.apache.maven:maven:pom:2.0.4
	org.apache.maven:maven:pom:2.0.5
	org.apache.maven:maven:pom:2.0.6
	org.apache.maven:maven:pom:2.0.8
	org.apache.maven:maven:pom:2.0.9
	org.apache.maven:maven:pom:2.0.11
	org.apache.maven:maven:pom:2.2.0
	org.apache.maven:maven:pom:2.2.1
	org.apache.maven:maven:pom:3.0
	org.apache.maven:maven:pom:3.0.4
	org.apache.velocity:velocity:jar:1.5
	org.apache.xbean:xbean-reflect:jar:3.4
	org.apache.xbean:xbean:pom:3.4
	org.apache:apache:pom:3
	org.apache:apache:pom:4
	org.apache:apache:pom:5
	org.apache:apache:pom:6
	org.apache:apache:pom:7
	org.apache:apache:pom:9
	org.apache:apache:pom:10
	org.apache:apache:pom:11
	org.apache:apache:pom:13
	org.apache:apache:pom:14
	org.apache:apache:pom:16
	org.apache:apache:pom:18
	org.clojure:core.specs.alpha:jar:0.2.44
	org.clojure:data.generators:jar:0.1.2
	org.clojure:pom.contrib:pom:0.0.26
	org.clojure:pom.contrib:pom:0.1.2
	org.clojure:pom.contrib:pom:0.2.2
	org.clojure:spec.alpha:jar:0.2.176
	org.clojure:test.check:jar:0.9.0
	org.clojure:test.generative:jar:0.5.2
	org.clojure:tools.namespace:jar:0.2.10
	org.codehaus.mojo:build-helper-maven-plugin:jar:1.5
	org.codehaus.mojo:mojo-parent:pom:23
	org.codehaus.plexus:plexus-archiver:jar:1.0
	org.codehaus.plexus:plexus-archiver:jar:1.1
	org.codehaus.plexus:plexus-archiver:jar:2.3
	org.codehaus.plexus:plexus-classworlds:jar:1.2-alpha-7
	org.codehaus.plexus:plexus-classworlds:jar:1.2-alpha-9
	org.codehaus.plexus:plexus-classworlds:jar:2.2.2
	org.codehaus.plexus:plexus-classworlds:jar:2.2.3
	org.codehaus.plexus:plexus-compilers:pom:2.2
	org.codehaus.plexus:plexus-compiler-api:jar:2.2
	org.codehaus.plexus:plexus-compiler-javac:jar:2.2
	org.codehaus.plexus:plexus-compiler-manager:jar:2.2
	org.codehaus.plexus:plexus-compiler:pom:2.2
	org.codehaus.plexus:plexus-components:pom:1.1.12
	org.codehaus.plexus:plexus-components:pom:1.1.14
	org.codehaus.plexus:plexus-components:pom:1.1.15
	org.codehaus.plexus:plexus-components:pom:1.1.17
	org.codehaus.plexus:plexus-components:pom:1.1.18
	org.codehaus.plexus:plexus-components:pom:1.2
	org.codehaus.plexus:plexus-components:pom:1.3
	org.codehaus.plexus:plexus-components:pom:1.3.1
	org.codehaus.plexus:plexus-component-annotations:jar:1.5.5
	org.codehaus.plexus:plexus-component-annotations:jar:1.6
	org.codehaus.plexus:plexus-containers:pom:1.0-alpha-20
	org.codehaus.plexus:plexus-containers:pom:1.0-alpha-30
	org.codehaus.plexus:plexus-containers:pom:1.0.3
	org.codehaus.plexus:plexus-containers:pom:1.5.5
	org.codehaus.plexus:plexus-containers:pom:1.6
	org.codehaus.plexus:plexus-container-default:jar:1.0-alpha-9
	org.codehaus.plexus:plexus-container-default:jar:1.0-alpha-9-stable-1
	org.codehaus.plexus:plexus-container-default:jar:1.0-alpha-20
	org.codehaus.plexus:plexus-container-default:jar:1.0-alpha-30
	org.codehaus.plexus:plexus-container-default:jar:1.5.5
	org.codehaus.plexus:plexus-i18n:jar:1.0-beta-7
	org.codehaus.plexus:plexus-interactivity-api:jar:1.0-alpha-4
	org.codehaus.plexus:plexus-interpolation:jar:1.1
	org.codehaus.plexus:plexus-interpolation:jar:1.11
	org.codehaus.plexus:plexus-interpolation:jar:1.12
	org.codehaus.plexus:plexus-interpolation:jar:1.13
	org.codehaus.plexus:plexus-interpolation:jar:1.14
	org.codehaus.plexus:plexus-interpolation:jar:1.15
	org.codehaus.plexus:plexus-io:jar:1.0
	org.codehaus.plexus:plexus-io:jar:1.0.1
	org.codehaus.plexus:plexus-io:jar:2.0.6
	org.codehaus.plexus:plexus-utils:jar:1.0.4
	org.codehaus.plexus:plexus-utils:jar:1.1
	org.codehaus.plexus:plexus-utils:jar:1.2
	org.codehaus.plexus:plexus-utils:jar:1.3
	org.codehaus.plexus:plexus-utils:jar:1.4.1
	org.codehaus.plexus:plexus-utils:jar:1.4.5
	org.codehaus.plexus:plexus-utils:jar:1.4.6
	org.codehaus.plexus:plexus-utils:jar:1.4.9
	org.codehaus.plexus:plexus-utils:jar:1.5.1
	org.codehaus.plexus:plexus-utils:jar:1.5.5
	org.codehaus.plexus:plexus-utils:jar:1.5.6
	org.codehaus.plexus:plexus-utils:jar:1.5.7
	org.codehaus.plexus:plexus-utils:jar:1.5.8
	org.codehaus.plexus:plexus-utils:jar:1.5.15
	org.codehaus.plexus:plexus-utils:jar:2.0.4
	org.codehaus.plexus:plexus-utils:jar:2.0.5
	org.codehaus.plexus:plexus-utils:jar:2.1
	org.codehaus.plexus:plexus-utils:jar:3.0.8
	org.codehaus.plexus:plexus-utils:jar:3.0.9
	org.codehaus.plexus:plexus-utils:jar:3.0.10
	org.codehaus.plexus:plexus-utils:jar:3.0.24
	org.codehaus.plexus:plexus-velocity:jar:1.1.7
	org.codehaus.plexus:plexus:pom:1.0.4
	org.codehaus.plexus:plexus:pom:1.0.5
	org.codehaus.plexus:plexus:pom:1.0.8
	org.codehaus.plexus:plexus:pom:1.0.9
	org.codehaus.plexus:plexus:pom:1.0.10
	org.codehaus.plexus:plexus:pom:1.0.11
	org.codehaus.plexus:plexus:pom:1.0.12
	org.codehaus.plexus:plexus:pom:2.0.2
	org.codehaus.plexus:plexus:pom:2.0.3
	org.codehaus.plexus:plexus:pom:2.0.5
	org.codehaus.plexus:plexus:pom:2.0.6
	org.codehaus.plexus:plexus:pom:2.0.7
	org.codehaus.plexus:plexus:pom:3.0.1
	org.codehaus.plexus:plexus:pom:3.2
	org.codehaus.plexus:plexus:pom:3.3
	org.codehaus.plexus:plexus:pom:3.3.1
	org.codehaus.plexus:plexus:pom:3.3.2
	org.codehaus.plexus:plexus:pom:4.0
	org.codehaus:codehaus-parent:pom:3
	org.eclipse.aether:aether-util:jar:0.9.0.M2
	org.eclipse.aether:aether:pom:0.9.0.M2
	org.fusesource.hawtbuf:hawtbuf-project:pom:1.9
	org.fusesource.hawtbuf:hawtbuf-proto:jar:1.9
	org.fusesource.hawtbuf:hawtbuf:jar:1.9
	org.fusesource:fusesource-pom:pom:1.9
	org.jdom:jdom:jar:1.1.3
	org.ow2.asm:asm-analysis:jar:6.0_BETA
	org.ow2.asm:asm-commons:jar:6.0_BETA
	org.ow2.asm:asm-parent:pom:6.0_BETA
	org.ow2.asm:asm-tree:jar:6.0_BETA
	org.ow2.asm:asm-util:jar:6.0_BETA
	org.ow2.asm:asm:jar:6.0_BETA
	org.ow2:ow2:pom:1.3
	org.slf4j:jcl-over-slf4j:jar:1.5.6
	org.slf4j:jcl-over-slf4j:jar:1.7.7
	org.slf4j:slf4j-api:jar:1.5.6
	org.slf4j:slf4j-api:jar:1.7.5
	org.slf4j:slf4j-api:jar:1.7.7
	org.slf4j:slf4j-jdk14:jar:1.5.6
	org.slf4j:slf4j-parent:pom:1.5.6
	org.slf4j:slf4j-parent:pom:1.7.5
	org.slf4j:slf4j-parent:pom:1.7.7
	org.sonatype.aether:aether-api:jar:1.7
	org.sonatype.aether:aether-api:jar:1.13.1
	org.sonatype.aether:aether-impl:jar:1.7
	org.sonatype.aether:aether-parent:pom:1.7
	org.sonatype.aether:aether-spi:jar:1.7
	org.sonatype.aether:aether-util:jar:1.7
	org.sonatype.aether:aether:pom:1.13.1
	org.sonatype.buildsupport:buildsupport:pom:5
	org.sonatype.buildsupport:buildsupport:pom:6
	org.sonatype.buildsupport:public-parent:pom:5
	org.sonatype.buildsupport:public-parent:pom:6
	org.sonatype.forge:forge-parent:pom:3
	org.sonatype.forge:forge-parent:pom:4
	org.sonatype.forge:forge-parent:pom:5
	org.sonatype.forge:forge-parent:pom:6
	org.sonatype.forge:forge-parent:pom:10
	org.sonatype.nexus.buildsupport:nexus-buildsupport-all:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-bouncycastle:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-commons:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-db:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-goodies:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-groovy:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-guice:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-httpclient:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-jetty:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-logging:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-maven:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-metrics:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-osgi:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-other:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-plexus:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-rest:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-shiro:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport-testing:pom:2.9.1-02
	org.sonatype.nexus.buildsupport:nexus-buildsupport:pom:2.9.1-02
	org.sonatype.nexus.maven:nexus-common:jar:1.6.7
	org.sonatype.nexus.maven:nexus-maven-plugins:pom:1.6.7
	org.sonatype.nexus.maven:nexus-staging:pom:1.6.7
	org.sonatype.nexus.plugins:nexus-plugins-restlet1x:pom:2.9.1-02
	org.sonatype.nexus.plugins:nexus-plugins:pom:2.9.1-02
	org.sonatype.nexus.plugins:nexus-restlet1x-model:jar:2.9.1-02
	org.sonatype.nexus:nexus-client-core:jar:2.9.1-02
	org.sonatype.nexus:nexus-components:pom:2.9.1-02
	org.sonatype.nexus:nexus-oss:pom:2.9.1-02
	org.sonatype.oss:oss-parent:pom:5
	org.sonatype.oss:oss-parent:pom:7
	org.sonatype.plexus:plexus-build-api:jar:0.0.4
	org.sonatype.plexus:plexus-cipher:jar:1.4
	org.sonatype.plexus:plexus-cipher:jar:1.7
	org.sonatype.plexus:plexus-sec-dispatcher:jar:1.3
	org.sonatype.plexus:plexus-sec-dispatcher:jar:1.4
	org.sonatype.plugins:nexus-staging-maven-plugin:jar:1.6.7
	org.sonatype.sisu.inject:guice-bean:pom:1.4.2
	org.sonatype.sisu.inject:guice-plexus:pom:1.4.2
	org.sonatype.sisu.siesta:siesta-client:jar:1.7
	org.sonatype.sisu.siesta:siesta-common:jar:1.7
	org.sonatype.sisu.siesta:siesta-jackson:jar:1.7
	org.sonatype.sisu.siesta:siesta:pom:1.7
	org.sonatype.sisu:sisu-guice:jar:noaop:2.1.7
	org.sonatype.sisu:sisu-inject-bean:jar:1.4.2
	org.sonatype.sisu:sisu-inject-plexus:jar:1.4.2
	org.sonatype.sisu:sisu-inject:pom:1.4.2
	org.sonatype.sisu:sisu-parent:pom:1.4.2
	org.sonatype.spice.zapper:spice-zapper:jar:1.3
	org.sonatype.spice:spice-parent:pom:10
	org.sonatype.spice:spice-parent:pom:12
	org.sonatype.spice:spice-parent:pom:15
	org.sonatype.spice:spice-parent:pom:16
	org.sonatype.spice:spice-parent:pom:17
	org.vafer:jdependency:jar:1.2
	oro:oro:jar:2.0.8
	xmlpull:xmlpull:jar:1.1.3.1
	xml-apis:xml-apis:jar:1.0.b2
	xml-apis:xml-apis:jar:2.0.2
	xpp3:xpp3_min:jar:1.1.4c
)

__extract_info() {
	local f="$1" host="$2" artifact="$3"
	local rest="${artifact}" group name type version classifier
	group=${rest%%:*}
	rest=${rest#*:}
	name=${rest%%:*}
	rest=${rest#*:}
	type=${rest%%:*}
	rest=${rest#*:}
	version=${rest%%:*}

	if ! [[ "${rest}" = "${rest#*:}" ]] ; then
		classifier="${version}"
		rest=${rest#*:}
		version=${rest%%:*}
	fi

	${f} "${host}" "${group}" "${name}" "${type}" "${version}" "${classifier}" || die
}

__jar_and_pom() {
	local f="$1" host="$2" group="$3" name="$4" type="$5" version="$6" classifier="$7"
	${f} "${host}" "${group}" "${name}" "${type}" "${version}" "${classifier}" || die
	# For JARs we also always need POMs:
	if [[ "${type}" = jar ]] ; then
		${f} "${host}" "${group}" "${name}" pom "${version}" "${classifier}" || die
	fi
}

__add_to_src_uri() {
	local host="$1" group="$2" name="$3" type="$4" version="$5" classifier="$6"
	local path="${group//.//}"
	local directory="${path}/${name}/${version}" file="${name}-${version}.${type}"
	if [[ "${type}" != pom ]] && [[ -n "${classifier}" ]] ; then
		file="${name}-${version}-${classifier}.${type}"
	fi
	SRC_URI+=" ${host}/${directory}/${file} -> ${group}:${file}"
}

__set_vendor_uri() {
	local lib host artifact
	for lib in "${EMAVEN_ARTIFACTS[@]}"; do
		host=${lib%% *}
		[[ "${host}" = "${lib}" ]] && host="https://repo.maven.apache.org/maven2"
		artifact=${lib##* }
		__extract_info '__jar_and_pom __add_to_src_uri' "${host}" "${artifact}" || die
	done
}

__set_vendor_uri
unset -f __set_vendor_uri __src_uri __add_to_src_uri

pkg_setup() {
	java-pkg_init
}

__copy_to_maven_repository() {
	local host="$1" group="$2" name="$3" type="$4" version="$5" classifier="$6"
	local path="${group//.//}"
	local maven_repository="${HOME}/.m2/repository"
	local directory="${path}/${name}/${version}" file="${name}-${version}.${type}"
	if [[ "${type}" != pom ]] && [[ -n "${classifier}" ]] ; then
		file="${name}-${version}-${classifier}.${type}"
	fi
	mkdir -p "${maven_repository}/${directory}" || die
	cp "${DISTDIR}/${group}:${file}" "${maven_repository}/${directory}/${file}" || die
}

src_unpack() {
	unpack "${P}.tar.gz"
	local lib artifact
	for lib in "${EMAVEN_ARTIFACTS[@]}"; do
		artifact=${lib##* }
		__extract_info '__jar_and_pom __copy_to_maven_repository' '' "${artifact}" || die
	done
}

src_configure() {
	:
}

emvn() {
	local mavenflags=(
		--offline
		--define user.home="$HOME"
		--fail-at-end
	)
	if [[ ${EBUILD_PHASE} != "test" ]]; then
		mavenflags+=(--define maven.test.skip=true)
	fi
	if [[ -n ${JAVA_PKG_DEBUG} ]]; then
		mavenflags+=(--debug)
	fi
	mvn "${mavenflags[@]}" "$@" || die
}

src_compile() {
	emvn --activate-profiles local package || die
}

src_test() {
	emvn --activate-profiles local test || die
}

src_install() {
	java-pkg_newjar "${PN}.jar"
	java-pkg_dolauncher  ${PN}-${SLOT} --main clojure.main
	if use source; then
		mv target/${P}-sources.jar ${PN}-sources.jar
		insinto /usr/share/${PN}-${SLOT}/sources
		doins ${PN}-sources.jar
	fi
	einstalldocs
}
