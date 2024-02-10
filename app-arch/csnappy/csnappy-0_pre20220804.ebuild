# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_COMMIT="6c10c305e8dde193546e6b33cf8a785d5dc123e2"

DESCRIPTION="Google's snappy compression library for the Linux Kernel"
HOMEPAGE="https://github.com/zeevt/csnappy"
SRC_URI="https://github.com/zeevt/csnappy/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_COMMIT}

# https://github.com/zeevt/csnappy/issues/21
LICENSE="BSD"
# 0/${PV} b/c of the SONAME situation (see below).
SLOT="0/${PV}"
KEYWORDS="amd64 ~ia64 ppc ppc64 sparc x86"

# https://github.com/zeevt/csnappy/issues/33
# No SONAME yet.
QA_SONAME="usr/lib.*/libcsnappy.so"

PATCHES=(
	"${FILESDIR}"/${PN}-0_pre20220804-fix-tests.patch
)

src_compile() {
	emake CC="$(tc-getCC)" OPT_FLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		libcsnappy.so
}

src_test() {
	# We don't want to run the Valgrind tests as it's fragile in sandbox
	# and makes life harder for some arches.
	emake CC="$(tc-getCC)" OPT_FLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		check_unaligned_uint64 \
		cl_test
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install
}
