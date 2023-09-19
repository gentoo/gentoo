# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin multilib toolchain-funcs

DESCRIPTION="A mixer control plugin for gkrellm"
HOMEPAGE="http://gkrellm.luon.net/volume.php"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"
IUSE="alsa"

RDEPEND="
	app-admin/gkrellm:2[X]
	alsa? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-reenable.patch"
	"${FILESDIR}/${P}-makefile.patch"
	"${FILESDIR}/${P}-r3-pkgconfig.patch"
)

src_configure() {
	PLUGIN_SO=( volume$(get_modname) )
	default
}

src_compile() {
	tc-export PKG_CONFIG
	use alsa && local myconf="enable_alsa=1"
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" ${myconf}
}
