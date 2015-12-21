# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="File history and comparison tools"
HOMEPAGE="http://fhist.sourceforge.net/fhist.html"
SRC_URI="http://fhist.sourceforge.net/${P}.D001.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-linux"
IUSE="test"

RDEPEND="
	dev-libs/libexplain
	sys-devel/gettext
	sys-apps/groff"
DEPEND="${RDEPEND}
	sys-devel/bison
	test? ( app-arch/sharutils )"

src_prepare() {
	MAKEOPTS+=" -j1"
	epatch "${FILESDIR}"/${P}-ldflags.patch
	append-cflags -fgnu89-inline
}
