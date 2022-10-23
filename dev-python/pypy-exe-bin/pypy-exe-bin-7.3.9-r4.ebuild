# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils unpacker

MY_P=pypy-exe-${PV}
DESCRIPTION="PyPy executable (pre-built version)"
HOMEPAGE="https://www.pypy.org/"
SRC_URI="
	elibc_glibc? (
		amd64? (
			https://dev.gentoo.org/~mgorny/binpkg/amd64/pypy/dev-python/pypy-exe/${MY_P}-3.gpkg.tar
				-> ${MY_P}-3.amd64.gpkg.tar
		)
		arm64? (
			https://dev.gentoo.org/~mgorny/binpkg/arm64/pypy/dev-python/pypy-exe/${MY_P}-2.gpkg.tar
				-> ${MY_P}-2.arm64.gpkg.tar
		)
		ppc64? (
			https://dev.gentoo.org/~mgorny/binpkg/ppc64le/pypy/dev-python/pypy-exe/${MY_P}-2.gpkg.tar
				-> ${MY_P}-2.ppc64le.gpkg.tar
		)
		x86? (
			https://dev.gentoo.org/~mgorny/binpkg/x86/pypy/dev-python/pypy-exe/${MY_P}-3.gpkg.tar
				-> ${MY_P}-3.x86.gpkg.tar
		)
	)
	elibc_musl? (
		amd64? (
			https://dev.gentoo.org/~mgorny/binpkg/amd64-musl/pypy/dev-python/pypy-exe/${MY_P}-2.gpkg.tar
				-> ${MY_P}-2.amd64-musl.gpkg.tar
		)
		arm64? (
			https://dev.gentoo.org/~mgorny/binpkg/arm64-musl/pypy/dev-python/pypy-exe/${MY_P}-2.gpkg.tar
				-> ${MY_P}-2.arm64-musl.gpkg.tar
		)
		ppc64? (
			https://dev.gentoo.org/~mgorny/binpkg/ppc64le-musl/pypy/dev-python/pypy-exe/${MY_P}-2.gpkg.tar
				-> ${MY_P}-2.ppc64le-musl.gpkg.tar
		)
		x86? (
			https://dev.gentoo.org/~mgorny/binpkg/x86-musl/pypy/dev-python/pypy-exe/${MY_P}-2.gpkg.tar
				-> ${MY_P}-2.x86-musl.gpkg.tar
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
	>=sys-libs/zlib-1.1.3:0/1
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
