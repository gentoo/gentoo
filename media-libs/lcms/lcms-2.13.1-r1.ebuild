# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="A lightweight, speed optimized color management engine"
HOMEPAGE="http://www.littlecms.com/"
SRC_URI="https://github.com/mm2/Little-CMS/releases/download/lcms${PV}/${PN}2-${PV}.tar.gz"
S="${WORKDIR}/lcms2-${PV}"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc jpeg static-libs test +threads tiff zlib"
REQUIRED_USE="tiff? ( zlib )"

RESTRICT="!test? ( test )"

RDEPEND="
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-4.0.3-r6:=[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.13.1-fix-configure-bashisms.patch
	"${FILESDIR}"/${PN}-2.13.1-clang-15-configure.patch
)

src_prepare() {
	default

	# TODO: Swap back to elibtoolize once dropped eautoreconf (for bashism patch)
	# for Prefix/Solaris
	#elibtoolize
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_with jpeg)
		$(use_enable static-libs static)
		$(use_with threads)
		$(use_with tiff)
		$(use_with zlib)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	find "${ED}" -type f -name "*.la" -delete || die

	use doc && dodoc doc/*.pdf
}
