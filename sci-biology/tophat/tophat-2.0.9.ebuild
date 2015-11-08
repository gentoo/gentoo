# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
	~sci-biology/seqan-1.3.1"
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
