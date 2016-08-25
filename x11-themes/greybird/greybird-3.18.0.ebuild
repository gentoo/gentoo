# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN=${PN/g/G}

DESCRIPTION="The default theme from Xubuntu"
HOMEPAGE="http://shimmerproject.org/project/greybird/ https://github.com/shimmerproject/Greybird"
SRC_URI="https://github.com/shimmerproject/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# README says "dual-licensed as GPLv2 or later and CC-BY-SA 3.0 or later"
LICENSE="CC-BY-SA-3.0 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
# IUSE="ayatana gnome emerald"
IUSE="ayatana gnome"

RDEPEND="
	>=x11-themes/gtk-engines-murrine-0.90
"

RESTRICT="binchecks strip"

S=${WORKDIR}/${MY_PN}-${PV}

src_install() {
	dodoc README
	rm -f README LICENSE*

	insinto /usr/share/themes/${MY_PN}-compact/xfwm4
	doins xfwm4-compact/*
	rm -rf xfwm4-compact

	insinto /usr/share/themes/${MY_PN}-a11y/xfwm4
	doins xfwm4-a11y/*
	rm -rf xfwm4-a11y

	insinto /usr/share/themes/${MY_PN}-bright/xfce-notify-4.0
	doins xfce-notify-4.0_bright/*
	rm -rf xfce-notify-4.0_bright

	use ayatana || rm -rf unity
	use gnome || rm -rf metacity-1

	insinto /usr/share/themes/${MY_PN}
	doins -r *
}
