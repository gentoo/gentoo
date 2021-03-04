# Copyright 1999-2021 Gentoo Authors
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
	x86? (
		https://dev.gentoo.org/~mgorny/binpkg/x86/pypy/dev-python/pypy3-exe/${MY_P}.xpak
			-> ${MY_P}.x86.xpak
	)"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="amd64 x86"

RDEPEND=">=sys-libs/zlib-1.1.3:0/1
	dev-libs/libffi:0/7
	virtual/libintl:0/0
	dev-libs/expat:0/0
	app-arch/bzip2:0/1
	sys-libs/ncurses:0/6
	!dev-python/pypy-exe:${PV}"

QA_PREBUILT="
	usr/lib/pypy3.6/pypy3-c-${SLOT}"

src_unpack() {
	ebegin "Unpacking ${MY_P}.${ARCH}.xpak"
	tar -x < <(xz -c -d --single-stream "${DISTDIR}/${MY_P}.${ARCH}.xpak")
	eend ${?} || die "Unpacking ${MY_P} failed"
}

src_install() {
	insinto /
	doins -r usr
	fperms +x "/usr/lib/pypy3.6/pypy3-c-${SLOT}"
	pax-mark m "${ED}/usr/lib/pypy3.6/pypy3-c-${SLOT}"
}
