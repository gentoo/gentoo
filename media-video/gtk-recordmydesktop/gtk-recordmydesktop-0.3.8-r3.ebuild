# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1

DESCRIPTION="GTK+ interface for RecordMyDesktop"
HOMEPAGE="http://recordmydesktop.sourceforge.net/"
SRC_URI="mirror://sourceforge/recordmydesktop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
# Test is buggy : bug #186752
# Tries to run intl-toolupdate without it being substituted from
# configure, make test tries run make check in flumotion/test what
# makes me think that this file has been copied from flumotion without
# much care...
RESTRICT=test

RDEPEND=">=x11-libs/gtk+-2.10.0:2
	dev-python/pygtk:2
	>=media-video/recordmydesktop-0.3.5
	x11-apps/xwininfo
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-check-for-jack.patch
}

src_install() {
	emake DESTDIR="${D}" install
	python_fix_shebang "${D}/usr/bin/gtk-recordMyDesktop"
	sed -i 's#gtk-recordmydesktop.png#gtk-recordmydesktop#' "${D}/usr/share/applications/gtk-recordmydesktop.desktop" || die
	dodoc NEWS README AUTHORS ChangeLog
}
