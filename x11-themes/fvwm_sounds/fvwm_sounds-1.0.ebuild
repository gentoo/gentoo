# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sounds for use with FVWM"
HOMEPAGE="http://www.fvwm.org/"
SRC_URI="http://www.fvwm.org/generated/sounds_download/fvwm_sounds.tgz"

LICENSE="GPL-2 FVWM"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=x11-wm/fvwm-2.6.2"

S=${WORKDIR}

src_install() {
	dodir /usr/share/sounds/fvwm
	insinto /usr/share/sounds/fvwm
	doins -r .
}
