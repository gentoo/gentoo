# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VIRTUALX_REQUIRED="test"
KDE_LINGUAS="bs cs da de el fi fr hu ja lt nl pl pt pt_BR ro ru sk sl sv uk"
inherit kde4-base

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.bz2"
else
	KEYWORDS=""
fi

DESCRIPTION="KDE contact person abstraction library"
HOMEPAGE="https://projects.kde.org/projects/playground/network/kpeople"

LICENSE="LGPL-2.1"
SLOT="4/4"
IUSE="debug examples minimal semantic-desktop test"

RDEPEND="
	$(add_kdeapps_dep kdepimlibs)
	semantic-desktop? ( $(add_kdebase_dep baloo) )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_prepare() {
	use minimal && comment_add_subdirectory po
	kde4-base_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with examples)
		$(cmake-utils_use_find_package semantic-desktop Baloo)
	)

	kde4-base_src_configure
}
