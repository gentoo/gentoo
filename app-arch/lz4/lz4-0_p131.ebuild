# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib multilib-minimal toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Cyan4973/lz4.git"
	EGIT_BRANCH=dev
else
	MY_PV="r${PV##0_p}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://github.com/Cyan4973/lz4/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Extremely Fast Compression algorithm"
HOMEPAGE="https://github.com/Cyan4973/lz4"

LICENSE="BSD-2 GPL-2"
# subslot set to ${PV} because of: https://code.google.com/p/lz4/issues/detail?id=147
SLOT="0/${PV}"
IUSE="test valgrind"

DEPEND="test? ( valgrind? ( dev-util/valgrind ) )"

src_prepare() {
	if ! use valgrind; then
		sed -i -e '/^test:/s|test-mem||g' programs/Makefile || die
	fi
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
