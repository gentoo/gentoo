# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="Live Source Client For IceCast"
HOMEPAGE="http://star.arm.ac.uk/~spm/software/liveice.html"
SRC_URI="http://star.arm.ac.uk/~spm/software/liveice.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="media-sound/lame
	media-sound/mpg123"
DEPEND=""

S=${WORKDIR}/${PN}

src_prepare() {
	# cannot use LDFLAGS directly as the Makefile uses it for LIBS
	sed -i Makefile.in \
		-e 's|-o liveice|$(LLFLAGS) &|' \
		|| die "sed Makefile.in"
	tc-export CC
}

src_compile() {
	emake LLFLAGS="${LDFLAGS}" || die
}
src_install() {
	dobin liveice || die
	dodoc liveice.cfg README.liveice README.quickstart README_new_mixer.txt Changes.txt
}
