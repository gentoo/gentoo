# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde4-base

DESCRIPTION="SANE Library interface by KDE"
SRC_URI="mirror://kde/Attic/applications/${PV}/src/${P}.tar.xz"

KEYWORDS="amd64 x86"
IUSE="debug"
LICENSE="LGPL-2"

DEPEND=""
RDEPEND="kde-apps/libksane:5"

DEPEND="
	media-gfx/sane-backends
"
RDEPEND="${DEPEND}"

src_install() {
	kde4-base_src_install
	rm -r "${ED}"usr/share/icons || die
}
