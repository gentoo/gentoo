# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999 ]]; then
	MATE_BRANCH=9999
else
	inherit eapi7-ver
	MATE_BRANCH="$(ver_cut 1-2)"
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Meta package for MATE panel applets"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
IUSE="appindicator sensors"

DEPEND=""
RDEPEND="=mate-base/mate-applets-${MATE_BRANCH}*
	appindicator? ( =mate-extra/mate-indicator-applet-${MATE_BRANCH}* )
	sensors? ( =mate-extra/mate-sensors-applet-${MATE_BRANCH}* )
"
