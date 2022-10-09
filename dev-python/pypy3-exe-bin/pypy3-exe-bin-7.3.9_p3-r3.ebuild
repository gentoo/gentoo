# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pax-utils

MY_P=pypy3-exe-${PV}-1
DESCRIPTION="PyPy3 executable (pre-built version)"
HOMEPAGE="https://www.pypy.org/"
SRC_URI="
	elibc_glibc? (
		amd64? (
			https://dev.gentoo.org/~mgorny/binpkg/amd64/pypy/dev-python/pypy3-exe/${MY_P}.xpak
				-> ${MY_P}.amd64.xpak
		)
		arm64? (
			https://dev.gentoo.org/~mgorny/binpkg/arm64/pypy/dev-python/pypy3-exe/${MY_P}.xpak
				-> ${MY_P}.arm64.xpak
		)
		ppc64? (
			https://dev.gentoo.org/~mgorny/binpkg/ppc64le/pypy/dev-python/pypy3-exe/${MY_P}.xpak
				-> ${MY_P}.ppc64le.xpak
		)
		x86? (
			https://dev.gentoo.org/~mgorny/binpkg/x86/pypy/dev-python/pypy3-exe/${MY_P}.xpak
				-> ${MY_P}.x86.xpak
		)
	)
	elibc_musl? (
		amd64? (
			https://dev.gentoo.org/~mgorny/binpkg/amd64-musl/pypy/dev-python/pypy3-exe/${MY_P}.xpak
				-> ${MY_P}.amd64-musl.xpak
		)
		arm64? (
			https://dev.gentoo.org/~mgorny/binpkg/arm64-musl/pypy/dev-python/pypy3-exe/${MY_P}.xpak
				-> ${MY_P}.arm64-musl.xpak
		)
		ppc64? (
			https://dev.gentoo.org/~mgorny/binpkg/ppc64le-musl/pypy/dev-python/pypy3-exe/${MY_P}.xpak
				-> ${MY_P}.ppc64le-musl.xpak
		)
		x86? (
			https://dev.gentoo.org/~mgorny/binpkg/x86-musl/pypy/dev-python/pypy3-exe/${MY_P}.xpak
				-> ${MY_P}.x86-musl.xpak
		)
	)
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="3.9-${PV%_p*}"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"

# sys-devel/gcc for libgcc_s.so
RDEPEND="
	app-arch/bzip2:0/1
	dev-libs/expat:0/0
	dev-libs/libffi:0/8
	sys-devel/gcc
	sys-libs/ncurses:0/6
	>=sys-libs/zlib-1.1.3:0/1
	virtual/libintl:0/0
	elibc_glibc? ( >=sys-libs/glibc-2.35 )
	!dev-python/pypy3-exe:${SLOT}
"

PYPY_PV=${PV%_p*}
QA_PREBUILT="
	usr/bin/pypy3.9-c-${PYPY_PV}
"

src_unpack() {
	if [[ -z ${A} ]]; then
		die "No binary package available for ${ARCH}/${ELIBC}"
	fi

	ebegin "Unpacking ${A}"
	tar -x < <(xz -c -d --single-stream "${DISTDIR}/${A}")
	eend ${?} || die "Unpacking ${A} failed"
}

src_install() {
	insinto /
	doins -r usr
	fperms +x "/usr/bin/pypy3.9-c-${PYPY_PV}"
	pax-mark m "${ED}/usr/bin/pypy3.9-c-${PYPY_PV}"
}
