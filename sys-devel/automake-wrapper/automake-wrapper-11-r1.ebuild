# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="wrapper for automake to manage multiple automake versions"
HOMEPAGE="https://gitweb.gentoo.org/proj/autotools-wrappers.git"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

src_unpack() {
	cp "${FILESDIR}"/am-wrapper-${PV}.sh "${S}"/ || die
}

src_prepare() {
	default

	# usr/bin/aclocal: bad substitution -> /bin/sh != POSIX shell
	if use prefix ; then
		sed -i -e '1c\#!'"${EPREFIX}"'/bin/sh' am-wrapper-${PV}.sh || die
	fi
}

src_install() {
	newbin am-wrapper-${PV}.sh automake
	dosym automake /usr/bin/aclocal

	keepdir /usr/share/aclocal
}
