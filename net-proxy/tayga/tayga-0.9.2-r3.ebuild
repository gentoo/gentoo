# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="out-of-kernel stateless NAT64 implementation based on TUN"
HOMEPAGE="http://www.litech.org/tayga/"
SRC_URI="http://www.litech.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-static-EAM.patch
	"${FILESDIR}"/${P}-manpage-RFC.patch
	"${FILESDIR}"/${P}-release-reserved-addr.patch
)

src_prepare() {
	default
	sed -e '/^CFLAGS/d' \
		-i configure.ac || die "sed failed"
	eautoreconf
}

src_install() {
	default
	newconfd "${FILESDIR}"/tayga.confd ${PN}
	newinitd "${FILESDIR}"/tayga.initd ${PN}
}
