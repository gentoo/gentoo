# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic

if [[ ${PV} == "9999" ]] ; then
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
# needs the libgomp library from gcc at runtime
DEPEND="app-arch/xz-utils
	sys-devel/gcc:*[openmp]"
RDEPEND="${DEPEND}"

src_prepare() {
	tc-check-openmp
	tc-export CC
	export BINDIR="${EPREFIX}"/usr/bin
	export MANDIR="${EPREFIX}"/usr/share/man
	default_src_prepare
}
