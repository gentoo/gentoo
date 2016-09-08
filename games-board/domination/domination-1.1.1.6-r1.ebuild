# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="The well-known board game, written in java"
HOMEPAGE="http://domination.sourceforge.net"
SRC_URI="mirror://sourceforge/domination/Domination_${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

S=${WORKDIR}/Domination

EANT_BUILD_TARGET="game"

pkg_setup() {
	java-pkg-2_pkg_setup
}

src_compile() {
	java-pkg-2_src_compile
}

src_install() {
	newbin "${S}"/FlashGUI.sh ${PN}
	sed -i \
		-e "s|cd.*|cd \"/usr/share\"/${PN}|" \
		"${D}/usr/bin"/${PN} \
		|| die
	chmod +x "${D}/usr/bin"/${PN} || die

	insinto "/usr/share/${PN}"
	doins -r "${S}"/*
	rm -f "${D}/usr/share"/${PN}/*.cmd || die
	java-pkg_regjar "${D}//usr/share/${PN}"/*.jar

	newicon resources/icon.png ${PN}.png
	make_desktop_entry ${PN} "Domination"
}
