# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Raw bytes manipulation, transformations (decoding and more) and interception"
HOMEPAGE="https://github.com/metrodango/pip3line"
if [[ ${PV} == 9999* ]] ; then
inherit git-r3
SRC_URI=""
EGIT_REPO_URI="https://github.com/metrodango/pip3line.git"
EGIT_BRANCH="master"
KEYWORDS="~amd64 ~x86"
else
SRC_URI="https://github.com/metrodango/pip3line/archive/v${PV}.tar.gz"
KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

IUSE="openssl qscintilla distorm python2_7 python3"

RDEPEND="openssl? ( dev-libs/openssl:0= )
		qscintilla? ( x11-libs/qscintilla )
		distorm? ( dev-libs/distorm64 )
		python2_7? ( dev-lang/python:2.7 )
		python3? ( dev-lang/python:3.5 )
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtxmlpatterns:5
		dev-qt/qtconcurrent:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
"

DEPEND="${RDEPEND}
dev-util/cmake
dev-vcs/git"

src_configure() {

local mycmakeargs=(
-DBASIC=yes
	-DWITH_OPENSSL=$(usex openssl )
	-DWITH_PYTHON27=$(usex python2_7)
	-DWITH_PYTHON3=$(usex python3)
	-DWITH_SCINTILLA=$(usex qscintilla)
	-DWITH_DISTORM=$(usex distorm)
)

	ext/gen_distorm.sh || die

	cmake-utils_src_configure
}

pkg_postinst() {

if [ $(usex distorm) ] ; then
echo
ewarn "The Distorm plugin was compiled"
ewarn "Beware the current distorm64 installation does not"
ewarn "copy the necessary files at the right place."
ewarn "The native library is in /usr/lib64/python[version]/site-packages/distorm3/libdistorm3.so"
ewarn "If you want the plugin to load properly create a link of this lib in /usr/lib64 or /usr/local/lib64"
ewarn "Whichever you prefer"
echo
fi

}
