# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="DMI (Desktop Management Interface) table related utilities"
HOMEPAGE="https://www.nongnu.org/dmidecode/"
SRC_URI="https://savannah.nongnu.org/download/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* alpha amd64 arm ~arm64 ia64 ~mips ppc ppc64 sparc x86 ~x86-solaris"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-dmidecode )"
DEPEND=""

src_prepare() {
	default
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
