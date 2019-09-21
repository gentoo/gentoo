# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils cmake-utils gnome2-utils xdg-utils

DESCRIPTION="Project aiming to recreate classic Opera (12.x) UI using Qt5"
HOMEPAGE="https://otter-browser.org/"
SRC_URI="https://github.com/OtterBrowser/${PN}-browser/archive/v${PV/_p/-dev}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="webengine +webkit spell"
REQUIRED_USE="
	|| ( webengine webkit )
"

DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxmlpatterns:5
	spell? ( kde-frameworks/sonnet )
	webengine? ( >=dev-qt/qtwebengine-5.9:5[widgets] )
	webkit? ( dev-qt/qtwebkit:5 )
"
RDEPEND="
	${DEPEND}
"

S=${WORKDIR}/${PN}-browser-${PV/_p/-dev}
DOCS=( CHANGELOG CONTRIBUTING.md TODO )

src_prepare() {
	cmake-utils_src_prepare

	if [[ -n ${LINGUAS} ]]; then
		local lingua
		for lingua in resources/translations/*.qm; do
			lingua=$(basename ${lingua})
			lingua=${lingua/otter-browser_/}
			lingua=${lingua/.qm/}
			if ! has ${lingua} ${LINGUAS}; then
				rm resources/translations/otter-browser_${lingua}.qm || die
			fi
		done
	fi

	if ! use spell; then
		sed -i -e '/find_package(KF5Sonnet)/d' CMakeLists.txt || die
	fi
}

src_configure() {
	mycmakeargs=(
		-DENABLE_QTWEBENGINE="$(usex webengine)"
		-DENABLE_QTWEBKIT="$(usex webkit)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	domenu ${PN}-browser.desktop
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
