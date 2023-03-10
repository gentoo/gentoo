# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="${PN}-r0"
DESCRIPTION="Standalone JACK counterpart of LADSPA plugin TAP Reverberator"
HOMEPAGE="http://tap-plugins.sourceforge.net/reverbed.html"
SRC_URI="mirror://sourceforge/tap-plugins/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	media-libs/ladspa-sdk
	media-plugins/tap-plugins
	virtual/jack
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-flags.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default
	eautoreconf
}

pkg_postinst() {
	elog "TAP Reverb Editor expects the configuration file '.reverbed'"
	elog "to be in the user's home directory.	The default '.reverbed'"
	elog "file can be found in the /usr/share/tap-reverbed directory"
	elog "and should be manually copied to the user's directory."
}
