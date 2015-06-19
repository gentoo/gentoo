# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/fhist/fhist-1.19.ebuild,v 1.6 2011/10/07 15:03:15 jlec Exp $

EAPI=4

inherit eutils

DESCRIPTION="File history and comparison tools"
HOMEPAGE="http://fhist.sourceforge.net/fhist.html"
SRC_URI="http://fhist.sourceforge.net/${P}.tar.gz"

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

MAKEOPTS+=" -j1"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-ldflags.patch
}
