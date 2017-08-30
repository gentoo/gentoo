# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="Effects for Cheese, the webcam video and picture application"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeVideoEffects"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"
