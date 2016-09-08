# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A minimalistic GKrellM2 plugin to control radio tuners"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/gkrellm-radio.php"

DEPEND="lirc? ( app-misc/lirc )"
RDEPEND="${DEPEND}
	app-admin/gkrellm[X]
"

IUSE="lirc"
SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc sparc x86"

PLUGIN_SO="radio.so"
S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_compile() {
	use lirc && myconf="${myconf} WITH_LIRC=1"
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" ${myconf}
}
