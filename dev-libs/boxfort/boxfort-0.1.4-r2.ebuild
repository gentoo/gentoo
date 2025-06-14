# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a meson

DESCRIPTION="Convenient & cross-platform sandboxing C library"
HOMEPAGE="https://github.com/Snaipe/BoxFort"
SRC_URI="https://github.com/Snaipe/BoxFort/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/BoxFort-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	test? (
		dev-util/cram
	)
"

src_configure() {
	lto-guarantee-fat

	local emesonargs=(
		$(meson_use test samples)
		$(meson_use test tests)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	strip-lto-bytecode
}
