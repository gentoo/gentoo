# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs prefix vcs-snapshot

PXZ_COMMIT="136e5c25daf545753329d7cee1b06ae482fb9c44"
DESCRIPTION="Parallel implementation of the XZ compression utility"
HOMEPAGE="https://jnovy.fedorapeople.org/pxz/"
SRC_URI="https://github.com/jnovy/pxz/archive/${PXZ_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86 ~amd64-linux"

# Needs the library from xz-utils
RDEPEND="app-arch/xz-utils"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.0_pre20220509-fix-xz-path.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

src_prepare() {
	default

	# bug #887255
	eprefixify pxz.c

	if use elibc_musl ; then
		sed -i -e '/<error.h>/c\#define error(R,E,S,...) fprintf(stderr, S "\\n", ##__VA_ARGS__); exit(R)' pxz.c || die
	fi
}

src_configure() {
	tc-export CC
	export BINDIR="${EPREFIX}"/usr/bin
	export MANDIR="${EPREFIX}"/usr/share/man
}
