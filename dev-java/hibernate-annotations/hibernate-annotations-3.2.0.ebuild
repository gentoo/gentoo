# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/hibernate-annotations/hibernate-annotations-3.2.0.ebuild,v 1.1 2013/10/24 20:47:16 tomwij Exp $

EAPI="5"

inherit java-pkg-2 java-ant-2

MY_PV="${PV}.GA"
MY_P="${PN}-${MY_PV}"
HIBERNATE_P="hibernate-3.2.0.ga"

DESCRIPTION="Annotations support for Hibernate"
HOMEPAGE="http://annotations.hibernate.org"
SRC_URI="mirror://sourceforge/hibernate/${MY_P}.tar.gz mirror://sourceforge/hibernate/${HIBERNATE_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="3.2"
KEYWORDS="~amd64"

IUSE="doc source"

COMMON_DEPS="
	dev-java/commons-logging:0
	dev-java/dom4j:1
	dev-java/glassfish-persistence:0
	dev-java/hibernate:3.1
	dev-java/lucene:2.1"

DEPEND=">=virtual/jdk-1.5
	app-arch/zip:0
	dev-java/ant-antlr:0
	dev-java/ant-junit:0
	dev-java/commons-collections:0
	${COMMON_DEPS}
	"
RDEPEND=">=virtual/jre-1.5
	dev-java/lucene:1
	${COMMON_DEPS}
	"

S="${WORKDIR}/${MY_P}"
HIBERNATE_S="${WORKDIR}/hibernate-${SLOT}"

java_prepare() {
	cd "${HIBERNATE_S}"/lib || die

	java-pkg_jar-from --build-only ant-antlr,commons-collections
	java-pkg_jar-from --build-only ant-core ant.jar

	java-pkg_jar-from commons-logging,dom4j-1,glassfish-persistence,hibernate-3.1,lucene-2.1
}

src_install() {
	java-pkg_dojar ${PN}.jar

	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/*
}
