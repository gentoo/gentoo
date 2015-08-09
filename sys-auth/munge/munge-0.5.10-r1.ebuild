# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit user

DESCRIPTION="An authentication service for creating and validating credentials"
HOMEPAGE="http://code.google.com/p/munge/"
SRC_URI="http://munge.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="gcrypt"

DEPEND="app-arch/bzip2
	sys-libs/zlib
	gcrypt? ( dev-libs/libgcrypt:0 )
	!gcrypt? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup munge
	enewuser munge -1 -1 /var/lib/munge munge
}

src_configure() {
	local conf=""

	if use gcrypt; then
		conf="${conf} --with-crypto-lib=libgcrypt"
	else
		conf="${conf} --with-crypto-lib=openssl"
	fi

	econf ${conf} \
		--localstatedir=/var
}

src_install() {
	emake DESTDIR="${D}" install || die

	# 450830
	if [ -d "${D}"/var/run ]; then
		rm -rf "${D}"/var/run || die
	fi

	diropts -o munge -g munge -m700
	dodir /etc/munge || die

	[ -d "${D}"/etc/init.d ] && rm -r "${D}"/etc/init.d
	[ -d "${D}"/etc/default ] && rm -r "${D}"/etc/default
	[ -d "${D}"/etc/sysconfig ] && rm -r "${D}"/etc/sysconfig

	newconfd "${FILESDIR}"/${PN}d.confd ${PN}d || die
	newinitd "${FILESDIR}"/${PN}d.initd ${PN}d || die
}

src_test() {
	emake check || die
}
