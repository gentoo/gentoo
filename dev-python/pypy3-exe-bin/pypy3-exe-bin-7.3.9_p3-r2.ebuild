# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pax-utils

MY_P=pypy3-exe-${PV}-1
DESCRIPTION="PyPy3 executable (pre-built version)"
HOMEPAGE="https://www.pypy.org/"
SRC_URI="
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
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="3.9-${PV%_p*}"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"

RDEPEND="
	app-arch/bzip2:0/1
	dev-libs/expat:0/0
	dev-libs/libffi:0/8
	>=sys-libs/glibc-2.35
	sys-libs/ncurses:0/6
	>=sys-libs/zlib-1.1.3:0/1
	virtual/libintl:0/0
	!dev-python/pypy3-exe:${SLOT}
"

PYPY_PV=${PV%_p*}
QA_PREBUILT="
	usr/bin/pypy3.9-c-${PYPY_PV}
"

src_unpack() {
	local pkg=${MY_P}.${ARCH/ppc64/ppc64le}.xpak
	ebegin "Unpacking ${pkg}"
	tar -x < <(xz -c -d --single-stream "${DISTDIR}/${pkg}")
	eend ${?} || die "Unpacking ${pkg} failed"
}

src_install() {
	insinto /
	doins -r usr
	fperms +x "/usr/bin/pypy3.9-c-${PYPY_PV}"
	pax-mark m "${ED}/usr/bin/pypy3.9-c-${PYPY_PV}"
}
