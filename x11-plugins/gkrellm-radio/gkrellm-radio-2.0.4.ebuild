# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A minimalistic GKrellM2 plugin to control radio tuners"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/gkrellm-radio.php"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ppc sparc x86"
IUSE="lirc"

RDEPEND="
	app-admin/gkrellm:2[X]
	lirc? ( app-misc/lirc )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}
PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

PLUGIN_SO=( radio$(get_modname) )

src_compile() {
	use lirc && myconf="${myconf} WITH_LIRC=1"
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" ${myconf}
}
