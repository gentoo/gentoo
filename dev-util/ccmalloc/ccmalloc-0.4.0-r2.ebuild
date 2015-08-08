# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="A easy-to-use memory debugging library"
HOMEPAGE="http://www.inf.ethz.ch/personal/biere/projects/ccmalloc/"
SRC_URI="http://www.inf.ethz.ch/personal/biere/projects/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"
DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Respect CFLAGS #240274
	sed -i \
		-e "s/CFLAGS=/CFLAGS+=/" \
		Makefile.in || die "sed in Makefile.in failed"
}

src_compile() {
	tc-export CC
	local myconf
	use debug && myconf="${myconf} --debug"
	# Not a standard configure script.
	./configure --prefix=/usr ${myconf} || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	emake PREFIX="${D}"/usr install || die "emake install failed"
	dodoc BUGS FEATURES NEWS README TODO USAGE VERSION || die "dodoc failed"
}
