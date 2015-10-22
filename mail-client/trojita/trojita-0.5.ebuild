# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

QT4_REQUIRED="4.8.0"
EGIT_REPO_URI="git://anongit.kde.org/${PN}.git"
[[ ${PV} == "9999" ]] && GIT_ECLASS="git-2"

inherit cmake-utils virtualx ${GIT_ECLASS}

DESCRIPTION="A Qt IMAP e-mail client"
HOMEPAGE="http://trojita.flaska.net/"
if [[ ${PV} == "9999" ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	MY_LANGS="ar bs ca cs da de el en_GB es et fi fr ga gl hu ia it ja lt mr nb nds nl pl pt pt_BR ro sk sv tr ug uk zh_CN zh_TW"
fi

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
IUSE="debug +password qt5 test +zlib"
for MY_LANG in ${MY_LANGS} ; do
	IUSE="${IUSE} linguas_${MY_LANG}"
done

RDEPEND="
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
	)
	!qt5? (
		>=dev-qt/qtbearer-${QT4_REQUIRED}:4
		>=dev-qt/qtgui-${QT4_REQUIRED}:4
		>=dev-qt/qtsql-${QT4_REQUIRED}:4[sqlite]
		>=dev-qt/qtwebkit-${QT4_REQUIRED}:4
	)
"
DEPEND="${RDEPEND}
	password? (
		qt5?	( dev-libs/qtkeychain[qt5] )
		!qt5?	( dev-libs/qtkeychain[qt4] )
	)
	qt5? ( dev-qt/linguist-tools:5 )
	test? (
		qt5?	( dev-qt/qttest:5 )
		!qt5?	( >=dev-qt/qttest-${QT4_REQUIRED}:4 )
	)
	zlib? (
		virtual/pkgconfig
		sys-libs/zlib
	)
"

DOCS="README LICENSE"
PATCHES=( "${FILESDIR}/${P}-qt5.5-includes.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with qt5 QT5)
		$(cmake-utils_use_with password QTKEYCHAIN_PLUGIN)
		$(cmake-utils_use_with test TESTS)
		$(cmake-utils_use_with zlib ZLIB)
	)
	if [[ ${MY_LANGS} ]]; then
		rm po/trojita_common_x-test.po
		for x in po/*.po; do
			mylang=${x#po/trojita_common_}
			mylang=${mylang%.po}
			use linguas_$mylang || rm $x
		done
	fi

	# the build system is taking a look at `git describe ... --dirty` and
	# gentoo's modifications to CMakeLists.txt break these
	sed -i "s/--dirty//" "${S}/cmake/TrojitaVersion.cmake" || die "Cannot fix the version check"

	cmake-utils_src_configure
}

src_test() {
	VIRTUALX_COMMAND=cmake-utils_src_test virtualmake
}
