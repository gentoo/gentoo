# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PKG=manpages-pl-${PV}

DESCRIPTION="A collection of Polish translations of Linux manual pages"
HOMEPAGE="https://sourceforge.net/projects/manpages-pl/"
SRC_URI="mirror://sourceforge/manpages-pl/${MY_PKG}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86"

DOCS=( AUTHORS README )

S="${WORKDIR}/${MY_PKG}"

src_prepare() {
	default

	#mans provided by other packages
	rm generated/man1/groups.1 po/man1/groups.1.po || die "Failed to clean up duplicates from build directory!"
}

src_install() {
	emake install DESTDIR="${D}" COMPRESSOR=:
}
