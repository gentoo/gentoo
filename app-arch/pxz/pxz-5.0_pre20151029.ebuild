# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs vcs-snapshot

DESCRIPTION="Parallel implementation of the XZ compression utility"
HOMEPAGE="http://jnovy.fedorapeople.org/pxz/"
SRC_URI="https://github.com/jnovy/pxz/archive/fcfea93957d96b7661d1439cf4b767ecfd341eed.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86 ~amd64-linux"
IUSE=""

# needs the library from xz-utils
# needs the libgomp library from gcc at runtime
RDEPEND="app-arch/xz-utils
	sys-devel/gcc:*[openmp]"
DEPEND="${RDEPEND}"

src_prepare() {
	tc-check-openmp
	tc-export CC
	export BINDIR="${EPREFIX}"/usr/bin
	export MANDIR="${EPREFIX}"/usr/share/man
	default_src_prepare
}
