# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils unpacker

PYVER=3.10
MY_P=pypy3_10-exe-${PV}-1

DESCRIPTION="PyPy3.10 executable (pre-built version)"
HOMEPAGE="https://www.pypy.org/"
SRC_URI="
	elibc_glibc? (
		amd64? (
			https://dev.gentoo.org/~mgorny/binpkg/amd64/pypy/dev-python/pypy3_10-exe/${MY_P}.gpkg.tar
				-> ${MY_P}.amd64.gpkg.tar
		)
		arm64? (
			https://dev.gentoo.org/~mgorny/binpkg/arm64/pypy/dev-python/pypy3_10-exe/${MY_P}.gpkg.tar
				-> ${MY_P}.arm64.gpkg.tar
		)
		ppc64? (
			https://dev.gentoo.org/~mgorny/binpkg/ppc64le/pypy/dev-python/pypy3_10-exe/${MY_P}.gpkg.tar
				-> ${MY_P}.ppc64le.gpkg.tar
		)
		x86? (
			https://dev.gentoo.org/~mgorny/binpkg/x86/pypy/dev-python/pypy3_10-exe/${MY_P}.gpkg.tar
				-> ${MY_P}.x86.gpkg.tar
		)
	)
	elibc_musl? (
		amd64? (
			https://dev.gentoo.org/~mgorny/binpkg/amd64-musl/pypy/dev-python/pypy3_10-exe/${MY_P}.gpkg.tar
				-> ${MY_P}.amd64-musl.gpkg.tar
		)
		arm64? (
			https://dev.gentoo.org/~mgorny/binpkg/arm64-musl/pypy/dev-python/pypy3_10-exe/${MY_P}.gpkg.tar
				-> ${MY_P}.arm64-musl.gpkg.tar
		)
		ppc64? (
			https://dev.gentoo.org/~mgorny/binpkg/ppc64le-musl/pypy/dev-python/pypy3_10-exe/${MY_P}.gpkg.tar
				-> ${MY_P}.ppc64le-musl.gpkg.tar
		)
		x86? (
			https://dev.gentoo.org/~mgorny/binpkg/x86-musl/pypy/dev-python/pypy3_10-exe/${MY_P}.gpkg.tar
				-> ${MY_P}.x86-musl.gpkg.tar
		)
	)
"
S=${WORKDIR}/${MY_P}

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
	!dev-python/pypy3_10-exe:${SLOT}
"

PYPY_PV=${PV%_p*}
QA_PREBUILT="
	usr/bin/pypy${PYVER}-c-${PYPY_PV}
"

src_install() {
	insinto /
	doins -r image/usr
	fperms +x "/usr/bin/pypy${PYVER}-c-${PYPY_PV}"
	pax-mark m "${ED}/usr/bin/pypy${PYVER}-c-${PYPY_PV}"
}
