# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
JAVA_PKG_IUSE="source doc test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Zemberek NLP library"
HOMEPAGE="https://github.com/ahmetaa/zemberek-nlp"
SRC_URI="https://${PN}.googlecode.com/files/${P}-nolibs-src.zip"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~x86-fbsd"
LANGS="tr tk"

S=${WORKDIR}/${P}-nolibs-src

IUSE="l10n_tk +l10n_tr"

RDEPEND=">=virtual/jre-1.5"

DEPEND=">=virtual/jdk-1.5
	test?
	(
		dev-java/junit:4
		dev-java/ant-junit4
		dev-java/hamcrest-core
	)
	app-arch/unzip"

java_prepare() {
	use test && java-pkg_jarfrom --build-only --into lib/gelistirme junit-4 junit.jar
	# Added hamcrest-core as a workaround
	# Issue spotted by Markus Meier <maekke@gentoo.org>
	# See https://bugs.gentoo.org/show_bug.cgi?id=253753#c3
	use test && java-pkg_jarfrom --build-only --into lib/gelistirme hamcrest-core
	epatch "${FILESDIR}"/${P}-classpathfix.patch
}

src_compile() {
	local anttargs langs="" jar
	for jar in ${LANGS}; do
		use l10n_${jar} && langs+=" ${jar}"
	done
	for jar in cekirdek demo ${langs}; do
		anttargs="${anttargs} jar-${jar}"
	done
	eant ${anttargs} $(use_doc javadocs)
}

src_install() {
	local sourcetrees="" langs="" jar
	for jar in ${LANGS}; do
		use l10n_${jar} && langs+=" ${jar}"
	done
	for jar in cekirdek demo ${langs}; do
		java-pkg_newjar dagitim/jar/zemberek-${jar}-${PV}.jar zemberek2-${jar}.jar
		sourcetrees="${sourcetrees} src/${jar}/net"
	done
	use source && java-pkg_dosrc ${sourcetrees}
	use doc && java-pkg_dojavadoc build/java-docs/api
	java-pkg_dolauncher zemberek-demo --main net.zemberek.demo.DemoMain
	dodoc dokuman/lisanslar/* || die
	dodoc surumler.txt || die
}

src_test() {
	ANT_TASKS="ant-junit4" eant unit-test
}
