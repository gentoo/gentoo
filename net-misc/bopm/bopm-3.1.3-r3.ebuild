# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools user

DESCRIPTION="Blitzed Open Proxy Monitor"
HOMEPAGE="http://github.com/blitzed-org/bopm"
SRC_URI="http://static.blitzed.org/www.blitzed.org/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-remove-njabl.patch
	"${FILESDIR}"/${P}-autotools.patch
)

pkg_setup() {
	enewuser bopm
}

src_prepare() {
	sed -i \
		-e "s!/some/path/bopm.pid!/run/${PN}/${PN}.pid!" \
		-e "s!/some/path/scan.log!/var/log/${PN}/scan.log!" \
		bopm.conf.sample || die

	mv configure.{in,ac} || die
	mv src/libopm/configure.{in,ac} || die

	default
	cp bopm.conf{.sample,} || die

	eautoreconf
}

src_configure() {
	econf --localstatedir="${EPREFIX}"/var/log/${PN}
}

src_install() {
	default

	# Remove libopm related files, because bopm links statically to it
	# If anybody wants libopm, please install net-libs/libopm
	rm -r "${ED}"usr/$(get_libdir) "${ED}"usr/include || die

	newinitd "${FILESDIR}"/bopm.init.d-r1 ${PN}
	newconfd "${FILESDIR}"/bopm.conf.d-r1 ${PN}

	dodir /var/log/bopm
	fperms 700 /var/log/bopm
	fowners bopm:root /var/log/bopm

	fperms 600 /etc/bopm.conf
	fowners bopm:root /etc/bopm.conf
}
