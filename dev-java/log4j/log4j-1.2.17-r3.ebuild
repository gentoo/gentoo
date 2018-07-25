# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A low-overhead robust logging package for Java"
SRC_URI="mirror://apache/logging/${PN}/${PV}/${P}.tar.gz"
HOMEPAGE="http://logging.apache.org/log4j/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86 ~amd64-linux"
IUSE="javamail jms"

CDEPEND="
	javamail? ( dev-java/oracle-javamail:0 )
	jms? ( java-virtuals/jms:0 )"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

MY_P="apache-${P}"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	java-pkg_clean
}

JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"
EANT_BUILD_TARGET="log4j.jar"
EANT_EXTRA_ARGS="-Djaxp-present=true -Djmx-present=true"
EANT_DOC_TARGET=""

src_compile() {
	if use javamail; then
		EANT_GENTOO_CLASSPATH+="oracle-javamail"
		EANT_EXTRA_ARGS+=" -Djavamail-present=true"
	fi

	if use jms; then
		EANT_EXTRA_ARGS+=" -Djms-present=true -Djms.jar=$(java-pkg_getjars jms)"
	fi

	java-pkg-2_src_compile
}

src_install() {
	java-pkg_newjar dist/lib/${PN}-1.2.17.jar ${PN}.jar

	if use doc; then
		java-pkg_dohtml -r site/*
		rm -fr "${ED}/usr/share/doc/${PF}/html/apidocs"
		java-pkg_dojavadoc --symlink apidocs site/apidocs
	fi

	if use source; then
		java-pkg_dosrc src/main/java/*
	fi
}
