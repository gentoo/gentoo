# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

MY_P=Togl${PV}

DESCRIPTION="A Tk widget for OpenGL rendering"
HOMEPAGE="http://togl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug +threads"

RDEPEND="
	dev-lang/tk
	virtual/opengl
	x11-libs/libXmu"
DEPEND="${RDEPEND}"

# tests directory is missing
RESTRICT="test"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed \
		-e 's:-fomit-frame-pointer::g' \
		-e 's:-O2::g' \
		-e 's:-pipe::g' \
		-i configure || die
}

src_configure() {
	econf \
		$(use_enable debug symbols) \
		$(use_enable threads)
}

src_install() {
	emake DESTDIR="${D}" install
	dohtml doc/*
	dodoc README*
}
