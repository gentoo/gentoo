# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/mate-backgrounds/mate-backgrounds-1.8.0.ebuild,v 1.5 2014/10/26 04:19:32 leio Exp $

EAPI="5"

GCONF_DEBUG="no"

inherit gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="A set of backgrounds packaged with the MATE desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

DEPEND=">=dev-util/intltool-0.35:*
	sys-devel/gettext:*"

DOCS="AUTHORS ChangeLog NEWS README"
