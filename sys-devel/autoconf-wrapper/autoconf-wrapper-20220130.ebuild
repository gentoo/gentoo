# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_P="autotools-wrappers-at-${PV}"

DESCRIPTION="wrapper for autoconf to manage multiple autoconf versions"
HOMEPAGE="https://gitweb.gentoo.org/proj/autotools-wrappers.git"
#SRC_URI="https://gitweb.gentoo.org/proj/autotools-wrappers.git/snapshot/${MY_P}.tar.gz"
SRC_URI="https://dev.gentoo.org/~vapier/dist/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

S="${WORKDIR}/${MY_P}"

src_install() {
	exeinto /usr/$(get_libdir)/misc
	newexe ac-wrapper.sh ac-wrapper.sh

	dodir /usr/bin
	local x=
	for x in auto{conf,header,m4te,reconf,scan,update} ifnames ; do
		dosym ../$(get_libdir)/misc/ac-wrapper.sh /usr/bin/${x}
	done
}
