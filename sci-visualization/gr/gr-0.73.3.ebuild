# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Universal framework for cross-platform visualization applications"
HOMEPAGE="https://gr-framework.org/"
SRC_URI="https://github.com/sciapp/gr/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="agg cairo ffmpeg postscript tiff truetype"

DEPEND="
	dev-qt/qtgui:=
	media-libs/fontconfig
	media-libs/glfw
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/qhull:=
	net-libs/zeromq
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXt
	agg? ( x11-libs/agg )
	cairo? ( x11-libs/cairo )
	ffmpeg? ( media-video/ffmpeg:= )
	postscript? ( app-text/ghostscript-gpl )
	tiff? ( media-libs/tiff:= )
	truetype? ( media-libs/freetype )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.53.0-musl.patch"
)

REQUIRED_USE="cairo? ( truetype )"

src_configure() {
	if use agg ; then
		mycmakeargs+=( -DAGG_LIBRARY=/usr/$(get_libdir)/libagg.so -DAGG_INCLUDE_DIR=/usr/include/agg2 )
	else
		mycmakeargs+=( -DAGG_LIBRARY= )
	fi

	use cairo || mycmakeargs+=( -DCAIRO_LIBRARY= )
	use postscript || mycmakeargs+=( -DGS_LIBRARY= )
	use ffmpeg || mycmakeargs+=( -DFFMPEG_INCLUDE_DIR= )
	use truetype || mycmakeargs+=( -DFREETYPE_LIBRARY= )
	use tiff || mycmakeargs+=( -DTIFF_LIBRARY= )

	# todo: X11 automagic

	mycmakeargs+=( -DCMAKE_INSTALL_PREFIX=/usr/gr )
	mycmakeargs+=( -DCMAKE_INSTALL_LIBDIR=lib )
	#
	# I need to have a serious conversation with upstream.
	# * The main consumer of this package is dev-lang/julia.
	# * If I patch gr to install in standard locations, julia does
	#   not find it anymore.
	# * I can't patch julia, since the corresponding scripts are
	#   downloaded at runtime from its package registry ...
	# * See bug 882619 in addition.

	cmake_src_configure
}

src_install() {
	cmake_src_install
	find "${ED}" -name '*.a' -delete

	echo "GRDIR=/usr/gr" > "${T}/99gr"
	echo "LDPATH=/usr/gr/$(get_libdir)" >> "${T}/99gr"
	doenvd "${T}/99gr"

	[[ -f "${ED}/usr/gr/bin/gksqt" ]] && dosym ../gr/bin/gksqt /usr/bin/gksqt

	elog "${P} relies on the environment variable GRDIR. If you want to use it in a running shell,"
	elog "e.g. with dev-lang/julia, then run \"source /etc/profile\" first."
}
