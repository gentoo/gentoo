# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/gnome-video-effects/gnome-video-effects-0.4.1.ebuild,v 1.3 2014/05/04 12:11:32 pacho Exp $

EAPI=5
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Effects for Cheese, the webcam video and picture application"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeVideoEffects"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"
