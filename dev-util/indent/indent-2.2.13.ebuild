# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools strip-linguas

DESCRIPTION="Indent program source files"
HOMEPAGE="https://www.gnu.org/software/indent/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~s390 ~sparc x86"
IUSE="nls"

BDEPEND="
	app-text/texi2html
	nls? ( sys-devel/gettext )
"
DEPEND="nls? ( virtual/libintl )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i -e '/AM_CFLAGS/s:-Werror::g' src/Makefile.{am,in} || die
	eautoreconf
}

src_configure() {
	strip-linguas -i po/

	export gl_cv_cc_vis_werror=no
	export ac_cv_func_setlocale=$(usex nls)

	econf $(use_enable nls)
}

src_test() {
	emake -C regression
}
