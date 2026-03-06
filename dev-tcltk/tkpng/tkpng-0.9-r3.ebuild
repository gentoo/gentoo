# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}${PV}"

inherit autotools

DESCRIPTION="Implements support for loading and using PNG images with Tcl/Tk"
HOMEPAGE="http://www.muonics.com/FreeStuff/TkPNG/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${PN}/${PV}/${MY_P}.tgz"

S="${WORKDIR}"/${MY_P}

LICENSE="tcltk"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug threads"

RDEPEND="
	>=dev-lang/tcl-8.4:=
	>=dev-lang/tk-8.4:=
	<dev-lang/tk-9
	virtual/zlib:=
"
DEPEND="${RDEPEND}"

QA_CONFIG_IMPL_DECL_SKIP=(
	stat64 # used to test for Large File Support
)

# test target in Makefile, but test not shipped
RESTRICT="test"

src_prepare() {
	default

	# Clang 16
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug symbols) \
		$(use_enable amd64 64bit) \
		$(use_enable threads)
}
