# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV^^}
MY_PV=${MY_PV/_/-}
inherit desktop qmake-utils

DESCRIPTION="Feature-rich dictionary lookup program"
HOMEPAGE="http://goldendict.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug ffmpeg libav"

RDEPEND="
	app-arch/bzip2
	>=app-text/hunspell-1.2:=
	dev-libs/eb
	dev-libs/lzo
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-qt/qtsvg:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	media-libs/libvorbis
	media-libs/tiff:0
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXtst
	ffmpeg? (
		media-libs/libao
		libav? ( media-video/libav:0= )
		!libav? ( media-video/ffmpeg:0= )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.0-qtsingleapplication-unbundle.patch"
	"${FILESDIR}/${PN}-1.5.0-qt-5.11.patch"
	"${FILESDIR}/${PN}-1.5.0-ffmpeg-4.patch"
)

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default

	# disable git
	sed -i \
		-e '/git describe/s/^/#/' \
		${PN}.pro || die

	# fix installation path
	sed -i \
		-e '/PREFIX = /s:/usr/local:/usr:' \
		${PN}.pro || die

	# add trailing semicolon
	sed -i -e '/^Categories/s/$/;/' redist/${PN}.desktop || die
}

src_configure() {
	local myconf=()
	use ffmpeg || myconf+=( DISABLE_INTERNAL_PLAYER=1 )

	eqmake5 "${myconf[@]}"
}

src_install() {
	dobin ${PN}
	domenu redist/${PN}.desktop
	doicon redist/icons/${PN}.png

	insinto /usr/share/apps/${PN}/locale
	doins locale/*.qm

	insinto /usr/share/${PN}/help
	doins help/*.qch
}
