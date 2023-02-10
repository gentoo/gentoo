# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gkrellm-plugin multilib toolchain-funcs

DESCRIPTION="a GKrellM2 plugin which displays the top three processes"
HOMEPAGE="https://sourceforge.net/projects/gkrelltop"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.orig.tar.gz"
S="${WORKDIR}/${P}.orig"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="X"

RDEPEND="
	app-admin/gkrellm:2[X]
	dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.13-fix-build-system.patch
	"${FILESDIR}"/${PN}-2.2.13-r3-pkgconfig.patch
)

src_configure() {
	tc-export CC PKG_CONFIG

	PLUGIN_SERVER_SO=( gkrelltopd$(get_modname) )
	PLUGIN_SO=( gkrelltop$(get_modname) )

	default
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
