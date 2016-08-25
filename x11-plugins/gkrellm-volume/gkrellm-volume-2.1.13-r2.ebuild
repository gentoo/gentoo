# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A mixer control plugin for gkrellm"
HOMEPAGE="http://gkrellm.luon.net/volume.php"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"
IUSE="alsa"

DEPEND="alsa? ( media-libs/alsa-lib )"
RDEPEND="${DEPEND}
	app-admin/gkrellm[X]
"

S="${WORKDIR}/${PN}"

PLUGIN_SO="volume.so"

PATCHES=(
	"${FILESDIR}/${P}-reenable.patch"
	"${FILESDIR}/${P}-makefile.patch"
)

src_compile() {
	local myconf=""
	use alsa && myconf="${myconf} enable_alsa=1"
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" "${myconf}"
}
