# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="a GKrellM2 plugin which displays the top three processes"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.orig.tar.gz"
HOMEPAGE="https://sourceforge.net/projects/gkrelltop"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X"

RDEPEND="
	app-admin/gkrellm:2[X]
	dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}.orig
PATCHES=( "${FILESDIR}"/${PN}-2.2.13-fix-build-system.patch )

PLUGIN_SERVER_SO=( gkrelltopd$(get_modname) )
PLUGIN_SO=( gkrelltop$(get_modname) )

src_configure() {
	tc-export CC
}

src_compile() {
	use X || local target="server"
	emake ${target}
}

pkg_postinst() {
	einfo "To enable the gkrelltopd server plugin, you must add the following"
	einfo "line to /etc/gkrellmd.conf:"
	einfo "\tplugin-enable gkrelltopd"
}
