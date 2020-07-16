# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Icons for use with FVWM"
HOMEPAGE="http://www.fvwm.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2 FVWM"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=x11-wm/fvwm-2.6.2"

S=${WORKDIR}/${PN}

src_install() {
	dodir /usr/share/icons/fvwm
	insinto /usr/share/icons/fvwm
	doins -r .
}
