# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin

DESCRIPTION="A plugin for GKrellM2 that has a VU meter and a sound chart"
HOMEPAGE="http://members.dslextreme.com/users/billw/gkrellmss/gkrellmss.html"
SRC_URI="http://web.wt.net/~billw/gkrellmss/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"
IUSE="nls"

RDEPEND="app-admin/gkrellm:2[X]
	media-libs/alsa-lib
	sci-libs/fftw:3.0="
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-Respect-LDFLAGS.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-r5-configure-makefile-fixes.patch
)

PLUGIN_DOCS=( Themes )

src_compile() {
	tc-export PKG_CONFIG
	PLUGIN_SO=( src/gkrellmss$(get_modname) )
	addpredict /dev/snd
	emake CC="$(tc-getCC)" enable_nls=$(usex nls 1 0) without-esd=yes
}
