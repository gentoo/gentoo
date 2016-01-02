# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic

DESCRIPTION="An instrument editor for gig files"
HOMEPAGE="http://www.linuxsampler.org/"
SRC_URI="http://download.linuxsampler.org/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-cpp/gtkmm:2.4
	>=media-libs/libgig-3.3.0
	>=media-libs/libsndfile-1.0.2
	>=media-sound/linuxsampler-0.5.1"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig"

src_prepare() {
	# Fix linking, bug #540674
	sed -i -e 's/@LIBS@/@LIBS@ -lsigc-2.0/g' src/gigedit/Makefile.in
	eautoreconf
}

src_configure() {
	append-cxxflags -std=c++11
	econf --disable-static
}

src_compile() {
	# fails with parallel jobs
	emake -j1
}

src_install() {
	default
	prune_libtool_files --modules
}
