# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde4-base

DESCRIPTION="SANE Library interface for KDE"
KEYWORDS="amd64 x86"
IUSE="debug"
LICENSE="LGPL-2"

DEPEND=""
RDEPEND="|| ( >=kde-base/legacy-icons-4.11.22-r1 kde-apps/libksane:5 )"

DEPEND="
	media-gfx/sane-backends
"
RDEPEND="${DEPEND}"

src_install() {
	kde4-base_src_install
	rm -r "${ED}"usr/share/icons || die
}
