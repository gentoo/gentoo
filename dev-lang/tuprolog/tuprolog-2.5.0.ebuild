# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="tuProlog is a light-weight Prolog for Internet applications and infrastructures"
HOMEPAGE="http://www.alice.unibo.it/tuProlog/"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND=">=virtual/jdk-1.5
	>=dev-java/javassist-3"

DEPEND="${RDEPEND}
	app-arch/unzip
	dev-java/ant-core
	test? ( dev-java/ant-junit )"

S="${WORKDIR}"/${P}

EANT_GENTOO_CLASSPATH="javassist-3"

src_prepare() {
	epatch "${FILESDIR}"/${P}-javadocs.patch

	cp "${FILESDIR}"/build.xml "${S}" || die
	sed -i -e "s|test/unit|test|" "${S}"/build.xml \
		|| die "sed build.xml failed"
}

src_compile() {
	eant jar $(use_doc)
}

src_test() {
	cd "${S}"/dist
	java-pkg_jar-from junit
	cd "${S}"
	ANT_TASKS="ant-junit" eant test || die "eant test failed"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	if use doc ; then
		java-pkg_dohtml -r docs/* || die
	fi
}
