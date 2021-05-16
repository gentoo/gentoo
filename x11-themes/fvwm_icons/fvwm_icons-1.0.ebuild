# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Icons for use with FVWM"
HOMEPAGE="https://www.fvwm.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2 FVWM"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND=">=x11-wm/fvwm-2.6.2"

src_install() {
	insinto /usr/share/icons/fvwm
	doins -r .
}
