# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils

DESCRIPTION="Library for emulating CAC cards"
HOMEPAGE="http://spice-space.org/"
SRC_URI="http://spice-space.org/download/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="static-libs"

RDEPEND=">=dev-libs/nss-3.13
	>=sys-apps/pcsc-lite-1.8"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
PATCHES=(
	"${FILESDIR}/${P}-underlinking.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# --enable-passthru works only on W$
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files --all
}
