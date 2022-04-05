# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Cross-platform content manager assistant for the PS Vita"
HOMEPAGE="https://github.com/codestation/qcma"
SRC_URI="https://github.com/codestation/qcma/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+ffmpeg"

DEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	media-libs/vitamtp:0
	ffmpeg? ( media-video/ffmpeg:0 )
	x11-libs/libnotify:0
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
"

src_prepare() {
	# http://ffmpeg.org/pipermail/ffmpeg-devel/2018-February/225051.html
	sed -r \
		-e '/av_register_all/d' \
		-i "${S}"/common/avdecoder.h || die "Failed to fix ffmpeg stuff"
	rm ChangeLog || die "Failed to rm changelog" # Triggers QA warn (symlink to nowhere)
	default
}

src_configure() {
	$(qt5_get_bindir)/lrelease common/resources/translations/*.ts || die
	eqmake5 PREFIX="${EPREFIX}"/usr qcma.pro CONFIG+="QT5_SUFFIX" $(usex ffmpeg "" CONFIG+="DISABLE_FFMPEG")
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${ED}" install
	einstalldocs

	insinto /usr/share/${PN}/translations
	doins common/resources/translations/${PN}_*.qm
}
