# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic libtool toolchain-funcs

DESCRIPTION="Convert files between various character sets"
HOMEPAGE="https://github.com/rrthomas/recode"
REV="2d7092a9999194fc0e9449717a8048c8d8e26c18"
SRC_URI="https://github.com/pinard/Recode/archive/${REV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls static-libs"

DEPEND="
	sys-devel/flex
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/Recode-${REV}"

# tests fail.
RESTRICT="test"

src_configure() {
	tc-export CC LD
	# on solaris -lintl is needed to compile
	[[ ${CHOST} == *-solaris* ]] && append-libs "-lintl"
	# --without-included-gettext means we always use system headers
	# and library
	econf \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -v {} + || die
}
