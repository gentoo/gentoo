# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic

DESCRIPTION="Delta compression suite for using/generating binary patches"
HOMEPAGE="https://diffball.googlecode.com/"
SRC_URI="https://diffball.googlecode.com/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ppc ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug"

RDEPEND=">=sys-libs/zlib-1.1.4
	>=app-arch/bzip2-1.0.2
	app-arch/xz-utils"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

# Invalid RESTRICT for source package. Investigate.
RESTRICT="strip"

src_prepare() {
	# fix bug 548316 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89
	default
}

src_configure() {
	econf $(use_enable debug asserts)
}
