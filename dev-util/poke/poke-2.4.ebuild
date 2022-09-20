# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Extensible editor for structured binary data"
HOMEPAGE="https://www.jemarch.net/poke"
SRC_URI="mirror://gnu/poke/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pvm-profiling nls test"

RESTRICT="!test? ( test )"

# TODO: libnbd: not packaged in gentoo yet
RDEPEND="
	dev-libs/boehm-gc:=
	dev-libs/libatomic_ops
	sys-devel/gettext
	sys-libs/readline:=
"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )"
BDEPEND="sys-devel/flex
	sys-devel/bison
	sys-apps/help2man
	virtual/pkgconfig"

src_configure() {
	# NB --disable-{gui,mi}:
	# These (AFAICT) have no consumers in Gentoo, and should not get any,
	# preferably. They are slated for removal with Poke 3 (should happen
	# towards the end of the year, possibly), so they should not be relied
	# upon.
	econf \
		--disable-libnbd \
		--enable-hserver \
		--disable-gui \
		--disable-mi \
		$(use_enable pvm-profiling) \
		$(use_enable nls)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
