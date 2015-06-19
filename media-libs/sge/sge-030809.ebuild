# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sge/sge-030809.ebuild,v 1.13 2015/02/19 09:21:35 mr_bones_ Exp $

EAPI=5
inherit eutils multilib toolchain-funcs

MY_P="sge${PV}"
DESCRIPTION="Graphics extensions library for SDL"
HOMEPAGE="http://www.etek.chalmers.se/~e8cal1/sge/"
SRC_URI="http://www.etek.chalmers.se/~e8cal1/sge/files/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86 ~x86-fbsd"
IUSE="doc examples image truetype"

DEPEND="media-libs/libsdl
	image? ( media-libs/sdl-image )
	truetype? ( >=media-libs/freetype-2 )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-freetype.patch \
		"${FILESDIR}"/${P}-cmap.patch
	sed -i "s:\$(PREFIX)/lib:\$(PREFIX)/$(get_libdir):" Makefile || die
	sed -i \
		-e '/^CC=/d' \
		-e '/^CXX=/d' \
		-e '/^AR=/d' \
		Makefile.conf || die
	tc-export CC CXX AR
	# make sure the header gets regenerated everytime
	rm -f sge_config.h
}

src_compile() {
	emake \
		USE_IMG=$(usex image y n) \
		USE_FT=$(usex truetype y n)
}

src_install() {
	DOCS="README Todo WhatsNew" \
		default

	use doc && dohtml docs/*

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
