# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils eutils

DESCRIPTION="a graphical disassembler for a large number of instruction sets"
HOMEPAGE="http://www.emilpro.com/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/SimonKagstrom/emilpro"
	inherit git-r3
	SRC_URI="!system-binutils? ( mirror://gnu/binutils/binutils-2.23.2.tar.bz2 )"
else
	SRC_URI="http://www.emilpro.com/${P}.tar.gz
		!system-binutils? ( mirror://gnu/binutils/binutils-2.23.2.tar.bz2 )"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+system-binutils"

DEPEND="
	dev-cpp/cairomm:0
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-cpp/gtksourceviewmm:3.0
	dev-cpp/libxmlpp:2.6
	dev-cpp/pangomm:1.4
	dev-libs/libsigc++:2
	dev-libs/glib:2
	system-binutils? ( >=sys-libs/binutils-libs-2.25.1-r2:=[multitarget] )
	net-misc/curl
	virtual/libelf:0="
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/respect-cflags.patch
	if use system-binutils; then
		epatch "${FILESDIR}"/${P}-system-binutils.patch
	else
		sed -i "s#wget -O binutils.tar.bz2 https://ftp.gnu.org/gnu/binutils/binutils-2.23.2.tar.bz2#cp \"${DISTDIR}/binutils-2.23.2.tar.bz2\" ./binutils.tar.bz2#" cmake/BuildBinutils.cmake
	fi
	epatch "${FILESDIR}"/or1k.patch
	epatch "${FILESDIR}"/or1k-2.patch
	cmake-utils_src_prepare
}

src_compile() {
	if use system-binutils; then
		cmake-utils_src_compile
	else
		#bundled binutils is broken, always builds with one thread
		#but somehow it still fails if I don't do this
		cd "${BUILD_DIR}"
		emake -j1
	fi
}

src_install() {
	dobin "${BUILD_DIR}"/emilpro
}
