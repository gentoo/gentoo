# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="command-line utility to create toc-files for cdrdao"
HOMEPAGE="https://sourceforge.net/projects/mkcdtoc/"
SRC_URI="mirror://sourceforge/mkcdtoc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-lang/perl-5.8.0"
RDEPEND="${DEPEND}"

src_compile() {
	# bug #799164
	emake PREFIX="${EPREFIX}/usr"
}

src_install() {
	# bug #799164
	emake \
		PREFIX="${EPREFIX}/usr" \
		DESTDIR="${D}" \
		MANDIR="/usr/share/man" \
		install
}
