# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 java-utils-2 eutils

DESCRIPTION="Jakarta-Commons Collections Component"
HOMEPAGE="http://commons.apache.org/collections/"
SRC_URI="mirror://apache/${PN/-//}/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="test-framework"

CDEPEND="
	test-framework? (
		dev-java/junit:0
		dev-java/ant-junit:0
	)
	"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

S="${WORKDIR}/${P}-src"

java_prepare() {
	# Check for VM version.
	java-pkg_is-vm-version-ge 1.8
	if [[ $? -eq 0 ]]; then
		einfo "You are running a JVM greater or equal than version 1.8."
		epatch "${FILESDIR}"/${P}-Java-8.patch
	fi
}

src_compile() {
	local antflags
	if use test-framework; then
		antflags="tf.jar -Djunit.jar=$(java-pkg_getjars junit)"
		#no support for installing two sets of javadocs via dojavadoc atm
		#use doc && antflags="${antflags} tf.javadoc"
	fi
	eant jar $(use_doc) ${antflags}
}

src_test() {
	if [[ "${ARCH}" = "ppc" ]]; then
		einfo "Tests are disabled on ppc"
	else
		ANT_TASKS="ant-junit" eant testjar -Djunit.jar="$(java-pkg_getjars junit)"
	fi
}

src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar
	use test-framework && \
		java-pkg_newjar build/${PN}-testframework-${PV}.jar \
			${PN}-testframework.jar

	dodoc README.txt || die
	java-pkg_dohtml *.html || die
	if use doc; then
		java-pkg_dojavadoc build/docs/apidocs
		#use test-framework && java-pkg_dojavadoc build/docs/testframework
	fi
	use source && java-pkg_dosrc src/java/*
}
