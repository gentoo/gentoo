# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib prefix toolchain-funcs virtualx

MYP="${PN}${PV}"

DESCRIPTION="Adds a lot of image formats to Tcl/Tk"
HOMEPAGE="http://tkimg.sourceforge.net/"
SRC_URI="
	https://dev.gentoo.org/~jlec/distfiles/${P}-patchset-1.tar.xz
	mirror://sourceforge/${PN}/${PV}/${MYP}.tar.bz2"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc test static-libs"

RDEPEND="
	dev-lang/tk:=
	>=dev-tcltk/tcllib-1.11
	media-libs/tiff:0=
	>=media-libs/libpng-1.6:0=
	>=sys-libs/zlib-1.2.7:=
	x11-libs/libX11
	virtual/jpeg:="
DEPEND="${RDEPEND}
	test? (
		x11-apps/xhost
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )"

# Fails with jpeg-turbo silently, #386253
#RESTRICT="test"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch \
		"${WORKDIR}"/${P}-jpeg.patch \
		"${WORKDIR}"/${P}-tiff.patch \
		"${WORKDIR}"/${P}-png.patch \
		"${FILESDIR}"/${P}-png2.patch \
		"${WORKDIR}"/${P}-zlib.patch

	find compat/{libjpeg,libpng,zlib,libtiff} -delete

	sed \
		-e 's:-O2 -fomit-frame-pointer::g' \
		-e 's: -pipe::g' \
		-i */configure  || die

	eprefixify */*.h
	tc-export AR
}

src_test() {
	Xemake test || die "Xmake failed"
}

src_install() {
	local l bl

	emake \
		DESTDIR="${D}" \
		INSTALL_ROOT="${D}" \
		install

	if ! use static-libs; then
		find "${ED}"/usr/$(get_libdir)/ -type f -name "*\.a" -delete || die
	fi

	# Make library links
	for l in "${ED}"/usr/lib*/Img*/*tcl*.so; do
		bl=$(basename $l)
		dosym Img1.4/${bl} /usr/$(get_libdir)/${bl}
	done

	dodoc ChangeLog README Reorganization.Notes.txt changes ANNOUNCE

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins demo.tcl
		insinto /usr/share/doc/${PF}/html
		doins -r doc/*
	fi
}
