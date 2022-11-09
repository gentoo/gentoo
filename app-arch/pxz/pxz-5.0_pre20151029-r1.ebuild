# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs vcs-snapshot

DESCRIPTION="Parallel implementation of the XZ compression utility"
HOMEPAGE="http://jnovy.fedorapeople.org/pxz/"
SRC_URI="https://github.com/jnovy/pxz/archive/fcfea93957d96b7661d1439cf4b767ecfd341eed.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86 ~amd64-linux"

# needs the library from xz-utils
RDEPEND="app-arch/xz-utils"
DEPEND="${RDEPEND}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

src_prepare() {
	default

	if use elibc_musl ; then
		sed -i -e '/<error.h>/c\#define error(R,E,S,...) fprintf(stderr, S "\\n", ##__VA_ARGS__); exit(R)' pxz.c || die
	fi
}

src_configure() {
	tc-export CC
	export BINDIR="${EPREFIX}"/usr/bin
	export MANDIR="${EPREFIX}"/usr/share/man
}
