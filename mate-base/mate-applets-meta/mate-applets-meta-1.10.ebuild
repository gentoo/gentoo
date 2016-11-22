# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

DESCRIPTION="Meta package for MATE panel applets"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="appindicator sensors"

DEPEND=""
RDEPEND=" =mate-base/mate-applets-${MATE_BRANCH}*
	appindicator? ( =mate-extra/mate-indicator-applet-${MATE_BRANCH}* )
	sensors? ( =mate-extra/mate-sensors-applet-${MATE_BRANCH}* )
"
