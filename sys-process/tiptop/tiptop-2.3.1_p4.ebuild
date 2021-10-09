# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="top for performance counters"
HOMEPAGE="http://tiptop.gforge.inria.fr/"
SRC_URI="http://${PN}.gforge.inria.fr/releases/${PN}-$(ver_cut 1-3).tar.gz"
SRC_URI+=" http://deb.debian.org/debian/pool/main/t/tiptop/tiptop_${PV/_p/-}.debian.tar.xz"
S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sys-libs/ncurses:=
	dev-libs/libxml2:2
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.1-tinfo.patch #618124
	"${WORKDIR}"/debian/patches
)

src_prepare() {
	default
	eautoreconf #618124
}
