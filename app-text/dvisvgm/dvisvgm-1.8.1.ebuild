# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/dvisvgm/dvisvgm-1.8.1.ebuild,v 1.9 2015/08/04 11:55:24 zlogene Exp $

EAPI=4

DESCRIPTION="Converts DVI files to SVG"
HOMEPAGE="http://dvisvgm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"
# Tests don't work from $WORKDIR: kpathsea tries to search in relative
# directories from where the binary is executed.
# We cannot really use absolute paths in the kpathsea configuration since that
# would make it harder for prefix installs.
RESTRICT="test"

RDEPEND="virtual/tex-base
	app-text/ghostscript-gpl
	>=media-gfx/potrace-1.10-r1
	media-libs/freetype:2
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-cpp/gtest )"
