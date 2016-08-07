# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Gallery generator"
HOMEPAGE="http://furius.ca/curator/"
SRC_URI="mirror://gentoo/curator-3.0_pf078f1686a78.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pillow[${PYTHON_USEDEP}]
	|| ( >=media-gfx/imagemagick-5.4.9 media-gfx/graphicsmagick[imagemagick-compat] )"

S="${WORKDIR}/curator-3.0_pf078f1686a78"

src_install() {
	distutils-r1_src_install

	dobin hs/curator-hs
	insinto /usr/share/curator/hs
	doins -r hs/*
}
