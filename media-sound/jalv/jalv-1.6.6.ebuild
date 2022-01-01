# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE='threads(+)'
inherit python-any-r1 qmake-utils waf-utils

DESCRIPTION="Simple but fully featured LV2 host for Jack"
HOMEPAGE="http://drobilla.net/software/jalv/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk gtk2 gtkmm portaudio qt5"

RDEPEND="
	dev-libs/serd
	dev-libs/sord
	media-libs/lilv
	media-libs/lv2
	media-libs/sratom
	media-libs/suil
	gtk? ( x11-libs/gtk+:3 )
	gtk2? ( x11-libs/gtk+:2 )
	gtkmm? ( dev-cpp/gtkmm:2.4 )
	portaudio? ( media-libs/portaudio )
	!portaudio? ( virtual/jack )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"
DOCS=( AUTHORS NEWS README.md )

PATCHES=(
	"${FILESDIR}/${P}-suil-always.patch"
)

src_configure() {
	use qt5 && export PATH="$(qt5_get_bindir):${PATH}"
	waf-utils_src_configure \
		"--docdir=/usr/share/doc/${PF}" \
		--no-qt4 \
		$(use qt5       || echo --no-qt5)       \
		$(use gtk       || echo --no-gtk3)      \
		$(use gtk2      || echo --no-gtk2)      \
		$(use gtkmm     || echo --no-gtkmm)     \
		$(use portaudio && echo --portaudio)
}
