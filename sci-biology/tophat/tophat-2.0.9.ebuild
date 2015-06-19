# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/tophat/tophat-2.0.9.ebuild,v 1.1 2014/03/06 09:46:50 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes
PYTHON_COMPAT=( python2_7 )

inherit autotools-utils python-single-r1

DESCRIPTION="A fast splice junction mapper for RNA-Seq reads"
HOMEPAGE="http://tophat.cbcb.umd.edu/"
SRC_URI="http://tophat.cbcb.umd.edu/downloads/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	dev-libs/boost
	sci-biology/samtools
	sci-biology/seqan"
RDEPEND="${DEPEND}
	sci-biology/bowtie"

PATCHES=( "${FILESDIR}"/${P}-flags.patch )

src_prepare() {
	rm -rf src/SeqAn* || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-optim
		$(use_enable debug)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	python_fix_shebang "${ED}"/usr/bin/tophat
}
