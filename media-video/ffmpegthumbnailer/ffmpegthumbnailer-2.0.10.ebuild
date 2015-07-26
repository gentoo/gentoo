# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpegthumbnailer/ffmpegthumbnailer-2.0.10.ebuild,v 1.1 2015/07/26 21:30:52 mgorny Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="Lightweight video thumbnailer that can be used by file managers"
HOMEPAGE="https://github.com/dirkvdb/ffmpegthumbnailer"
SRC_URI="https://github.com/dirkvdb/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="gnome gtk jpeg libav png test"

RDEPEND="
	gtk? ( dev-libs/glib:2= )
	jpeg? ( virtual/jpeg:0= )
	!libav? ( >=media-video/ffmpeg-2.7:0= )
	libav? ( >=media-video/libav-11:0= )
	png? ( media-libs/libpng:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
REQUIRED_USE="gnome? ( gtk )"

PATCHES=(
	"${FILESDIR}/${P}-config-summary.patch"
	"${FILESDIR}/${P}-installdirs.patch"
	"${FILESDIR}/${P}-set-locale.patch"
)

DOCS=( AUTHORS ChangeLog README.md )

src_prepare() {
	rm -rf out* || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_GIO=$(usex gtk)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_THUMBNAILER=$(usex gnome)
		-DHAVE_JPEG=$(usex jpeg)
		-DHAVE_PNG=$(usex png)
	)
	cmake-utils_src_configure
}
