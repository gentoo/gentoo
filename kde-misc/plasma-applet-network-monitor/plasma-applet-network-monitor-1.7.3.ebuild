# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Plasma 5 applet for monitoring active network connections"
HOMEPAGE="http://kde-look.org/content/show.php/Network+Monitor?content=169377
https://github.com/kotelnik/plasma-applet-network-monitor"

if [[ ${KDE_BUILD_TYPE} = live ]] ; then
	EGIT_REPO_URI="https://github.com/kotelnik/${PN}.git"
else
	SRC_URI="https://github.com/kotelnik/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep plasma)
"
RDEPEND="${DEPEND}"

DOCS=( README.md )
