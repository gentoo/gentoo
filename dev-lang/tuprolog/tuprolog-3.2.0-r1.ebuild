# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2 java-ant-2

PATCHSET_VER="0"

DESCRIPTION="tuProlog is a light-weight Prolog for Internet applications and infrastructures"
HOMEPAGE="http://tuprolog.unibo.it/"
SRC_URI="https://dev.gentoo.org/~keri/distfiles/tuprolog/${P}.tar.gz
	https://dev.gentoo.org/~keri/distfiles/tuprolog/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="LGPL-3 BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/jdk:1.8
	dev-java/javassist:3
	dev-java/commons-lang:3.6
	dev-java/gson:2.6"

DEPEND="${RDEPEND}
	>=dev-java/ant-1.10.14
	test? (
		>=dev-java/ant-1.10.14:0[junit4]
		dev-java/junit:4
		dev-java/hamcrest:0
	)"

S="${WORKDIR}"/${P}

EANT_GENTOO_CLASSPATH="javassist:3,commons-lang:3.6,gson:2.6"

PATCHES=( "${WORKDIR}/${PV}" )

src_prepare() {
	default

	cp "${FILESDIR}"/build-3.x.xml "${S}"/build.xml || die
}

src_compile() {
	eant jar $(use_doc)
}

src_test() {
	cd "${S}"/dist
	java-pkg_jar-from junit:4
	java-pkg_jar-from hamcrest
	cd "${S}"
	eant test || die "eant test failed"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_dojar dist/2p.jar

	if use doc ; then
		java-pkg_dohtml -r docs/* || die
		dodoc doc/tuprolog-guide.pdf
	fi

	if use examples ; then
		docinto examples
		dodoc doc/examples/*.pl
	fi
}
