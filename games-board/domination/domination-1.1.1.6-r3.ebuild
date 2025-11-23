# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2

DESCRIPTION="The well-known board game, written in java"
HOMEPAGE="https://domination.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/project/domination/Domination/${PV}/Domination_${PV}.zip"
S="${WORKDIR}"/Domination

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.8:*"

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
