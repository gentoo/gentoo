# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE web development - link validity checker"
HOMEPAGE="https://www.kde.org/applications/development/klinkstatus/"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug tidy"

DEPEND="
	$(add_kdeapps_dep kdepimlibs)
	tidy? ( app-text/htmltidy )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_LibTidy=$(usex tidy)
	)

	kde4-base_src_configure
}

pkg_postinst() {
	kde4-base_pkg_postinst

	if ! has_version dev-lang/ruby ; then
		elog "To use scripting in ${PN}, install dev-lang/ruby."
	fi
}
