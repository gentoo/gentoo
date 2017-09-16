# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="The protein secondary structure standard"
HOMEPAGE="http://swift.cmbi.ru.nl/gv/dssp/"
SRC_URI="ftp://ftp.cmbi.ru.nl/pub/molbio/software/dssp-2/${P}.tgz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/boost:=[threads]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-gentoo.patch
	"${FILESDIR}"/${PN}-2.2.1-boost-1.65-tr1-removal.patch
)

src_configure() {
	tc-export CXX

	cat >> make.config <<- EOF || die
		BOOST_LIB_SUFFIX = -mt
		BOOST_LIB_DIR = "${EPREFIX}/usr/$(get_libdir)"
		BOOST_INC_DIR = "${EPREFIX}/usr/include"
	EOF
}

src_install() {
	dobin mkdssp
	dosym mkdssp /usr/bin/dssp
	doman doc/mkdssp.1
	dodoc README.txt changelog

	cat >> "${T}"/30-${PN} <<- EOF || die
		DSSP="${EPREFIX}"/usr/bin/${PN}
	EOF
	doenvd "${T}"/30-${PN}
}
