# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/23" # based on SONAME
KEYWORDS="~amd64 -arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="examples"

RDEPEND="
	~media-libs/ilmbase-${PV}:=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-archive-2016.09.16
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-2.2.0-fix-cpuid-on-abi_x86_32.patch" # master
	"${FILESDIR}/${PN}-2.2.0-use-ull-for-64-bit-literals.patch" # master
	"${FILESDIR}/${PN}-2.2.0-fix-config.h-collision.patch" # custom patch
	"${FILESDIR}/${PN}-2.2.0-Fix-typo-in-C-bindings.patch" # master
	"${FILESDIR}/${PN}-2.2.1-use-gnuinstalldirs.patch" # custom patch
)

mycmakeargs=(
	-DILMBASE_PACKAGE_PREFIX="${EPREFIX}/usr"
	-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
)

src_prepare() {
	cmake-utils_src_prepare

	# Fix path for testsuite
	sed -i -e "s:/var/tmp/:${T}:" IlmImfTest/tmpDir.h || die
}

multilib_src_install_all() {
	einstalldocs

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
	else
		rm -rf "${ED%/}"/usr/share/doc/${PF}/examples || die
	fi
}
