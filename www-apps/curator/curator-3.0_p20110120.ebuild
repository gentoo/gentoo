# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/curator/curator-3.0_p20110120.ebuild,v 1.7 2013/06/09 19:02:17 floppym Exp $

EAPI=4

PYTHON_DEPEND="2"

inherit python

DESCRIPTION="Gallery generator"
HOMEPAGE="http://furius.ca/curator/"
SRC_URI="mirror://gentoo/curator-3.0_pf078f1686a78.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ppc x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	virtual/python-imaging
	|| ( >=media-gfx/imagemagick-5.4.9 media-gfx/graphicsmagick[imagemagick] )"

S="${WORKDIR}/curator-3.0_pf078f1686a78"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}
src_compile() {
	:
}

src_install() {
	dobin hs/curator-hs
	insinto /usr/share/curator/hs
	doins -r hs/*
}
