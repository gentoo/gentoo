# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple bash driven frontend to simplify decompression of files"
HOMEPAGE="https://github.com/jlec/unfoo"
SRC_URI="https://github.com/jlec/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~s390 x86 ~amd64-linux ~x86-linux"
IUSE="+minimal test"
RESTRICT="!test? ( test )"

COMMON_DEPS="
	app-alternatives/bzip2
	app-alternatives/gzip
	app-arch/p7zip
	|| (
		app-arch/rar
		app-arch/unrar
	)
	app-arch/unace
	app-arch/unzip
	app-arch/xz-utils"
RDEPEND="!minimal? ( ${COMMON_DEPS} )"
DEPEND="test? ( ${COMMON_DEPS} )"

src_compile() { :; }

src_install() {
	dodoc README*
	dobin ${PN}
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		echo
		elog "unfoo can handle far more than just .tar*, but it requires some"
		elog "optional packages to do so. For a list, either consult the source"
		elog "(less /usr/bin/unfoo), or see http://obsoleet.org/code/unfoo"
		elog "To get full support please use USE=-minimal"
	fi
}
