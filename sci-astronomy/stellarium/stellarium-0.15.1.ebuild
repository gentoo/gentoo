# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils eutils flag-o-matic gnome2-utils

DESCRIPTION="3D photo-realistic skies in real time"
HOMEPAGE="http://www.stellarium.org/"
SRC_URI="
	mirror://sourceforge/stellarium/${P}.tar.gz
	stars? (
		mirror://sourceforge/stellarium/stars_4_1v0_1.cat
		mirror://sourceforge/stellarium/stars_5_2v0_1.cat
		mirror://sourceforge/stellarium/stars_6_2v0_1.cat
		mirror://sourceforge/stellarium/stars_7_2v0_1.cat
		mirror://sourceforge/stellarium/stars_8_2v0_1.cat
	)"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug media nls stars"

RESTRICT="test" # There are no tests

RDEPEND="
	media-fonts/dejavu
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtscript:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	virtual/opengl
	sys-libs/zlib
	media? ( dev-qt/qtmultimedia:5[widgets] )"
DEPEND="${RDEPEND}
	dev-qt/qttest:5
	dev-qt/qtconcurrent:5
	nls? ( dev-qt/linguist-tools:5 )"

LANGS=(
	af am ar as ast az be bg bn bo br bs ca cs
	cy da de el en en-GB en-US eo es et eu fa fi fil fr
	ga gd gl gu he hi hr hu hy ia id is it ja ka kk kn ko ky
	la lb lo lt lv mk ml mn mr ms nb nl nn oc pa pl pt pt-BR ro
	ru se si sk sl sq sr sv sw ta te tg th tl tr tt uk uz vi
	zh-CN zh-HK zh-TW zu
	)

for X in "${LANGS[@]}" ; do
	IUSE+=" l10n_${X}"
done
unset X

src_prepare() {
	cmake-utils_src_prepare
	if [[ -n ${L10N} ]] ; then
		sed -i\
			-e 's/STRING(REGEX REPLACE ".po" "" \([a-z]*\).*$/SET(\1 '"${L10N//-/_})/" \
			po/stellarium{,-skycultures,-remotecontrol}/CMakeLists.txt || die #403647
	fi
	# Turn off TelescopeControl since dev-qt/qtserialport isn't
	# marked stable and is missing keywords besides.
	sed -i \
		-e '/SimpleDrawLine/  s:0:1:g' \
		-e '/TelescopeControl/s:1:0:g' \
		CMakeLists.txt || die
	use debug || append-cppflags -DQT_NO_DEBUG #415769
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_NLS="$(usex nls)"
		-DENABLE_MEDIA="$(usex media)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# use the more up-to-date system fonts
	rm "${ED%/}"/usr/share/stellarium/data/DejaVuSans{Mono,}.ttf || die
	dosym ../../fonts/dejavu/DejaVuSans.ttf /usr/share/stellarium/data/DejaVuSans.ttf
	dosym ../../fonts/dejavu/DejaVuSansMono.ttf /usr/share/stellarium/data/DejaVuSansMono.ttf

	if use stars ; then
		insinto /usr/share/${PN}/stars/default
		doins "${DISTDIR}"/stars_{4_1,{5,6,7,8}_2}v0_1.cat
	fi
	newicon doc/images/stellarium-logo.png ${PN}.png
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
