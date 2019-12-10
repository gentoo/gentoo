# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P=GlimmerHMM

DESCRIPTION="A eukaryotic gene finding system from TIGR"
HOMEPAGE="http://www.cbcb.umd.edu/software/GlimmerHMM/"
SRC_URI="ftp://ftp.cbcb.umd.edu/pub/software/glimmerhmm/${MY_P}-${PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PV}-gentoo.patch
	"${FILESDIR}"/${PN}-3.0.1-fix-data-path.patch
)

src_configure() {
	tc-export CC CXX
}

src_compile() {
	emake -C sources
	emake -C train
}

src_install() {
	dobin sources/glimmerhmm train/trainGlimmerHMM

	insinto /usr/share/${PN}/lib
	doins train/*.pm

	insinto /usr/share/${PN}/models
	doins -r trained_dir/.

	exeinto /usr/libexec/${PN}/training_utils
	doexe train/{build{1,2,-icm,-icm-noframe},erfapp,falsecomp,findsites,karlin,score,score{2,ATG,ATG2,STOP,STOP2},splicescore}

	dodoc README.first train/readme.train
}
