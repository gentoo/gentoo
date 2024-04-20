# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P=GlimmerHMM

DESCRIPTION="A eukaryotic gene finding system from TIGR"
HOMEPAGE="http://www.cbcb.umd.edu/software/GlimmerHMM/"
SRC_URI="https://ccb.jhu.edu/software/glimmerhmm/dl/${MY_P}-${PV}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PV}-gentoo.patch
	"${FILESDIR}"/${PN}-3.0.1-fix-data-path.patch
	"${FILESDIR}"/0001-fix-ridiculous-ODR-violation.patch
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
