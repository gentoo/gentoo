# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="A RS-274X (Gerber) and NC drill (Excellon) file viewer"
HOMEPAGE="https://gerbv.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc examples unit-mm"
RESTRICT="test"

RDEPEND="
	sys-devel/gettext
	x11-libs/gtk+:2
	x11-libs/cairo"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	  "${FILESDIR}"/${PN}-2.13.0-no_compress_man.patch
	  "${FILESDIR}"/${PN}-2.13.0-main_c_glib_strncasecmp.patch
	  "${FILESDIR}"/${PN}-2.13.0-cmake_canonicalize_file_name.patch
	  "${FILESDIR}"/${PN}-2.13.0-release_version.patch
	)

src_configure() {
	# We're manually installing examples if desired
	sed -i 's/install(DIRECTORY example/#install(DIRECTORY example/' "${S}"/CMakeLists.txt || die
	cmake_src_configure
}

src_install() {
	rm README-{git,release}.txt || die
	cmake_src_install
	rm "${D}"/usr/lib64/libgerbv.a

	dodoc CONTRIBUTORS HACKING

	rm doc/Doxyfile.nopreprocessing || die
	if use doc; then
		find doc -name 'Makefile*' -delete || die
		dodoc -r doc/.
	fi

	if use examples; then
		find example -name 'Makefile*' -delete || die
		dodoc -r example/.
	fi
}
