# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/liblockfile/liblockfile-1.09.ebuild,v 1.17 2014/08/01 18:27:25 tgall Exp $

EAPI=4

inherit eutils multilib autotools user

DESCRIPTION="Implements functions designed to lock the standard mailboxes"
HOMEPAGE="http://www.debian.org/"
SRC_URI="mirror://debian/pool/main/libl/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

pkg_setup() {
	enewgroup mail 12
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.06-respectflags.patch
	epatch "${FILESDIR}"/${PN}-orphan-file.patch

	# I don't feel like making the Makefile portable
	[[ ${CHOST} == *-darwin* ]] \
		&& cp "${FILESDIR}"/Makefile.Darwin.in Makefile.in

	eautoreconf
}

src_configure() {
	local grp=mail
	if use prefix ; then
		# we never want to use LDCONFIG
		export LDCONFIG=${EPREFIX}/bin/true
		# in unprivileged installs this is "mail"
		grp=$(id -g)
	fi
	econf --with-mailgroup=${grp} --enable-shared
}

src_install() {
	dodir /usr/{bin,include,$(get_libdir)} /usr/share/man/{man1,man3}
	emake ROOT="${D}" install
	dodoc README Changelog
}
