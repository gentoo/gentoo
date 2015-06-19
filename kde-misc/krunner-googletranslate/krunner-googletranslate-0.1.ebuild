# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/krunner-googletranslate/krunner-googletranslate-0.1.ebuild,v 1.1 2013/06/18 01:22:57 creffett Exp $

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
	$(add_kdebase_dep libkworkspace)
	dev-libs/qjson
"
DEPEND="
	${RDEPEND}
	$(add_kdebase_dep kdepimlibs)
"

DOCS=( Changelog README )

S="${WORKDIR}/${PN}"
