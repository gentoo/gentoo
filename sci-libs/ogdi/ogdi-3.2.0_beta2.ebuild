# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P=${P/_/.}
inherit eutils toolchain-funcs

DESCRIPTION="Open Geographical Datastore Interface, a GIS support library"
HOMEPAGE="http://ogdi.sourceforge.net/"
SRC_URI="mirror://sourceforge/ogdi/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="
	dev-libs/expat
	>=sci-libs/proj-4.8.0
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	rm -rf external
	epatch \
		"${FILESDIR}"/${P}-subdirs.patch \
		"${FILESDIR}"/${P}-endianess.patch \
		"${FILESDIR}"/${P}-64b.patch \
		"${FILESDIR}"/${P}-proj480.patch \
		"${FILESDIR}"/${PN}-3.1.6-fpic.patch
	sed 's:O2:O9:g' -i configure || die
}

src_configure() {
	export TOPDIR="${S}"
	export TARGET=$(uname)
	export CFG="release"
	export LD_LIBRARY_PATH=$TOPDIR/bin/${TARGET}

	econf \
		--with-projlib="-L${EPREFIX}/usr/$(get_libdir) -lproj" \
		--with-zlib --with-expat
}

src_compile() {
	# bug #299239
	emake -j1 \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		SHLIB_LD="$(tc-getCC)"
}

src_install() {
	mv "${S}"/bin/${TARGET}/*.so* "${S}"/lib/Linux/. || die "lib move failed"
	dobin "${S}"/bin/${TARGET}/*
	insinto /usr/include
	doins ogdi/include/ecs.h ogdi/include/ecs_util.h
	dolib.so lib/${TARGET}/lib*
	use static-libs && dolib.a lib/${TARGET}/static/*.a
#	dosym libogdi31.so /usr/$(get_libdir)/libogdi.so || die "symlink failed"
	dodoc ChangeLog NEWS README
}
