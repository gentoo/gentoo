# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )

inherit meson python-any-r1

BOXFORT_COMMIT="1456d9a3a3bcb506cdcd1b5d4b852e967deb5e57"

DESCRIPTION="Convenient & cross-platform sandboxing C library"
HOMEPAGE="https://github.com/Snaipe/BoxFort"
SRC_URI="https://github.com/Snaipe/BoxFort/archive/${BOXFORT_COMMIT}.tar.gz -> boxfort-${BOXFORT_COMMIT}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? (
		$(python_gen_any_dep 'dev-util/cram[${PYTHON_USEDEP}]')
	)"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/BoxFort-${BOXFORT_COMMIT}"

python_check_deps() {
	has_version "dev-util/cram[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Dsamples=$(usex test true false)
		-Dtests=$(usex test true false)
	)

	meson_src_configure
}
