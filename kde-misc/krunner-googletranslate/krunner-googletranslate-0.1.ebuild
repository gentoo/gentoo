# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="Krunner plug-in for Google translate service"
HOMEPAGE="http://kde-apps.org/content/show.php/krunner-googletranslate?content=144348"
SRC_URI="http://gt.kani.hu/distfiles/krunner/${P}.tbz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	dev-libs/qjson
	kde-plasma/libkworkspace:4
"
DEPEND="
	${RDEPEND}
	$(add_kdeapps_dep kdepimlibs)
"

DOCS=( Changelog README )

S="${WORKDIR}/${PN}"
