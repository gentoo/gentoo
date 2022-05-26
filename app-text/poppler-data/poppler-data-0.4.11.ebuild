# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Data files for poppler to support uncommon encodings without xpdfrc"
HOMEPAGE="https://poppler.freedesktop.org/"
SRC_URI="https://poppler.freedesktop.org/${P}.tar.gz"

LICENSE="BSD GPL-2 MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

src_install() {
	emake prefix="${EPREFIX}"/usr DESTDIR="${D}" install

	# bug #409361
	dodir /usr/share/poppler/cMaps
	cd "${ED}"/usr/share/poppler/cMaps || die
	find ../cMap -type f -exec ln -s {} . \; || die
}
