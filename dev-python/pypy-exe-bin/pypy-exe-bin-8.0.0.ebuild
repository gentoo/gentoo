# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils unpacker

MY_P=pypy-exe-${PV}-1
DESCRIPTION="PyPy executable (pre-built version)"
HOMEPAGE="
	https://pypy.org/
	https://github.com/pypy/pypy/
"
SRC_URI="
	elibc_glibc? (
		amd64? (
			https://distfiles.gentoo.org/pub/proj/python/binpkg/amd64/pypy-exe/${MY_P}.amd64.gpkg.tar
		)
		arm64? (
			https://distfiles.gentoo.org/pub/proj/python/binpkg/arm64/pypy-exe/${MY_P}.arm64.gpkg.tar
		)
		ppc64? (
			https://distfiles.gentoo.org/pub/proj/python/binpkg/ppc64le/pypy-exe/${MY_P}.ppc64le.gpkg.tar
		)
		x86? (
			https://distfiles.gentoo.org/pub/proj/python/binpkg/x86/pypy-exe/${MY_P}.x86.gpkg.tar
		)
	)
	elibc_musl? (
		amd64? (
			https://distfiles.gentoo.org/pub/proj/python/binpkg/amd64-musl/pypy-exe/${MY_P}.amd64-musl.gpkg.tar
		)
		arm64? (
			https://distfiles.gentoo.org/pub/proj/python/binpkg/arm64-musl/pypy-exe/${MY_P}.arm64-musl.gpkg.tar
		)
		ppc64? (
			https://distfiles.gentoo.org/pub/proj/python/binpkg/ppc64le-musl/pypy-exe/${MY_P}.ppc64le-musl.gpkg.tar
		)
		x86? (
			https://distfiles.gentoo.org/pub/proj/python/binpkg/x86-musl/pypy-exe/${MY_P}.x86-musl.gpkg.tar
		)
	)
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="${PV%_p*}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

# sys-devel/gcc for libgcc_s.so
RDEPEND="
	app-arch/bzip2:0/1
	dev-libs/expat:0/0
	dev-libs/libffi:0/8
	sys-libs/ncurses:0/6
	>=virtual/zlib-1.1.3:0/1
	virtual/libintl:0/0
	elibc_glibc? (
		sys-devel/gcc
		>=sys-libs/glibc-2.35
	)
	!dev-python/pypy-exe:${SLOT}
"

QA_PREBUILT="
	usr/lib/pypy2.7/pypy-c-${SLOT}
"

src_install() {
	insinto /
	doins -r */image/usr
	fperms +x "/usr/lib/pypy2.7/pypy-c-${SLOT}"
	pax-mark m "${ED}/usr/lib/pypy2.7/pypy-c-${SLOT}"
}
