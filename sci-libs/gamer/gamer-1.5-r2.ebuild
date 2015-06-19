# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/gamer/gamer-1.5-r2.ebuild,v 1.5 2015/04/19 09:31:51 pacho Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils multilib

DESCRIPTION="Geometry-preserving Adaptive MeshER"
HOMEPAGE="http://fetk.org/codes/gamer/index.html"
SRC_URI="http://www.fetk.org/codes/download/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE="doc static-libs"

RDEPEND=">=dev-libs/maloc-1.4"
DEPEND="
	${RDEPEND}
	doc? (
		media-gfx/graphviz
		app-doc/doxygen
		)"

S="${WORKDIR}"/${PN}

PATCHES=(
	"${FILESDIR}"/1.4-multilib.patch
	"${FILESDIR}"/1.4-doc.patch
	)

src_configure() {
	local fetk_include
	local fetk_lib
	local myeconfargs

	use doc || myeconfargs+=( ${myconf} --with-doxygen= --with-dot= )

	fetk_include="${EPREFIX}"/usr/include
	fetk_lib="${EPREFIX}"/usr/$(get_libdir)
	export FETK_INCLUDE="${fetk_include}"
	export FETK_LIBRARY="${fetk_lib}"

	myeconfargs+=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--disable-triplet
		)
	autotools-utils_src_configure
}
