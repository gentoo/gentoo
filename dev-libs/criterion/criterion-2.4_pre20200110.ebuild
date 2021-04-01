# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit meson python-any-r1

CRITERION_COMMIT="4b5174ebda04ab76fe65eec25b5b6ea0809055e7"
DEBUGBREAK_COMMIT="6b79ec8d8f8d4603111f580a0537f8f31c484c32"
KLIB_COMMIT="cdb7e9236dc47abf8da7ebd702cc6f7f21f0c502"
NANOPB_COMMIT="6a6903be6084bb3f5a98a3341acef2aa05c61df9"

DESCRIPTION="Cross platform unit testing framework for C and C++"
HOMEPAGE="https://github.com/Snaipe/Criterion"
SRC_URI="https://github.com/Snaipe/Criterion/archive/${CRITERION_COMMIT}.tar.gz -> criterion-${CRITERION_COMMIT}.tar.gz
	https://github.com/scottt/debugbreak/archive/${DEBUGBREAK_COMMIT}.tar.gz -> debugbreak-${DEBUGBREAK_COMMIT}.tar.gz
	https://github.com/attractivechaos/klib/archive/${KLIB_COMMIT}.tar.gz -> klib-${KLIB_COMMIT}.tar.gz
	https://github.com/nanopb/nanopb/archive/${NANOPB_COMMIT}.tar.gz -> nanopb-${NANOPB_COMMIT}.tar.gz"

LICENSE="BSD-2 MIT ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/nanomsg:=
	dev-libs/libgit2:=
	dev-libs/libffi:="
DEPEND="${RDEPEND}
	dev-libs/boxfort
	test? (
		$(python_gen_any_dep 'dev-util/cram[${PYTHON_USEDEP}]')
	)"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/Criterion-${CRITERION_COMMIT}"

python_check_deps() {
	has_version "dev-util/cram[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	rm -r dependencies/{debugbreak,klib,nanopb} || die
	mv "${WORKDIR}/debugbreak-${DEBUGBREAK_COMMIT}" dependencies/debugbreak || die
	mv "${WORKDIR}/klib-${KLIB_COMMIT}" dependencies/klib || die
	mv "${WORKDIR}/nanopb-${NANOPB_COMMIT}" dependencies/nanopb || die
}

src_configure() {
	local emesonargs=(
		-Dsamples=$(usex test true false)
		-Dtests=$(usex test true false)
	)

	meson_src_configure
}
