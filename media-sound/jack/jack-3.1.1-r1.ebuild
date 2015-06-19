# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jack/jack-3.1.1-r1.ebuild,v 1.6 2013/03/31 09:57:43 ago Exp $

EAPI="3"
PYTHON_DEPEND="2"

inherit eutils distutils

DESCRIPTION="A frontend for several cd-rippers and mp3 encoders"
HOMEPAGE="http://www.home.unix-ag.org/arne/jack/"
SRC_URI="http://www.home.unix-ag.org/arne/jack/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}
	dev-python/cddb-py
	dev-python/id3-py
	dev-python/pyid3lib
	dev-python/pyvorbis
	media-libs/flac
	media-sound/lame
	media-sound/cdparanoia"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.0.0-python26.patch
}

src_install() {
	distutils_src_install

	dobin jack || die "dobin failed"

	insinto $(python_get_sitedir)
	PYTHON_MODNAME="$(ls jack_*.py)"
	doins ${PYTHON_MODNAME}

	newman jack.man jack.1

	dodoc README doc/ChangeLog doc/TODO

	dohtml doc/*html doc/*css doc/*gif
}
