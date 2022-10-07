# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="The protein secondary structure standard"
HOMEPAGE="https://swift.cmbi.umcn.nl/gv/dssp/"
SRC_URI="ftp://ftp.cmbi.ru.nl/pub/molbio/software/dssp-2/${P}.tgz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/boost:=[bzip2,zlib]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-gentoo.patch
	"${FILESDIR}"/${PN}-2.2.1-boost-1.65-tr1-removal.patch
)

src_configure() {
	tc-export CXX

	cat >> make.config <<- EOF || die
		BOOST_LIB_DIR = "${EPREFIX}/usr/$(get_libdir)"
		BOOST_INC_DIR = "${EPREFIX}/usr/include"
	EOF
}

src_install() {
	dobin mkdssp
	dosym mkdssp /usr/bin/dssp
	doman doc/mkdssp.1
	dodoc README.txt changelog

	doenvd "${FILESDIR}"/30-${PN}
}
