# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0"
PLOCALES="bg cs de es hu pl ru uk"
inherit cmake-utils wxwidgets l10n xdg-utils gnome2-utils eapi7-ver

CR_PV=$(ver_rs 3 '-')

if [ "${PV}" != 9999 ]
then
	SRC_URI="https://github.com/buggins/${PN}/archive/cr${CR_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-cr${CR_PV}"
else
	inherit git-r3
	# github mirror has some new commits to fix page margins settings
	# sourceforge mirror saved as backup
	#EGIT_REPO_URI="git://git.code.sf.net/p/crengine/crengine"
	EGIT_REPO_URI="https://github.com/buggins/${PN}.git"
	SRC_URI=""
fi

DESCRIPTION="CoolReader - reader of eBook files (fb2,epub,htm,rtf,txt)"
HOMEPAGE="https://github.com/buggins/coolreader/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="wxwidgets"

CDEPEND="sys-libs/zlib
	media-libs/libpng:0
	virtual/jpeg:0
	media-libs/freetype
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER} )
	!wxwidgets? ( dev-qt/qtcore:5 dev-qt/qtgui:5 dev-qt/qtwidgets:5 )"
DEPEND="${CDEPEND}
	!wxwidgets? ( dev-qt/linguist-tools:5 )"
RDEPEND="${CDEPEND}
	wxwidgets? ( || ( media-fonts/liberation-fonts media-fonts/corefonts ) )"

for lang in ${PLOCALES}; do
	IUSE="${IUSE} l10n_${lang}"
done

src_prepare() {
	cmake-utils_src_prepare

	# locales
	l10n_find_plocales_changes "${S}"/cr3qt/src/i18n 'cr3_' '.ts'
	local lang langs
	langs=""
	for lang in ${PLOCALES}; do
		if use l10n_${lang}; then
			langs="${langs} ${lang}"
		fi
	done
	sed -e "s|SET(LANGUAGES .*)|SET(LANGUAGES ${langs})|" \
		-i "${S}"/cr3qt/CMakeLists.txt \
		|| die "sed CMakeLists.txt failed"
}

src_configure() {
	CMAKE_USE_DIR="${S}"
	CMAKE_BUILD_TYPE="Release"
	if use wxwidgets; then
		setup-wxwidgets
		local mycmakeargs=(-D GUI=WX)
	else
		local mycmakeargs=(-D GUI=QT5)
	fi
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if ! use wxwidgets; then
		mv "${D}"usr/share/doc/cr3/changelog.gz "${D}"usr/share/doc/${PF}/ || die "mv changelog.gz failed"
		rmdir "${D}"usr/share/doc/cr3 || die "rmdir doc/cr3 failed"
		gunzip "${D}"usr/share/doc/${PF}/changelog.gz || die "gunzip changelog.gz failed"
		gunzip "${D}"usr/share/man/man1/cr3.1.gz || die "gunzip cr3.1.gz failed"
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
