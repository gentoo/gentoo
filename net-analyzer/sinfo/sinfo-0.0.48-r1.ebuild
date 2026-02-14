# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Monitoring tool for networked computers"
HOMEPAGE="https://www.ant.uni-bremen.de/staff/"
SRC_URI="https://www.ant.uni-bremen.de/whomes/rinas/sinfo/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="ipv6"

DEPEND="
	dev-libs/boost
	sys-libs/ncurses:=
"
RDEPEND="${DEPEND}
	!sys-cluster/slurm
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.0.47-tinfo.patch
	"${FILESDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-boost-1.89.patch # bug #963408
)

DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	default

	cp "${FILESDIR}"/${P}-acinclude.m4 acinclude.m4 || die
	eautoreconf
}

src_configure() {
	econf $(use_enable ipv6 IPv6)
}

src_install() {
	default

	newconfd "${FILESDIR}"/sinfod.confd sinfod
	newinitd "${FILESDIR}"/sinfod.initd sinfod
}
