# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
KDE_REQUIRED="optional"
KDE_SCM="svn"

inherit kde4-base qmake-utils

if [[ $PV != *9999 ]]; then
	REV="1712"
	S="${WORKDIR}/cloudcity-code-${REV}"
	SRC_URI="https://sourceforge.net/code-snapshots/svn/c/cl/cloudcity/code/cloudcity-code-${REV}.zip"
	KEYWORDS="~amd64 ~x86"
else
	ESVN_REPO_URI="https://svn.code.sf.net/p/cloudcity/code/"
	KEYWORDS=""
fi

DESCRIPTION="Very configurable Qt4/KDE4 style derived from the Oxygen project"
HOMEPAGE="http://cloudcity.sourceforge.net/"

LICENSE="GPL-2"
SLOT="4"
IUSE="debug kde plasma windeco"

REQUIRED_USE="
	windeco? ( kde )
	plasma? ( kde )
"

RDEPEND="
	dev-qt/qt3support:4
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	x11-libs/libX11
	x11-libs/libXrender
	windeco? ( $(add_kdebase_dep kwin) )
"
DEPEND="${RDEPEND}
	app-arch/unzip
"

src_prepare() {
	# bug #542976
	sed -e "s/kworkspace//" -i XBar/CMakeLists.txt || die

	kde4-base_src_prepare
}

src_configure() {
	if use kde ; then
		local mycmakeargs=(
			$(cmake-utils_use_enable kde KDE)
			$(cmake-utils_use_enable windeco KWIN)
			$(cmake-utils_use_enable plasma XBAR)
			-DENABLE_ARGB=ON
		)

		kde4-base_src_configure
	else
		eqmake4
	fi
}

src_compile() {
	if use kde ; then
		kde4-base_src_compile
	else
		default
	fi
}

src_install() {
	if use kde ; then
		kde4-base_src_install
	else
		emake INSTALL_ROOT="${D}" install
	fi
}
