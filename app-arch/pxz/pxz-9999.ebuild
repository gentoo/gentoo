# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/jnovy/pxz.git"
	inherit git-r3
else
	MY_PV=${PV/_}
	case ${MY_PV} in
	*beta?*) MY_PV="${MY_PV/beta/beta.}git" ;;
	esac
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://jnovy.fedorapeople.org/pxz/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/${MY_P/beta*/beta}
fi

DESCRIPTION="parallel LZMA compressor (no parallel decompression!)"
HOMEPAGE="https://jnovy.fedorapeople.org/pxz/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

# needs the library from xz-utils
DEPEND="app-arch/xz-utils"
RDEPEND="${DEPEND}"

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
