# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/mojarra/mojarra-1.2.15-r2.ebuild,v 1.3 2011/02/10 19:33:37 tomka Exp $

EAPI=3

WANT_ANT_TASKS="ant-trax"
JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

MY_PV="$(get_version_component_range 1-2)_$(get_version_component_range 3)-b01-FCS"

DESCRIPTION="Project Mojarra - GlassFish's Implementation for JavaServer Faces API"
HOMEPAGE="https://javaserverfaces.dev.java.net/"
SRC_URI="https://javaserverfaces.dev.java.net/files/documents/1866/151669/${PN}-${MY_PV}-source.zip
	mirror://gentoo/${PN}-${MY_PV}-patch.bz2"

LICENSE="CDDL"
SLOT="1.2"
KEYWORDS="amd64 x86"

IUSE=""

COMMON_DEP="
	dev-java/glassfish-servlet-api:2.5
	dev-java/groovy:0
	dev-java/jakarta-jstl:0
	dev-java/portletapi:1
	"

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	dev-java/ant-contrib
	dev-java/commons-beanutils:1.7
	dev-java/commons-collections:0
	dev-java/commons-digester:0
	dev-java/commons-logging:0
	${COMMON_DEP}"

S="${WORKDIR}/${PN}-${MY_PV}-sources"

src_prepare() {
	epatch "${DISTDIR}/${PN}-${MY_PV}-patch.bz2"

	mkdir -p "${S}/dependencies/jars" || die

	# Should we remove those files? I don't see a reason to pull in three
	# different web app server for this package.
	rm -f \
		"${S}/jsf-ri/src/com/sun/faces/vendor/GlassFishInjectionProvider.java" \
		"${S}/jsf-ri/src/com/sun/faces/vendor/Jetty6InjectionProvider.java" \
		"${S}/jsf-ri/src/com/sun/faces/vendor/Tomcat6InjectionProvider.java"

	find -name '*.jar' -exec rm -f {} \;

	cd "${S}/common/lib/"
	java-pkg_jarfrom --build-only ant-contrib

	cd "${S}/dependencies/jars"
	java-pkg_jarfrom --build-only commons-beanutils-1.7
	java-pkg_jarfrom --build-only commons-collections
	java-pkg_jarfrom --build-only commons-digester
	java-pkg_jarfrom --build-only commons-logging
	java-pkg_jarfrom glassfish-servlet-api-2.5
	java-pkg_jarfrom groovy
	java-pkg_jarfrom jakarta-jstl
	java-pkg_jarfrom portletapi-1
}

src_compile() {
	cd "${S}/jsf-api"
	eant -Djsf.build.home="${S}" -Dcontainer.name=glassfish jars

	cd "${S}/jsf-ri"
	eant -Djsf.build.home="${S}" -Dcontainer.name=glassfish jars
}

src_install() {
	java-pkg_dojar "${S}/jsf-api/build/lib/jsf-api.jar"
	java-pkg_dojar "${S}/jsf-ri/build/lib/jsf-impl.jar"
	use source && java-pkg_dosrc "${S}"/jsf-api/src/* "${S}"/jsf-ri/src/*
}
