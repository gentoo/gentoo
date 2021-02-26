# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="extensible editor for structured binary data"
HOMEPAGE="http://www.jemarch.net/poke"

SRC_URI="mirror://gnu/poke/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"
IUSE="machine-interface nls test"

RESTRICT="!test? ( test )"

# TODO: libnbd: not packaged in gentoo yet
# TODO: gui: tcl/json not packaged in gentoo yet
RDEPEND="
	dev-libs/boehm-gc:=
	sys-devel/gettext
	sys-libs/readline:=
	machine-interface? ( dev-libs/json-c:= )
"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )
"
BDEPEND="
	sys-devel/flex
	sys-devel/bison
	sys-apps/help2man
	virtual/pkgconfig
"

src_configure() {
	econf \
		--disable-gui \
		--disable-libnbd \
		$(use_enable machine-interface mi)
}
