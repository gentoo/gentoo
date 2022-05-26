# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Extensible editor for structured binary data"
HOMEPAGE="https://www.jemarch.net/poke"
SRC_URI="mirror://gnu/poke/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="machine-interface nls test"

RESTRICT="!test? ( test )"

# TODO: libnbd: not packaged in gentoo yet
# TODO: gui: does not seem to do anything :)
RDEPEND="
	dev-libs/boehm-gc:=
	dev-libs/libatomic_ops
	sys-devel/gettext
	sys-libs/readline:=
	machine-interface? ( dev-libs/json-c:= )
"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )"
BDEPEND="sys-devel/flex
	sys-devel/bison
	sys-apps/help2man
	virtual/pkgconfig"

src_configure() {
	econf \
		--disable-gui \
		--disable-libnbd \
		$(use_enable machine-interface mi) \
		$(use_enable nls)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
