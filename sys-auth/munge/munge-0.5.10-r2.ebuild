# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit user

DESCRIPTION="An authentication service for creating and validating credentials"
HOMEPAGE="https://code.google.com/p/munge/"
SRC_URI="https://munge.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="gcrypt"

DEPEND="
	app-arch/bzip2
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
	emake DESTDIR="${D}" install

	# 450830
	if [ -d "${D}"/var/run ]; then
		rm -rf "${D}"/var/run || die
	fi

	dodir /etc/munge

	[ -d "${D}"/etc/init.d ] && rm -r "${D}"/etc/init.d
	[ -d "${D}"/etc/default ] && rm -r "${D}"/etc/default
	[ -d "${D}"/etc/sysconfig ] && rm -r "${D}"/etc/sysconfig

	newconfd "${FILESDIR}"/${PN}d.confd ${PN}d
	newinitd "${FILESDIR}"/${PN}d.initd ${PN}d
}

src_test() {
	emake check
}
