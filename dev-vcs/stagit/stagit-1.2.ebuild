# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Generates static HTML pages for a Git repository"
HOMEPAGE="https://codemadness.org/stagit.html"
SRC_URI="https://codemadness.org/releases/stagit/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-libs/libgit2:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-1.1-pkg-config.patch )

src_install() {
	emake DESTDIR="${D}" \
		  DOCPREFIX="${EPREFIX}"/usr/share/doc/${PF} \
		  MANPREFIX="${EPREFIX}"/usr/share/man \
		  PREFIX="${EPREFIX}"/usr \
		  install
}
