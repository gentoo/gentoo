# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit	guile autotools

DESCRIPTION="Simple framework for building readers for GNU Guile"
HOMEPAGE="https://www.nongnu.org/guile-reader/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="${GUILE_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/gperf"

PATCHES=(
	"${FILESDIR}/${PN}-0.6.3-implicit-fn-decl.patch"
	"${FILESDIR}/${PN}-0.6.3-slot.patch"
)

src_prepare() {
	default

	eautoreconf

	guile_bump_sources
}

configure_one_src() {
	local -x guile_snarf="${GUILESNARF}"
	# We don't have lightning packaged and, naturally, guile-reader has
	# no --with-... for it.  Suppress the automagic.
	econf \
		ac_cv_header_lightning_h=no
}

src_configure() {
	guile_foreach_impl configure_one_src
}

compile_one_src() {
	# Makefile appears to be missing seemingly all dependencies.
	emake -j1 --shuffle=none
}

src_compile() {
	guile_foreach_impl compile_one_src
}

src_install() {
	guile_src_install

	find "${ED}" -type f -name '*.la' -delete || die
}
