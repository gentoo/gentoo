# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=STBEY
DIST_VERSION=6.1
inherit perl-module

DESCRIPTION="Gregorian calendar date calculations"
LICENSE="|| ( Artistic GPL-1+ ) LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ~m68k ppc ~ppc64 ~s390 ~sparc x86"
IUSE=""

RDEPEND="
	>=dev-perl/Bit-Vector-7.100.0
	>=dev-perl/Carp-Clan-5.300.0
"
BDEPEND="${DEPEND}"

mydoc="ToDo"

PATCHES=(
	"${FILESDIR}"/6.100.0_identifier_before_numeric_constant.patch
	"${FILESDIR}/${PN}-6.100.0-unescaped-left-brace-5.26.patch"
	"${FILESDIR}/${PN}-6.100.0-datestamp-window-move.patch"
)

src_configure() {
	unset LD
	[[ -n "${CCLD}" ]] && export LD="${CCLD}"
	perl-module_src_configure
}

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
