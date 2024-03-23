# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit flag-o-matic meson python-any-r1

DEBUGBREAK_COMMIT="6b79ec8d8f8d4603111f580a0537f8f31c484c32"
KLIB_COMMIT="cdb7e9236dc47abf8da7ebd702cc6f7f21f0c502"
NANOPB_COMMIT="c9124132a604047d0ef97a09c0e99cd9bed2c818"

DESCRIPTION="Cross platform unit testing framework for C and C++"
HOMEPAGE="https://github.com/Snaipe/Criterion"
SRC_URI="https://github.com/Snaipe/Criterion/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/scottt/debugbreak/archive/${DEBUGBREAK_COMMIT}.tar.gz -> debugbreak-${DEBUGBREAK_COMMIT}.tar.gz
	https://github.com/attractivechaos/klib/archive/${KLIB_COMMIT}.tar.gz -> klib-${KLIB_COMMIT}.tar.gz
	https://github.com/nanopb/nanopb/archive/${NANOPB_COMMIT}.tar.gz -> nanopb-${NANOPB_COMMIT}.tar.gz"

LICENSE="BSD-2 MIT ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/nanomsg:=
	dev-libs/libgit2:=
	dev-libs/libffi:="
DEPEND="${RDEPEND}
	>=dev-libs/boxfort-0.1.4
	test? (
		$(python_gen_any_dep 'dev-util/cram[${PYTHON_USEDEP}]')
	)"
BDEPEND="dev-build/cmake
	virtual/pkgconfig"

S="${WORKDIR}/Criterion-${PV}"

python_check_deps() {
	has_version "dev-util/cram[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	rm -r dependencies/{debugbreak,klib} || die
	mv "${WORKDIR}/debugbreak-${DEBUGBREAK_COMMIT}" dependencies/debugbreak || die
	mv "${WORKDIR}/klib-${KLIB_COMMIT}" dependencies/klib || die
	mv "${WORKDIR}/nanopb-${NANOPB_COMMIT}" subprojects/nanopb || die
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/855674
	# https://github.com/Snaipe/Criterion/issues/524
	filter-lto

	# bug 906379
	use elibc_musl && append-cppflags -D_LARGEFILE64_SOURCE

	local emesonargs=(
		-Dsamples=$(usex test true false)
		-Dtests=$(usex test true false)
	)

	meson_src_configure
}
