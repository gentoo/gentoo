# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils toolchain-funcs

DESCRIPTION="Video effects library based on web technologies"
HOMEPAGE="https://github.com/mltframework/webvfx/"
SRC_URI="https://github.com/mltframework/${PN}/releases/download/1.1.0/${P}.txz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

BDEPEND="
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtquickcontrols:5[widgets]
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	media-libs/mlt
	virtual/opengl
"
DEPEND="${RDEPEND}
	dev-qt/qtnetwork:5
"

src_prepare() {
	default

	find -name "*.pro" -exec \
		sed -i -e "s/\(system.*\)pkg-config/\1$(tc-getPKG_CONFIG)/" {} + || die

	sed -i -e "s/\(target.*path.*PREFIX.*\)lib/\1$(get_libdir)/" \
		webvfx/webvfx.pro || die

	sed -i -e "s/PROJECT_NUMBER=\`.*\`/PROJECT_NUMBER=${PV}/" \
		all.pro || die
}

src_configure() {
	append-cxxflags -Wno-deprecated-declarations

	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_compile() {
	emake
	use doc && emake doxydoc
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	use doc && local HTML_DOCS=( doxydoc/. )
	einstalldocs
}
