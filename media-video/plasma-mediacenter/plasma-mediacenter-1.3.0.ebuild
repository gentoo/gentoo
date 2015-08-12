# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DECLARATIVE_REQUIRED="always"
OPENGL_REQUIRED="always"
KDE_LINGUAS="bs ca ca@valencia cs da de el es fi fr gl hu it lv nl pl pt pt_BR sk sl sv tr uk zh_TW"
inherit kde4-base

DESCRIPTION="Unified media experience for any device capable of running KDE"
HOMEPAGE="http://www.kde.org/ http://community.kde.org/Plasma/Plasma_Media_Center"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.bz2"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE="debug semantic-desktop"

# bug 516686
RESTRICT="test"

RDEPEND="
	$(add_kdebase_dep plasma-workspace)
	dev-qt/qt-mobility[multimedia,qml]
	media-libs/taglib
	semantic-desktop? ( $(add_kdebase_dep baloo) )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

S=${WORKDIR}/${PN}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_NepomukCore=ON
		$(cmake-utils_use_find_package semantic-desktop Baloo)
	)

	if ! use semantic-desktop ; then
		mycmakeargs+=( -DUSE_FILESYSTEM_MEDIA_SOURCE=ON )
	fi

	kde4-base_src_configure
}
