# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib-minimal toolchain-funcs

# Different date format used upstream.
RE2_VER=${PV#0.}
RE2_VER=${RE2_VER//./-}

DESCRIPTION="An efficent, principled regular expression library"
HOMEPAGE="https://github.com/google/re2"
SRC_URI="https://github.com/google/re2/archive/${RE2_VER}.tar.gz -> ${PN}-${RE2_VER}.tar.gz"

LICENSE="BSD"
# NOTE: Always run libre2 through abi-compliance-checker!
SLOT="0/0.2016.05.01"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="icu"

RDEPEND="icu? ( dev-libs/icu:0=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	icu? ( virtual/pkgconfig )"

S="${WORKDIR}/${PN}-${RE2_VER}"

PATCHES=( "${FILESDIR}/${PV}-pkgconfig.patch" )
DOCS=( "AUTHORS" "CONTRIBUTORS" "README" "doc/syntax.txt" )
HTML_DOCS=( "doc/syntax.html" )

src_prepare() {
	default
	if use icu; then
		sed -i -e 's:^# \(\(CC\|LD\)ICU=.*\):\1:' Makefile || die
	fi
	multilib_copy_sources
}

src_configure() {
	tc-export AR CXX NM
}

multilib_src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" libdir="\$(exec_prefix)/$(get_libdir)" install
}
