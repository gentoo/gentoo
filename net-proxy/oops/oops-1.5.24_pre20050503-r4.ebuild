# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs autotools user

MY_P="${PN}-1.5.23"

DESCRIPTION="An advanced multithreaded caching web proxy"
HOMEPAGE="http://zipper.paco.net/~igor/oops.eng/"
SRC_URI="http://zipper.paco.net/~igor/oops/${MY_P}.tar.gz
	mirror://gentoo/${P}.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE=""

RDEPEND="dev-libs/libpcre
	>=sys-libs/db-3"
DEPEND="${RDEPEND}
	sys-devel/flex"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup oops
	enewuser oops -1 -1 /var/lib/oops oops
}

src_prepare() {
	epatch "${WORKDIR}/${P}.patch"
	epatch "${FILESDIR}/${P/_*}-textrel.patch"
	epatch "${FILESDIR}/${P/_*}-pthread-rwlock.patch"
	epatch "${FILESDIR}/modules-as-needed.patch"
	epatch "${FILESDIR}/implicit-decl.patch"
	epatch "${FILESDIR}/libpcreposix.patch"
	epatch "${FILESDIR}/rotate-logs.patch"
	epatch "${FILESDIR}/${P}+db-5.0.patch"
	sed -i -e 's:y\.tab\.h:y.tab.c:' src/Makefile.in
	eautoreconf
}

src_configure() {
	econf \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir)/oops \
		--enable-oops-user=oops \
		--sysconfdir=/etc/oops \
		--sbindir=/usr/sbin \
		--with-regexp=pcre \
		--localstatedir=/var/run/oops \
		--enable-large-files \
		--with-zlib=-lz \
		|| die "configure problem"

	sed -i -e '/STRERROR_R/d' src/config.h.in
	sed -i \
		-e "s|OOPS_LIBDIR = /usr/$(get_libdir)/oops|OOPS_LIBDIR = ${D}/usr/$(get_libdir)/oops|" \
		-e "s|OOPS_SBINDIR = /usr/sbin|OOPS_SBINDIR = ${D}/usr/sbin|" \
		-e "s|OOPS_SYSCONFDIR = /etc/oops|OOPS_SYSCONFDIR = ${D}/etc/oops|" \
		-e "s|OOPS_LOCALSTATEDIR = /var/run/oops|OOPS_LOCALSTATEDIR = ${D}/var/run/oops|" \
		-e "s|OOPSPATH=/usr/oops|OOPSPATH=${D}/usr/oops|" \
		src/Makefile
	sed -i \
		-e "s|^\(LDFLAGS *= *\)${LDFLAGS}|\1$(raw-ldflags)|" \
		src/modules/Makefile #modules makefile use ld directly
}

src_install() {
	dodir /usr/sbin
	einstall || die "install problem"

	newinitd "${FILESDIR}/oops.initd" oops
	diropts -m0750 -o root -g oops
	dodir /etc/oops
	insinto /etc/oops
	doins "${FILESDIR}/oops.cfg"

	diropts -m0755 -o oops -g oops
	keepdir /var/run/oops
	diropts -m0770 -o oops -g oops
	keepdir /var/log/oops
	keepdir /var/lib/oops/storage
	keepdir /var/lib/oops/db

	# cleanups
	rm -rf "${D}/usr/oops"
	rm -rf "${D}/usr/lib/oops/modules"
}

pkg_postinst() {
	#Set proper owner/group if installed from binary package
	chgrp oops "${ROOT}/etc/oops"
	chown -R oops:oops "${ROOT}/var/run/oops" "${ROOT}/var/log/oops" "${ROOT}/var/lib/oops"
}
