# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: adapt toolchain-autoconf to take econf args?
# TODO: review our old autoconf-2.52 patches?

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/thomasdickey.asc
inherit verify-sig

MY_P=${PN/-dickey}-${PV/_p/-}
DESCRIPTION="Fork of dev-build/autoconf for Thomas Dickey's packages"
HOMEPAGE="https://invisible-island.net/autoconf/autoconf.html"
SRC_URI="https://invisible-island.net/archives/autoconf/${MY_P}.tgz"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/autoconf/${MY_P}.tgz.asc )"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=sys-devel/m4-1.4.16
	>=dev-lang/perl-5.6
"
BDEPEND="
	${RDEPEND}
	verify-sig? ( sec-keys/openpgp-keys-thomasdickey )
"

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
