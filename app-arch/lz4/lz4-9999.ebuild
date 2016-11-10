# Copyright 1999-2016 Gentoo Foundation
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
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Extremely Fast Compression algorithm"
HOMEPAGE="https://github.com/Cyan4973/lz4"

LICENSE="BSD-2 GPL-2"
# Upstream has trouble keeping ABI stable, so please test new versions
# with abi-compliance-checker and update the subslot every time ABI
# changes. This is the least we can do to keep things sane.
SLOT="0/r131"
IUSE="static-libs test valgrind"

DEPEND="test? ( valgrind? ( dev-util/valgrind ) )"

src_prepare() {
	if ! use valgrind; then
		sed -i -e '/^test:/s|test-mem||g' programs/Makefile || die
	fi
	epatch "${FILESDIR}"/${PN}-0_p131-static-libs.patch
	multilib_copy_sources
}

lmake() {
	emake \
		BUILD_STATIC=$(usex static-libs) \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}"/usr/$(get_libdir) \
		"$@"
}

multilib_src_compile() {
	tc-export CC AR
	# we must not use the 'all' target since it builds test programs
	# & extra -m32 executables
	lmake -C lib liblz4 liblz4.pc
	lmake -C programs lz4 lz4c
	# work around lack of proper target dependencies
	touch lib/liblz4
}

multilib_src_test() {
	lmake -j1 test
}

multilib_src_install() {
	lmake install DESTDIR="${D}"
}
