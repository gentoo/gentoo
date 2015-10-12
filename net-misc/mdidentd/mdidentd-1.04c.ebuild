# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils user

DESCRIPTION="This is an identd with provides registering of idents"
HOMEPAGE="http://druglord.freelsd.org/ezbounce/"
SRC_URI="http://druglord.freelsd.org/ezbounce/files/ezbounce-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/ezbounce-${PV}

pkg_setup() {
	enewgroup mdidentd
	enewuser mdidentd -1 -1 /dev/null mdidentd
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/1.04a-security.patch
	epatch "${FILESDIR}"/1.04a-pidfile.patch
	epatch "${FILESDIR}"/1.04a-glibc210.patch
}

src_compile() {
	econf $(use_with ssl) || die
	emake CXX="$(tc-getCXX)" -C mdidentd CXX_OPTIMIZATIONS="${CXXFLAGS}" || die
}

src_install() {
	dosbin mdidentd/mdidentd || die
	dodoc mdidentd/README

	newinitd "${FILESDIR}"/mdidentd.init.d mdidentd
	newconfd "${FILESDIR}"/mdidentd.conf.d mdidentd
}
