# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A server browser for many FPS games (frontend for qstat)"
HOMEPAGE="http://xqf.github.io/en/"
SRC_URI="https://github.com/XQF/xqf/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="bzip2 geoip nls"

RDEPEND="
	x11-libs/gdk-pixbuf-xlib
	x11-libs/gtk+:2
	>=games-util/qstat-2.11
	nls? ( virtual/libintl )
	geoip? ( dev-libs/geoip )
	bzip2? ( app-arch/bzip2 )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${PN}-${P}"

PATCHES=(
	"${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-zlib-1.2.5.1-compile-fix.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable geoip) \
		$(use_enable bzip2)
}
