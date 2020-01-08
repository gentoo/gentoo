# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gentoo/${PN}.git"
else
	SRC_URI="https://github.com/gentoo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
fi

inherit toolchain-funcs flag-o-matic

DESCRIPTION="base functions required by all Gentoo systems"
HOMEPAGE="https://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

src_prepare() {
	tc-export CC
	append-lfs-flags
}

src_install() {
	emake install DESTDIR="${ED}"
}
