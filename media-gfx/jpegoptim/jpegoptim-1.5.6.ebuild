# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake python-any-r1

DESCRIPTION="Utility to optimize JPEG files"
HOMEPAGE="https://www.kokkonen.net/tjko/projects.html"
SRC_URI="
	https://github.com/tjko/jpegoptim/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"
# TODO?: switch back to this if tarballs become available in a timely fashion
#SRC_URI="https://www.kokkonen.net/tjko/src/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/libjpeg-turbo:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( ${PYTHON_DEPS} )
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}"/usr/share/man/man1
		-DUSE_MOZJPEG=no
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	rm -- "${ED}"/usr/share/doc/${PF}/LICENSE || die
}
