# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit desktop java-pkg-2 java-ant-2

XDG_P="xdg-20100731"

MY_PN="BDSup2Sub"

DESCRIPTION="A tool to convert and tweak bitmap based subtitle streams"
HOMEPAGE="http://bdsup2sub.javaforge.com/help.htm"
SRC_URI="
	http://sbriesen.de/gentoo/distfiles/${P}.tar.xz
	http://sbriesen.de/gentoo/distfiles/${XDG_P}.java.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/jre-1.8:*"

DEPEND="
	>=virtual/jdk-1.8:*"

S="${WORKDIR}/${PN}/${PV}"

PATCHES=( "${FILESDIR}/${P}-xdg.patch" )

src_prepare() {
	default

	# apply XDG patch
	cp -v "${WORKDIR}/${XDG_P}.java" "${S}/src/xdg.java" || die

	# copy build.xml
	cp -f "${FILESDIR}/build-${PV}.xml" build.xml || die
}

src_compile() {
	eant build $(use_doc)
}

src_install() {
	java-pkg_dojar "dist/${MY_PN}.jar"
	java-pkg_dolauncher "${PN}" --main "${MY_PN}" --java_args -Xmx256m
	newicon bin_copy/icon_32.png "${MY_PN}.png"
	make_desktop_entry "${MY_PN}" "${MY_PN}" "${MY_PN}"
	use doc && java-pkg_dojavadoc apidocs
	use source && java-pkg_dosrc src
}
