# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EANT_BUILD_TARGET="game"
inherit desktop java-pkg-2 java-ant-2

DESCRIPTION="The well-known board game, written in java"
HOMEPAGE="http://domination.sourceforge.net"
SRC_URI="mirror://sourceforge/domination/Domination_${PV}.zip"
S="${WORKDIR}"/Domination

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"
BDEPEND="app-arch/unzip"

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
		"${ED}"/usr/bin/${PN} \
		|| die
	chmod +x "${ED}"/usr/bin/${PN} || die

	insinto /usr/share/${PN}
	doins -r "${S}"/*
	rm -f "${ED}"/usr/share/${PN}/*.cmd || die
	java-pkg_regjar "${ED}"/usr/share/${PN}/*.jar

	newicon resources/icon.png ${PN}.png
	make_desktop_entry ${PN} "Domination"
}
