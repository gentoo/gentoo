# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib multilib-minimal toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Cyan4973/lz4.git"
	EGIT_BRANCH=dev
else
	SRC_URI="https://dev.gentoo.org/~ryao/dist/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Extremely Fast Compression algorithm"
HOMEPAGE="https://github.com/Cyan4973/lz4"

LICENSE="BSD-2 GPL-2"
SLOT="0"
IUSE="test"

RDEPEND=""
DEPEND="test? ( dev-util/valgrind )"

src_prepare() {
	multilib_copy_sources
}

multilib_src_compile() {
	tc-export CC AR
	# we must not use the 'all' target since it builds test programs
	# & extra -m32 executables
	emake
	emake -C programs
}

multilib_src_install() {
	emake install DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}"/usr/$(get_libdir)
}
