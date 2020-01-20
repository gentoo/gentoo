# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils xdg

DESCRIPTION="Video effects library based on web technologies"
HOMEPAGE="https://github.com/mltframework/webvfx/"
SRC_URI="https://github.com/mltframework/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtquickcontrols:5[widgets]
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	>=media-libs/mlt-6.10.0-r1[ffmpeg,frei0r,qt5,sdl,xml]
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's/\(target.*path.*PREFIX.*\)lib/\1'$(get_libdir)'/' \
		webvfx/webvfx.pro || die

	default
}

src_configure() {
	local mycxxflags=(
		-Wno-deprecated-declarations
	)

	append-cxxflags ${mycxxflags[@]}

	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
