# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils xdg

MY_COMMIT_HASH="7d5ac993d3f88f6701f56edbfe325d86afcaad87"

DESCRIPTION="Mathematics software for geometry"
HOMEPAGE="https://www.geogebra.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_COMMIT_HASH}.tar.gz -> ${P}.tar.gz
	http://dev.geogebra.org/maven2/com/apple/mac_extensions/20040714/mac_extensions-20040714.jar
	http://dev.geogebra.org/maven2/com/apple/mac_extensions/20040714/mac_extensions-20040714.pom
	http://dev.geogebra.org/maven2/com/googlecode/gwtgl/0.9.1/gwtgl-0.9.1.jar
	http://dev.geogebra.org/maven2/com/googlecode/gwtgl/0.9.1/gwtgl-0.9.1.pom
	http://dev.geogebra.org/maven2/com/googlecode/gwtgl/0.9.1/gwtgl-0.9.1-sources.jar
	http://dev.geogebra.org/maven2/com/google/j2objc/annotations/1.0.2/annotations-1.0.2.jar
	http://dev.geogebra.org/maven2/com/google/j2objc/annotations/1.0.2/annotations-1.0.2.pom
	http://dev.geogebra.org/maven2/com/jogamp/gluegen-rt/2.2.0/gluegen-rt-2.2.0.jar
	http://dev.geogebra.org/maven2/com/jogamp/gluegen-rt/2.2.0/gluegen-rt-2.2.0-natives-linux-amd64.jar
	http://dev.geogebra.org/maven2/com/jogamp/gluegen-rt/2.2.0/gluegen-rt-2.2.0-natives-linux-i586.jar
	http://dev.geogebra.org/maven2/com/jogamp/gluegen-rt/2.2.0/gluegen-rt-2.2.0-natives-macosx-universal.jar
	http://dev.geogebra.org/maven2/com/jogamp/gluegen-rt/2.2.0/gluegen-rt-2.2.0-natives-windows-amd64.jar
	http://dev.geogebra.org/maven2/com/jogamp/gluegen-rt/2.2.0/gluegen-rt-2.2.0-natives-windows-i586.jar
	http://dev.geogebra.org/maven2/com/jogamp/gluegen-rt/2.2.0/gluegen-rt-2.2.0.pom
	http://dev.geogebra.org/maven2/com/jogamp/jogl-all/2.2.0/jogl-all-2.2.0.jar
	http://dev.geogebra.org/maven2/com/jogamp/jogl-all/2.2.0/jogl-all-2.2.0-natives-linux-amd64.jar
	http://dev.geogebra.org/maven2/com/jogamp/jogl-all/2.2.0/jogl-all-2.2.0-natives-linux-i586.jar
	http://dev.geogebra.org/maven2/com/jogamp/jogl-all/2.2.0/jogl-all-2.2.0-natives-macosx-universal.jar
	http://dev.geogebra.org/maven2/com/jogamp/jogl-all/2.2.0/jogl-all-2.2.0-natives-windows-amd64.jar
	http://dev.geogebra.org/maven2/com/jogamp/jogl-all/2.2.0/jogl-all-2.2.0-natives-windows-i586.jar
	http://dev.geogebra.org/maven2/com/jogamp/jogl-all/2.2.0/jogl-all-2.2.0.pom
	http://dev.geogebra.org/maven2/com/ogprover/OpenGeoProver/20120725/OpenGeoProver-20120725.jar
	http://dev.geogebra.org/maven2/com/ogprover/OpenGeoProver/20120725/OpenGeoProver-20120725.pom
	http://dev.geogebra.org/maven2/com/sun/jna/4.1.0/jna-4.1.0.jar
	http://dev.geogebra.org/maven2/com/sun/jna/4.1.0/jna-4.1.0.pom
	http://dev.geogebra.org/maven2/com/zspace/zspace/20151207/zspace-20151207.jar
	http://dev.geogebra.org/maven2/com/zspace/zspace/20151207/zspace-20151207-natives-windows-amd64.jar
	http://dev.geogebra.org/maven2/com/zspace/zspace/20151207/zspace-20151207-natives-windows-i586.jar
	http://dev.geogebra.org/maven2/com/zspace/zspace/20151207/zspace-20151207.pom
	http://dev.geogebra.org/maven2/fr/ujf-grenoble/javagiac/52580/javagiac-52580-natives-linux-amd64.jar
	http://dev.geogebra.org/maven2/fr/ujf-grenoble/javagiac/52580/javagiac-52580-natives-linux-i586.jar
	http://dev.geogebra.org/maven2/fr/ujf-grenoble/javagiac/52580/javagiac-52580-natives-macosx-universal.jar
	http://dev.geogebra.org/maven2/fr/ujf-grenoble/javagiac/52580/javagiac-52580-natives-windows-amd64.jar
	http://dev.geogebra.org/maven2/fr/ujf-grenoble/javagiac/52580/javagiac-52580-natives-windows-i586.jar
	http://dev.geogebra.org/maven2/fr/ujf-grenoble/javagiac/52580/javagiac-52580.pom
	http://dev.geogebra.org/maven2/intel/rssdk/libpxcclr/20150901/libpxcclr-20150901.jar
	http://dev.geogebra.org/maven2/intel/rssdk/libpxcclr/20150901/libpxcclr-20150901-natives-windows-amd64.jar
	http://dev.geogebra.org/maven2/intel/rssdk/libpxcclr/20150901/libpxcclr-20150901-natives-windows-i586.jar
	http://dev.geogebra.org/maven2/intel/rssdk/libpxcclr/20150901/libpxcclr-20150901.pom
	http://dev.geogebra.org/maven2/netscape/javascript/jsobject/1/jsobject-1.jar
	http://dev.geogebra.org/maven2/netscape/javascript/jsobject/1/jsobject-1.pom
	https://plugins.gradle.org/m2/ca/coglinc/javacc-gradle-plugin/2.4.0/javacc-gradle-plugin-2.4.0.jar
	https://plugins.gradle.org/m2/ca/coglinc/javacc-gradle-plugin/2.4.0/javacc-gradle-plugin-2.4.0.pom
	https://plugins.gradle.org/m2/com/google/guava/guava-jdk5/17.0/guava-jdk5-17.0.jar
	https://plugins.gradle.org/m2/com/google/guava/guava-jdk5/17.0/guava-jdk5-17.0.pom
	https://plugins.gradle.org/m2/com/google/guava/guava-parent-jdk5/17.0/guava-parent-jdk5-17.0.pom
	https://plugins.gradle.org/m2/commons-io/commons-io/2.4/commons-io-2.4.jar
	https://plugins.gradle.org/m2/commons-io/commons-io/2.4/commons-io-2.4.pom
	https://plugins.gradle.org/m2/de/richsource/gradle/plugins/gwt-gradle-plugin/0.6/gwt-gradle-plugin-0.6.jar
	https://plugins.gradle.org/m2/de/richsource/gradle/plugins/gwt-gradle-plugin/0.6/gwt-gradle-plugin-0.6.pom
	https://plugins.gradle.org/m2/org/apache/apache/16/apache-16.pom
	https://plugins.gradle.org/m2/org/apache/apache/9/apache-9.pom
	https://plugins.gradle.org/m2/org/apache/commons/commons-collections4/4.1/commons-collections4-4.1.jar
	https://plugins.gradle.org/m2/org/apache/commons/commons-collections4/4.1/commons-collections4-4.1.pom
	https://plugins.gradle.org/m2/org/apache/commons/commons-lang3/3.4/commons-lang3-3.4.jar
	https://plugins.gradle.org/m2/org/apache/commons/commons-lang3/3.4/commons-lang3-3.4.pom
	https://plugins.gradle.org/m2/org/apache/commons/commons-parent/25/commons-parent-25.pom
	https://plugins.gradle.org/m2/org/apache/commons/commons-parent/37/commons-parent-37.pom
	https://plugins.gradle.org/m2/org/apache/commons/commons-parent/38/commons-parent-38.pom
	https://plugins.gradle.org/m2/org/sonatype/oss/oss-parent/7/oss-parent-7.pom
	https://repo1.maven.org/maven2/ant/ant/1.6.5/ant-1.6.5.jar
	https://repo1.maven.org/maven2/ant/ant/1.6.5/ant-1.6.5.pom
	https://repo1.maven.org/maven2/colt/colt/1.2.0/colt-1.2.0.jar
	https://repo1.maven.org/maven2/colt/colt/1.2.0/colt-1.2.0.pom
	https://repo1.maven.org/maven2/com/asual/lesscss/lesscss-engine/1.3.0/lesscss-engine-1.3.0.jar
	https://repo1.maven.org/maven2/com/asual/lesscss/lesscss-engine/1.3.0/lesscss-engine-1.3.0.pom
	https://repo1.maven.org/maven2/com/google/code/findbugs/annotations/3.0.1/annotations-3.0.1.jar
	https://repo1.maven.org/maven2/com/google/code/findbugs/annotations/3.0.1/annotations-3.0.1.pom
	https://repo1.maven.org/maven2/com/google/code/gson/gson/2.6.2/gson-2.6.2.jar
	https://repo1.maven.org/maven2/com/google/code/gson/gson/2.6.2/gson-2.6.2.pom
	https://repo1.maven.org/maven2/com/google/code/gson/gson-parent/2.6.2/gson-parent-2.6.2.pom
	https://repo1.maven.org/maven2/com/googlecode/gwtphonegap/gwtphonegap/3.5.0.1/gwtphonegap-3.5.0.1.jar
	https://repo1.maven.org/maven2/com/googlecode/gwtphonegap/gwtphonegap/3.5.0.1/gwtphonegap-3.5.0.1.pom
	https://repo1.maven.org/maven2/com/google/gwt/gwt/2.8.0/gwt-2.8.0.pom
	https://repo1.maven.org/maven2/com/google/gwt/gwt-dev/2.8.0/gwt-dev-2.8.0.jar
	https://repo1.maven.org/maven2/com/google/gwt/gwt-dev/2.8.0/gwt-dev-2.8.0.pom
	https://repo1.maven.org/maven2/com/google/gwt/gwt-servlet/2.8.0/gwt-servlet-2.8.0.jar
	https://repo1.maven.org/maven2/com/google/gwt/gwt-servlet/2.8.0/gwt-servlet-2.8.0.pom
	https://repo1.maven.org/maven2/com/google/gwt/gwt-user/2.8.0/gwt-user-2.8.0.jar
	https://repo1.maven.org/maven2/com/google/gwt/gwt-user/2.8.0/gwt-user-2.8.0.pom
	https://repo1.maven.org/maven2/com/google/jsinterop/jsinterop/1.0.1/jsinterop-1.0.1.pom
	https://repo1.maven.org/maven2/com/google/jsinterop/jsinterop-annotations/1.0.1/jsinterop-annotations-1.0.1.jar
	https://repo1.maven.org/maven2/com/google/jsinterop/jsinterop-annotations/1.0.1/jsinterop-annotations-1.0.1.pom
	https://repo1.maven.org/maven2/com/google/jsinterop/jsinterop-annotations/1.0.1/jsinterop-annotations-1.0.1-sources.jar
	https://repo1.maven.org/maven2/com/google/web/bindery/requestfactory/2.8.0/requestfactory-2.8.0.pom
	https://repo1.maven.org/maven2/com/ibm/icu/icu4j/50.1.1/icu4j-50.1.1.jar
	https://repo1.maven.org/maven2/com/ibm/icu/icu4j/50.1.1/icu4j-50.1.1.pom
	https://repo1.maven.org/maven2/commons-codec/commons-codec/1.10/commons-codec-1.10.jar
	https://repo1.maven.org/maven2/commons-codec/commons-codec/1.10/commons-codec-1.10.pom
	https://repo1.maven.org/maven2/commons-collections/commons-collections/3.2.2/commons-collections-3.2.2.jar
	https://repo1.maven.org/maven2/commons-collections/commons-collections/3.2.2/commons-collections-3.2.2.pom
	https://repo1.maven.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.jar
	https://repo1.maven.org/maven2/commons-logging/commons-logging/1.2/commons-logging-1.2.pom
	https://repo1.maven.org/maven2/javax/annotation/javax.annotation-api/1.2/javax.annotation-api-1.2.jar
	https://repo1.maven.org/maven2/javax/annotation/javax.annotation-api/1.2/javax.annotation-api-1.2.pom
	https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar
	https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.pom
	https://repo1.maven.org/maven2/javax/validation/validation-api/1.0.0.GA/validation-api-1.0.0.GA.jar
	https://repo1.maven.org/maven2/javax/validation/validation-api/1.0.0.GA/validation-api-1.0.0.GA.pom
	https://repo1.maven.org/maven2/javax/validation/validation-api/1.0.0.GA/validation-api-1.0.0.GA-sources.jar
	https://repo1.maven.org/maven2/net/java/dev/javacc/javacc/6.1.2/javacc-6.1.2.jar
	https://repo1.maven.org/maven2/net/java/dev/javacc/javacc/6.1.2/javacc-6.1.2.pom
	https://repo1.maven.org/maven2/net/java/jvnet-parent/3/jvnet-parent-3.pom
	https://repo1.maven.org/maven2/net/sourceforge/cssparser/cssparser/0.9.18/cssparser-0.9.18.jar
	https://repo1.maven.org/maven2/net/sourceforge/cssparser/cssparser/0.9.18/cssparser-0.9.18.pom
	https://repo1.maven.org/maven2/net/sourceforge/htmlunit/htmlunit/2.19/htmlunit-2.19.jar
	https://repo1.maven.org/maven2/net/sourceforge/htmlunit/htmlunit/2.19/htmlunit-2.19.pom
	https://repo1.maven.org/maven2/net/sourceforge/htmlunit/htmlunit-core-js/2.17/htmlunit-core-js-2.17.jar
	https://repo1.maven.org/maven2/net/sourceforge/htmlunit/htmlunit-core-js/2.17/htmlunit-core-js-2.17.pom
	https://repo1.maven.org/maven2/net/sourceforge/nekohtml/nekohtml/1.9.22/nekohtml-1.9.22.jar
	https://repo1.maven.org/maven2/net/sourceforge/nekohtml/nekohtml/1.9.22/nekohtml-1.9.22.pom
	https://repo1.maven.org/maven2/org/apache/apache/13/apache-13.pom
	https://repo1.maven.org/maven2/org/apache/apache/15/apache-15.pom
	https://repo1.maven.org/maven2/org/apache/apache/3/apache-3.pom
	https://repo1.maven.org/maven2/org/apache/apache/4/apache-4.pom
	https://repo1.maven.org/maven2/org/apache/commons/commons-parent/34/commons-parent-34.pom
	https://repo1.maven.org/maven2/org/apache/commons/commons-parent/35/commons-parent-35.pom
	https://repo1.maven.org/maven2/org/apache/commons/commons-parent/39/commons-parent-39.pom
	https://repo1.maven.org/maven2/org/apache/httpcomponents/httpclient/4.5.1/httpclient-4.5.1.jar
	https://repo1.maven.org/maven2/org/apache/httpcomponents/httpclient/4.5.1/httpclient-4.5.1.pom
	https://repo1.maven.org/maven2/org/apache/httpcomponents/httpcomponents-client/4.5.1/httpcomponents-client-4.5.1.pom
	https://repo1.maven.org/maven2/org/apache/httpcomponents/httpcomponents-core/4.4.3/httpcomponents-core-4.4.3.pom
	https://repo1.maven.org/maven2/org/apache/httpcomponents/httpcore/4.4.3/httpcore-4.4.3.jar
	https://repo1.maven.org/maven2/org/apache/httpcomponents/httpcore/4.4.3/httpcore-4.4.3.pom
	https://repo1.maven.org/maven2/org/apache/httpcomponents/httpmime/4.5.1/httpmime-4.5.1.jar
	https://repo1.maven.org/maven2/org/apache/httpcomponents/httpmime/4.5.1/httpmime-4.5.1.pom
	https://repo1.maven.org/maven2/org/apache/httpcomponents/project/7/project-7.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/apache-jsp/9.2.14.v20151106/apache-jsp-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/apache-jsp/9.2.14.v20151106/apache-jsp-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-annotations/9.2.14.v20151106/jetty-annotations-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-annotations/9.2.14.v20151106/jetty-annotations-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-continuation/9.2.14.v20151106/jetty-continuation-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-continuation/9.2.14.v20151106/jetty-continuation-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-http/9.0.5.v20130815/jetty-http-9.0.5.v20130815.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-http/9.0.5.v20130815/jetty-http-9.0.5.v20130815.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-http/9.2.14.v20151106/jetty-http-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-http/9.2.14.v20151106/jetty-http-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-io/9.2.14.v20151106/jetty-io-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-io/9.2.14.v20151106/jetty-io-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-io/9.3.0.M2/jetty-io-9.3.0.M2.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-io/9.3.0.M2/jetty-io-9.3.0.M2.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-jndi/9.2.14.v20151106/jetty-jndi-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-jndi/9.2.14.v20151106/jetty-jndi-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-parent/18/jetty-parent-18.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-parent/20/jetty-parent-20.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-parent/22/jetty-parent-22.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-parent/23/jetty-parent-23.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-plus/9.2.14.v20151106/jetty-plus-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-plus/9.2.14.v20151106/jetty-plus-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-project/9.0.5.v20130815/jetty-project-9.0.5.v20130815.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-project/9.2.13.v20150730/jetty-project-9.2.13.v20150730.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-project/9.2.14.v20151106/jetty-project-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-project/9.3.0.M2/jetty-project-9.3.0.M2.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-security/9.2.14.v20151106/jetty-security-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-security/9.2.14.v20151106/jetty-security-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-server/9.2.14.v20151106/jetty-server-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-server/9.2.14.v20151106/jetty-server-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-servlet/9.2.14.v20151106/jetty-servlet-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-servlet/9.2.14.v20151106/jetty-servlet-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-servlets/9.2.14.v20151106/jetty-servlets-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-servlets/9.2.14.v20151106/jetty-servlets-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-util/9.2.14.v20151106/jetty-util-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-util/9.2.14.v20151106/jetty-util-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-util/9.3.0.M2/jetty-util-9.3.0.M2.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-util/9.3.0.M2/jetty-util-9.3.0.M2.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-webapp/9.2.14.v20151106/jetty-webapp-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-webapp/9.2.14.v20151106/jetty-webapp-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-xml/9.2.14.v20151106/jetty-xml-9.2.14.v20151106.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-xml/9.2.14.v20151106/jetty-xml-9.2.14.v20151106.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/toolchain/jetty-schemas/3.1.M0/jetty-schemas-3.1.M0.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/toolchain/jetty-schemas/3.1.M0/jetty-schemas-3.1.M0.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/toolchain/jetty-toolchain/1.4/jetty-toolchain-1.4.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-api/9.0.5.v20130815/websocket-api-9.0.5.v20130815.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-api/9.0.5.v20130815/websocket-api-9.0.5.v20130815.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-api/9.2.13.v20150730/websocket-api-9.2.13.v20150730.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-api/9.2.13.v20150730/websocket-api-9.2.13.v20150730.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-client/9.0.5.v20130815/websocket-client-9.0.5.v20130815.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-client/9.0.5.v20130815/websocket-client-9.0.5.v20130815.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-client/9.2.13.v20150730/websocket-client-9.2.13.v20150730.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-client/9.2.13.v20150730/websocket-client-9.2.13.v20150730.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-common/9.0.5.v20130815/websocket-common-9.0.5.v20130815.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-common/9.0.5.v20130815/websocket-common-9.0.5.v20130815.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-common/9.2.13.v20150730/websocket-common-9.2.13.v20150730.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-common/9.2.13.v20150730/websocket-common-9.2.13.v20150730.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-parent/9.0.5.v20130815/websocket-parent-9.0.5.v20130815.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-parent/9.2.13.v20150730/websocket-parent-9.2.13.v20150730.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-server/9.0.5.v20130815/websocket-server-9.0.5.v20130815.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-server/9.0.5.v20130815/websocket-server-9.0.5.v20130815.pom
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-servlet/9.0.5.v20130815/websocket-servlet-9.0.5.v20130815.jar
	https://repo1.maven.org/maven2/org/eclipse/jetty/websocket/websocket-servlet/9.0.5.v20130815/websocket-servlet-9.0.5.v20130815.pom
	https://repo1.maven.org/maven2/org/mortbay/jasper/apache-el/8.0.9.M3/apache-el-8.0.9.M3.jar
	https://repo1.maven.org/maven2/org/mortbay/jasper/apache-el/8.0.9.M3/apache-el-8.0.9.M3.pom
	https://repo1.maven.org/maven2/org/mortbay/jasper/apache-jsp/8.0.9.M3/apache-jsp-8.0.9.M3.jar
	https://repo1.maven.org/maven2/org/mortbay/jasper/apache-jsp/8.0.9.M3/apache-jsp-8.0.9.M3.pom
	https://repo1.maven.org/maven2/org/mortbay/jasper/jasper-jsp/8.0.9.M3/jasper-jsp-8.0.9.M3.pom
	https://repo1.maven.org/maven2/org/mozilla/rhino/1.7R3/rhino-1.7R3.jar
	https://repo1.maven.org/maven2/org/mozilla/rhino/1.7R3/rhino-1.7R3.pom
	https://repo1.maven.org/maven2/org/ow2/asm/asm/5.0.3/asm-5.0.3.jar
	https://repo1.maven.org/maven2/org/ow2/asm/asm/5.0.3/asm-5.0.3.pom
	https://repo1.maven.org/maven2/org/ow2/asm/asm-commons/5.0.3/asm-commons-5.0.3.jar
	https://repo1.maven.org/maven2/org/ow2/asm/asm-commons/5.0.3/asm-commons-5.0.3.pom
	https://repo1.maven.org/maven2/org/ow2/asm/asm-parent/5.0.3/asm-parent-5.0.3.pom
	https://repo1.maven.org/maven2/org/ow2/asm/asm-tree/5.0.3/asm-tree-5.0.3.jar
	https://repo1.maven.org/maven2/org/ow2/asm/asm-tree/5.0.3/asm-tree-5.0.3.pom
	https://repo1.maven.org/maven2/org/ow2/asm/asm-util/5.0.3/asm-util-5.0.3.jar
	https://repo1.maven.org/maven2/org/ow2/asm/asm-util/5.0.3/asm-util-5.0.3.pom
	https://repo1.maven.org/maven2/org/ow2/ow2/1.3/ow2-1.3.pom
	https://repo1.maven.org/maven2/org/sonatype/oss/oss-parent/4/oss-parent-4.pom
	https://repo1.maven.org/maven2/org/w3c/css/sac/1.3/sac-1.3.jar
	https://repo1.maven.org/maven2/org/w3c/css/sac/1.3/sac-1.3.pom
	https://repo1.maven.org/maven2/tapestry/tapestry/4.0.2/tapestry-4.0.2.jar
	https://repo1.maven.org/maven2/tapestry/tapestry/4.0.2/tapestry-4.0.2.pom
	https://repo1.maven.org/maven2/xalan/serializer/2.7.2/serializer-2.7.2.jar
	https://repo1.maven.org/maven2/xalan/serializer/2.7.2/serializer-2.7.2.pom
	https://repo1.maven.org/maven2/xalan/xalan/2.7.2/xalan-2.7.2.jar
	https://repo1.maven.org/maven2/xalan/xalan/2.7.2/xalan-2.7.2.pom
	https://repo1.maven.org/maven2/xerces/xercesImpl/2.11.0/xercesImpl-2.11.0.jar
	https://repo1.maven.org/maven2/xerces/xercesImpl/2.11.0/xercesImpl-2.11.0.pom
	https://repo1.maven.org/maven2/xml-apis/xml-apis/1.3.04/xml-apis-1.3.04.jar
	https://repo1.maven.org/maven2/xml-apis/xml-apis/1.3.04/xml-apis-1.3.04.pom
	https://repo1.maven.org/maven2/xml-apis/xml-apis/1.4.01/xml-apis-1.4.01.jar
	https://repo1.maven.org/maven2/xml-apis/xml-apis/1.4.01/xml-apis-1.4.01.pom
