# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="High performance base64 encoder and decoder"
HOMEPAGE="https://github.com/skeeto/race64"
SRC_URI="https://github.com/skeeto/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="openmp"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_compile() {
	use openmp && append-flags -fopenmp
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -o ${PN} ${PN}.c || die
}

src_test() {
	./test.sh || die 'test failed'
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
