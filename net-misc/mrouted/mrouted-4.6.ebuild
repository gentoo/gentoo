# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs systemd

DESCRIPTION="IP multicast routing daemon"
HOMEPAGE="https://troglobit.com/projects/mrouted/"
SRC_URI="https://github.com/troglobit/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="Stanford GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
# Needs unshare
RESTRICT="!test? ( test ) test"

BDEPEND="
	app-alternatives/yacc
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/mrouted-4.6-c23-compat.patch" #944046
)

src_configure() {
	tc-export CC CXX

	econf $(use_enable test)
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}

src_install() {
	default

	insinto /etc
	doins mrouted.conf

	newinitd "${FILESDIR}"/mrouted.rc mrouted
	systemd_dounit mrouted.service
}
