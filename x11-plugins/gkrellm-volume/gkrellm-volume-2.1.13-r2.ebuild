# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A mixer control plugin for gkrellm"
HOMEPAGE="http://gkrellm.luon.net/volume.php"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"
IUSE="alsa"

RDEPEND="
	app-admin/gkrellm:2[X]
	alsa? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}
PATCHES=(
	"${FILESDIR}/${P}-reenable.patch"
	"${FILESDIR}/${P}-makefile.patch"
)

PLUGIN_SO=( volume$(get_modname) )

src_compile() {
	use alsa && local myconf="enable_alsa=1"
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" ${myconf}
}
