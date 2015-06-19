# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dmidecode/dmidecode-2.12-r1.ebuild,v 1.9 2015/04/14 11:01:12 ago Exp $

EAPI="4"

inherit flag-o-matic toolchain-funcs eutils

DESCRIPTION="DMI (Desktop Management Interface) table related utilities"
HOMEPAGE="http://www.nongnu.org/dmidecode/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 arm ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-solaris"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-dmidecode )"
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}/${PV}-supported-smbios-version.patch"
	sed -i \
		-e "/^prefix/s:/usr/local:${EPREFIX}/usr:" \
		-e "/^docdir/s:dmidecode:${PF}:" \
		-e '/^PROGRAMS !=/d' \
		Makefile || die
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)"
}

pkg_postinst() {
	if [[ ${CHOST} == *-solaris* ]] ; then
		einfo "dmidecode needs root privileges to read /dev/xsvc"
		einfo "To make dmidecode useful, either run as root, or chown and setuid the binary."
		einfo "Note that /usr/sbin/ptrconf and /usr/sbin/ptrdiag give similar"
		einfo "information without requiring root privileges."
	fi
}
