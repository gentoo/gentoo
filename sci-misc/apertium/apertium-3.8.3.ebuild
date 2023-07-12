# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit autotools python-any-r1

DESCRIPTION="Shallow-transfer machine Translation engine and toolbox"
HOMEPAGE="https://apertium.sourceforge.net/"
SRC_URI="https://github.com/apertium/apertium/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
# PKG_VERSION_ABI in configure.ac
SLOT="0/3"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# TODO: test_null_flush fails
RESTRICT="!test? ( test ) test"

RDEPEND="
	dev-libs/icu:=
	>=dev-libs/libxml2-2.6.17
	dev-libs/utfcpp
	>=sci-misc/lttoolbox-3.7.1:=
	virtual/libiconv
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		dev-libs/libzip[tools]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.8.3-bashism.patch
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	# Requires shellcheck, not useful for us in Gentoo
	cat <<-EOF > tests/sh/run || die
	#!/usr/bin/env bash
	exit 77
	EOF

	eautoreconf
}

src_configure() {
	econf --disable-python-bindings
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
