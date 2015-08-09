# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit eutils python-r1

DESCRIPTION="Configurable and full featured FVWM theme, with lots of transparency and freedesktop compatible menu"
HOMEPAGE="http://fvwm-crystal.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="${PYTHON_DEPS}
	>=x11-wm/fvwm-2.6.5[png]
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	|| ( >=x11-misc/stalonetray-0.6.2-r2 x11-misc/trayer )
	|| ( x11-misc/hsetroot media-gfx/feh )
	sys-apps/sed
	sys-devel/bc
	virtual/awk
	x11-apps/xwd"

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir="/usr/share/doc/${PF}" \
		prefix="/usr" \
		install

	python_replicate_script \
		"${D}/usr/bin/${PN}".{apps,wallpaper} \
		"${D}/usr/share/${PN}"/fvwm/scripts/FvwmMPD/*.py
}

pkg_postinst() {
	einfo
	einfo "After installation, execute following commands:"
	einfo " $ cp -r ${ROOT}usr/share/doc/${PF}/addons/Xresources ~/.Xresources"
	einfo " $ cp -r ${ROOT}usr/share/doc/${PF}/addons/Xsession ~/.xinitrc"
	einfo
	einfo "Many applications can extend functionality of fvwm-crystal."
	einfo "They are listed in ${ROOT}usr/share/doc/${PF}/INSTALL.gz."
	einfo
	einfo "Some icons fixes was committed recently."
	einfo "To archive the same fixes on your private icon files,"
	einfo "please read ${ROOT}usr/share/doc/${PF}/INSTALL.gz."
	einfo "This will fix the libpng warnings at stderr."
	einfo
	einfo "The color themes was updated to Fvwm InfoStore."
	einfo "To know how to update your custom color themes, please run"
	einfo "	${ROOT}usr/share/${PN}/addons/convert_colorsets"
	einfo ""
}
