# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/os-autoinst/os-autoinst-9999.ebuild,v 1.6 2013/02/04 15:57:53 scarabeus Exp $

EAPI=4

EGIT_REPO_URI="git://gitorious.org/os-autoinst/os-autoinst.git"

inherit git-2 autotools eutils

DESCRIPTION="automated testing of Operating Systems"
HOMEPAGE="http://os-autoinst.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=media-libs/opencv-2.4
"
RDEPEND="${DEPEND}
	dev-lang/perl[ithreads]
	dev-perl/JSON
	app-emulation/qemu
	app-text/gocr
	media-gfx/imagemagick
	media-video/ffmpeg2theora
"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--disable-static
}

src_install() {
	default
	prune_libtool_files --all
}
