# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit autotools eutils user

DESCRIPTION="A speech server that allows emacspeak and other screen readers to interact with festival lite"
HOMEPAGE="http://eflite.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE="+16k_voice"

DEPEND=">=app-accessibility/flite-1.4"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i 's:/etc/es.conf:/etc/eflite/es.conf:g' *
	epatch "${FILESDIR}"/${PN}-0.4.1-flite14.patch
	eautoreconf
}

src_configure() {
	local myconf
	if use 16k_voice; then
		myconf='--with-vox=cmu_us_kal16'
	fi
	econf ${myconf}
}

src_install() {
	einstall
	dodoc ChangeLog README INSTALL eflite_test.txt

	insinto /etc/eflite
	doins "${FILESDIR}"/es.conf

	newinitd "${FILESDIR}"/eflite.rc eflite
}

pkg_postinst() {
	enewgroup speech
}
