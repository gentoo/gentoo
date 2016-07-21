# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils fixheadtails flag-o-matic prefix toolchain-funcs user

DESCRIPTION="ChanServ, NickServ, and MemoServ with support for several IRC daemons"
HOMEPAGE="http://achurch.org/services/"
SRC_URI="http://achurch.org/services/tarballs/${P}.tar.gz"
LICENSE="GPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

pkg_setup() {
	enewgroup ircservices
	enewuser ircservices -1 -1 -1 ircservices

	# this is needed, because old ebuilds added the user with ircservices:users
	usermod -g ircservices ircservices
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.1.17-fPIC.patch \
		"${FILESDIR}"/${PN}-5.1.17-fPIC-configure.patch \
		"${FILESDIR}"/${P}-ircservices-chk-pidfile.patch \
		"${FILESDIR}"/${P}-parallel-make.patch \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-fd_set-amd64.patch

	ht_fix_file configure
	sed -i \
		-e "s/-m 750/-m 755/" \
		-e "s/-m 640/-m 644/" \
		configure || die

	sed -i -e "s;ircservices.pid;${EPREFIX}/var/run/ircservices/&;g" data/example-ircservices.conf || die
}

src_configure() {
	append-flags -fno-stack-protector
	# configure fails with -O higher than 2
	replace-flags "-O[3-9s]" "-O2"

	RUNGROUP="ircservices" \
	./configure \
		-cc "$(tc-getCC)" \
		-cflags "${CFLAGS}" \
		-lflags "${LDFLAGS}" \
		-bindest /usr/bin \
		-datdest /var/lib/ircservices \
		|| die "./configure failed"
}

src_install() {
	dodir /usr/bin /{etc,usr/{$(get_libdir),share},var/lib}/ircservices
	keepdir /var/log/ircservices

	emake \
		BINDEST="${D}"/usr/bin \
		DATDEST="${D}"/var/lib/ircservices \
		install

	mv "${D}"/var/lib/ircservices/convert-db "${D}"/usr/bin/ircservices-convert-db || die "mv failed"

	# Now we move some files around to make it FHS conform
	mv "${D}"/var/lib/ircservices/example-ircservices.conf "${D}"/etc/ircservices/ircservices.conf || die "mv failed"
	dosym /etc/ircservices/ircservices.conf /var/lib/ircservices/ircservices.conf

	mv "${D}"/var/lib/ircservices/example-modules.conf "${D}"/etc/ircservices/modules.conf || die "mv failed"
	dosym /etc/ircservices/modules.conf /var/lib/ircservices/modules.conf

	mv "${D}"/var/lib/ircservices/modules "${D}"/usr/$(get_libdir)/ircservices || die "mv failed"
	dosym /usr/$(get_libdir)/ircservices/modules /var/lib/ircservices/modules

	mv "${D}"/var/lib/ircservices/{helpfiles,languages} "${D}"/usr/share/ircservices  || die "mv failed"
	dosym /usr/share/ircservices/helpfiles /var/lib/ircservices/helpfiles
	dosym /usr/share/ircservices/languages /var/lib/ircservices/languages

	fperms 750 /var/{lib,log}/ircservices /etc/ircservices
	fperms 640 /etc/ircservices/{ircservices,modules}.conf
	fowners ircservices:ircservices /var/{lib,log}/ircservices
	fowners root:ircservices /etc/ircservices{,/{ircservices,modules}.conf}

	newinitd "${FILESDIR}"/ircservices.initd ircservices
	newconfd "${FILESDIR}"/ircservices.confd ircservices

	doman docs/ircservices*.8
	newman docs/convert-db.8 ircservices-convert-db.8

	dohtml -r docs/*
	dodoc docs/Changes* README docs/WhatsNew
}
