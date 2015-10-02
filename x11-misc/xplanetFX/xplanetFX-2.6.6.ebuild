# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

DESCRIPTION="User-friendly interface to configure, run or daemonize xplanet with HQ capabilities"
HOMEPAGE="http://mein-neues-blog.de/xplanetFX/"
SRC_URI="http://repository.mein-neues-blog.de:9000/archive/${P/FX/fx}_all.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pygtk[${PYTHON_USEDEP}]
	media-gfx/imagemagick
	sys-devel/bc
	x11-misc/xplanet
	libnotify? ( x11-libs/libnotify )"
#python

S="${WORKDIR}/usr"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.6.4-gentoo-path.patch
	sed -e "s/Application;//" -i share/applications/*desktop || die

	# These will be installed separately
	mkdir gentoo || die
	mv share/${PN}/{autostart,flipview.py,stars/catalog.py,xplanetFX_gtk,xplanetFX_tray} \
		gentoo || die
}

src_install() {
	dobin bin/${PN}
	insinto /usr/share/applications
	doins share/applications/${PN}.desktop
	insinto /usr/share/pixmaps
	doins share/pixmaps/*
	insinto /usr/share/${PN}
	doins -r share/${PN}/*

	exeinto /usr/share/${PN}
	doexe gentoo/autostart

	dodoc share/doc/${PN}/{changelog,README}

	python_scriptinto /usr/share/${PN}/stars
	python_foreach_impl python_doscript gentoo/catalog.py
	python_scriptinto /usr/share/${PN}
	python_foreach_impl python_doscript gentoo/{xplanetFX_gtk,xplanetFX_tray}
	python_foreach_impl python_domodule gentoo/flipview.py
}
