# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )
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
	>=dev-libs/serd-0.24.0
	>=dev-libs/sord-0.14.0
	>=media-libs/lilv-0.24.0
	>=media-libs/lv2-1.16.0
	>=media-libs/sratom-0.6.0
	>=media-libs/suil-0.10.0
	gtk? ( >=x11-libs/gtk+-3.0.0:3 )
	gtk2? ( >=x11-libs/gtk+-2.18.0:2 )
	gtkmm? ( >=dev-cpp/gtkmm-2.20.0:2.4 )
	portaudio? ( media-libs/portaudio )
	!portaudio? ( virtual/jack )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README.md )

PATCHES=(
	"${FILESDIR}/${P}-qt-5.7.0.patch"
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
