# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/jjwhitney/BDelta.git"
	UNPACKER_ECLASS="git-2"
	LIVE_EBUILD=yes
else
	UNPACKER_ECLASS="vcs-snapshot"
fi

inherit toolchain-funcs ${UNPACKER_ECLASS}

if [[ -z ${LIVE_EBUILD} ]]; then
	KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-linux"
	SRC_URI="https://github.com/jjwhitney/BDelta/tarball/v${PV} -> ${P}.tar.gz"
fi

DESCRIPTION="Binary Delta - Efficient difference algorithm and format"
HOMEPAGE="https://github.com/jjwhitney/BDelta"

SLOT="0"
LICENSE="MPL-2.0"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-soname.patch
	"${FILESDIR}"/${P}-gcc-6.patch
)

src_compile() {
	emake -C src \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	emake -C src install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	dodoc README
}
