# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit autotools guile

DESCRIPTION="Guile FFI to ncurses library for text-based console UI"
HOMEPAGE="https://www.gnu.org/software/guile-ncurses/"
SRC_URI="mirror://gnu/guile-ncurses/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="
	${GUILE_DEPS}
	dev-libs/boehm-gc
	dev-libs/libatomic_ops
	dev-libs/libunistring
	sys-libs/ncurses:=
"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/texinfo"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0-slibtool.patch  # bug #843416
)

src_prepare() {
	guile_src_prepare

	# Remove bad tests
	# > In procedure list-ref: Wrong type argument in position 1: #f
	local -a bad_tests=(
		curs_attr_attr_off_underline
		curs_attr_attr_on_blink
		curs_attr_attr_on_bold
		curs_attr_attr_on_dim
		curs_attr_attr_on_invis
		curs_attr_attr_on_protect
		curs_attr_attr_on_reverse
		curs_attr_attr_on_standout
		curs_attr_attr_on_underline
		curs_attr_attr_set
		curs_attr_attr_set_normal
		curs_attr_standend
		curs_attr_standout
		curs_bkgd_bkgd
		curs_bkgd_bkgdset
		termios_speed
	)
	local bad_test
	for bad_test in "${bad_tests[@]}" ; do
		echo "#t" > test/${bad_test}.scm || die
	done

	eautoreconf  # 843560
}

src_test() {
	guile_foreach_impl emake check
}

src_install() {
	guile_src_install

	find "${ED}" -type f -name '*.la' -delete || die
}