"

LICENSE="Geogebra CC-BY-NC-SA-3.0 GPL-3 Apache-2.0 BSD-2 BSD BSD-4 colt EPL-1.0 icu LGPL-2.1 LGPL-2.1+ MIT W3C || ( GPL-2 CDDL )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="bindist"
DEPEND="dev-java/oracle-jdk-bin[javafx]
	>=dev-java/gradle-bin-3.0"
# Requires oracle-jdk/jre-bin because there is no openjfx ebuild as of now
RDEPEND="|| (
		dev-java/oracle-jre-bin[javafx]
		dev-java/oracle-jdk-bin[javafx]
	)"

S="${WORKDIR}/${PN}-${MY_COMMIT_HASH}/"

# Override the repositories with our local maven repository
# so that it doesn't attemp to fetch from the network
__set_gradle_repositories() {
	cat > "${S}/gradle-scripts/repositories.gradle" <<-EOF || die
	allprojects {
		buildscript {
			repositories {
				maven { url "${1}" }
			}
		}

		repositories {
			maven { url "${1}" }
		}
	}
EOF
}

# Create a maven repository layout and
# populate using the required pom and jar files
__create_maven_repository() {
	local maven_basedir="${1}"
	local f
	local d
	local s

	mkdir -p "${maven_basedir}" || die
	for s in ${SRC_URI}; do
		# This regex is very specific for SRC_URI instead of a generic URI regex
		if [[ ${s} =~ (http|https)://[a-zA-Z0-9.-_]*/(maven2|m2)/(.*[.]jar|.*[.]pom)$ ]]; then
			f=$(basename "${BASH_REMATCH[-1]}")
			d=$(dirname "${BASH_REMATCH[-1]}")

			mkdir -p "${maven_basedir}"/"${d}" || die
			cp "${DISTDIR}/${f}" "${maven_basedir}/${d}/" || die
		fi
	done
}

src_unpack() {
	local maven_basedir="${T}/m2"

	unpack "${P}.tar.gz"

	__create_maven_repository "${maven_basedir}"
	__set_gradle_repositories "${maven_basedir}"
}

src_compile() {
	local gradle_home="${T}/.gradle"

	gradle -g "${gradle_home}" --no-daemon --offline \
		   :desktop:installDist || die "Gradle build has failed."
}

src_install() {
	local destdir="/opt/${PN}"

	insinto "${destdir}"
	doins -r desktop/build/install/desktop/lib/

	exeinto "${destdir}"/bin
	doexe desktop/build/install/desktop/bin/desktop
	dosym "${destdir}"/bin/desktop /usr/bin/geogebra

	make_desktop_entry geogebra Geogebra "geogebra" Science
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
