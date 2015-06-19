# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/trojita/trojita-0.4.1.ebuild,v 1.3 2014/06/14 10:34:50 phajdan.jr Exp $

EAPI=5

QT_REQUIRED="4.8.0"
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
	KEYWORDS="amd64 ~ppc x86"
	MY_LANGS="bs cs da de el es et fr ga gl hu ia it lt mr nb nl pl pt pt_BR ro sk sv tr ug uk zh_CN zh_TW"
fi

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
IUSE="debug test +zlib"
for MY_LANG in ${MY_LANGS} ; do
	IUSE="${IUSE} linguas_${MY_LANG}"
done

RDEPEND="
	>=dev-qt/qtbearer-${QT_REQUIRED}:4
	>=dev-qt/qtgui-${QT_REQUIRED}:4
	>=dev-qt/qtsql-${QT_REQUIRED}:4[sqlite]
	>=dev-qt/qtwebkit-${QT_REQUIRED}:4
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qttest-${QT_REQUIRED}:4 )
	zlib? (
		virtual/pkgconfig
		sys-libs/zlib
	)
"

DOCS="README LICENSE"

src_configure() {
	local mycmakeargs=(
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
