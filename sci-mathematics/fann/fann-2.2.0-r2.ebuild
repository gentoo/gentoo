# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=FANN-${PV}-Source
inherit cmake

DESCRIPTION="Fast Artificial Neural Network Library"
HOMEPAGE="https://leenissen.dk"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples"

BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}/${P}-examples.patch"
	"${FILESDIR}/${P}-cmake.patch"
)

src_configure() {
	local mycmakeargs=(
		# https://bugs.gentoo.org/863050
		-DPKGCONFIG_INSTALL_DIR="${EPREFIX}/$(get_libdir)/pkgconfig"
	)
	cmake_src_configure
}

src_test() {
	cd examples || die
	emake CFLAGS="${CFLAGS} -I../src/include -L${BUILD_DIR}/src"
	LD_LIBRARY_PATH="${BUILD_DIR}/src" emake runtest
	emake clean
}

src_install() {
	cmake_src_install
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
