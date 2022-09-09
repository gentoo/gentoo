# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: verify-sig, adapt toolchain-autoconf to take econf args?
# TODO: review our old autoconf-2.52 patches?

MY_P=${PN/-dickey}-${PV/_p/-}
DESCRIPTION="Fork of sys-devel/autoconf for Thomas Dickey's packages"
HOMEPAGE="https://invisible-island.net/autoconf/autoconf.html"
SRC_URI="https://invisible-island.net/archives/autoconf/${MY_P}.tgz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

BDEPEND="
	>=sys-devel/m4-1.4.16
	>=dev-lang/perl-5.6
"
RDEPEND="${BDEPEND}"

src_prepare() {
	# usr/bin/libtool is provided by binutils-apple, need gnu libtool
	#if [[ ${CHOST} == *-darwin* ]] ; then
	#	PATCHES+=( "${FILESDIR}"/${PN}-2.61-darwin.patch )
	#fi

	default
}

src_configure() {
	local myeconfargs=(
		--datadir="${EPREFIX}"/usr/share/${PN}
		--program-suffix=-dickey
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# -j1 for bug #869278
	emake -j1 check
}
