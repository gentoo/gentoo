# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A GKrellM2 plugin to control a fli4l router"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.bz2"
HOMEPAGE="http://gkrellm-imonc.sourceforge.net/"

# The COPYING file contains the GPLv2, but the file headers say GPLv2+.
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-src-${PV}"

PATCHES=( "${FILESDIR}"/${PN}-makefile.patch )

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}
