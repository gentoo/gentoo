# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils desktop flag-o-matic xdg virtualx

DESCRIPTION="3D photo-realistic skies in real time"
HOMEPAGE="https://www.stellarium.org/"
SRC_URI="
	https://github.com/Stellarium/stellarium/releases/download/v${PV}/${P}.tar.gz
	stars? (
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_4_1v0_2.cat
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_5_2v0_1.cat
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_6_2v0_1.cat
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_7_2v0_1.cat
		https://github.com/Stellarium/stellarium-data/releases/download/stars-2.0/stars_8_2v0_1.cat
	)"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug gps media nls stars test"

BDEPEND="
	nls? ( dev-qt/linguist-tools:5 )
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	dev-qt/qtserialport:5
	dev-qt/qtwidgets:5
	media-fonts/dejavu
	sys-libs/zlib
	virtual/opengl
	gps? ( dev-qt/qtpositioning:5 )
	media? ( dev-qt/qtmultimedia:5[widgets] )
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
	test? ( dev-qt/qttest:5 )
"

RESTRICT="!test? ( test )"

src_prepare() {
	cmake-utils_src_prepare
	use debug || append-cppflags -DQT_NO_DEBUG #415769
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_GPS="$(usex gps)"
		-DENABLE_MEDIA="$(usex media)"
		-DENABLE_NLS="$(usex nls)"
		-DENABLE_TESTING="$(usex test)"
	)
	cmake-utils_src_configure
}

src_test() {
	virtx cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install

	# use the more up-to-date system fonts
	rm "${ED}"/usr/share/stellarium/data/DejaVuSans{Mono,}.ttf || die
	dosym ../../fonts/dejavu/DejaVuSans.ttf /usr/share/stellarium/data/DejaVuSans.ttf
	dosym ../../fonts/dejavu/DejaVuSansMono.ttf /usr/share/stellarium/data/DejaVuSansMono.ttf

	if use stars ; then
		insinto /usr/share/${PN}/stars/default
		doins "${DISTDIR}"/stars_4_1v0_2.cat
		doins "${DISTDIR}"/stars_{5,6,7,8}_2v0_1.cat
	fi
	newicon doc/images/stellarium-logo.png ${PN}.png
}
