# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="autotools-wrappers-at-${PV}"

DESCRIPTION="Wrapper for automake to manage multiple automake versions"
HOMEPAGE="https://gitweb.gentoo.org/proj/autotools-wrappers.git"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="
		https://anongit.gentoo.org/git/proj/autotools-wrappers.git
		https://github.com/gentoo/autotools-wrappers
	"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/autotools-wrappers.git/snapshot/${MY_P}.tar.gz"
	S="${WORKDIR}"/${MY_P}

	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="GPL-2"
SLOT="0"

src_prepare() {
	default

	# usr/bin/aclocal: bad substitution -> /bin/sh != POSIX shell
	if use prefix ; then
		sed -i -e '1c\#!'"${EPREFIX}"'/bin/sh' am-wrapper.sh || die
	fi
}

src_install() {
	exeinto /usr/$(get_libdir)/misc
	doexe am-wrapper.sh

	local x=
	for x in automake aclocal ; do
		dosym -r /usr/$(get_libdir)/misc/am-wrapper.sh /usr/bin/${x}
	done

	keepdir /usr/share/aclocal
}
