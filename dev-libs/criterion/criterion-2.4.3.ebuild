# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit flag-o-matic meson python-any-r1

DEBUGBREAK_COMMIT="83bf7e933311b88613cbaadeced9c2e2c811054a"
KLIB_COMMIT="cdb7e9236dc47abf8da7ebd702cc6f7f21f0c502"
NANOPB_COMMIT="cad3c18ef15a663e30e3e43e3a752b66378adec1"

DESCRIPTION="Cross platform unit testing framework for C and C++"
HOMEPAGE="https://github.com/Snaipe/Criterion"
SRC_URI="
	https://github.com/Snaipe/Criterion/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/MrAnno/debugbreak/archive/${DEBUGBREAK_COMMIT}.tar.gz -> debugbreak-${DEBUGBREAK_COMMIT}.tar.gz
	https://github.com/attractivechaos/klib/archive/${KLIB_COMMIT}.tar.gz -> klib-${KLIB_COMMIT}.tar.gz
	https://github.com/nanopb/nanopb/archive/${NANOPB_COMMIT}.tar.gz -> nanopb-${NANOPB_COMMIT}.tar.gz
"
S="${WORKDIR}/Criterion-${PV}"

LICENSE="BSD-2 MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libgit2:=
	dev-libs/libffi:=
	dev-libs/nanomsg:=
"
DEPEND="
	${RDEPEND}
	>=dev-libs/boxfort-0.1.4
	test? (
		$(python_gen_any_dep 'dev-util/cram[${PYTHON_USEDEP}]')
	)
"
BDEPEND="
	dev-build/cmake
	virtual/pkgconfig
"

python_check_deps() {
	python_has_version -d 'dev-util/cram[${PYTHON_USEDEP}]'
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	mv "${WORKDIR}/debugbreak-${DEBUGBREAK_COMMIT}" subprojects/debugbreak || die
	mv "${WORKDIR}/klib-${KLIB_COMMIT}" subprojects/klib || die
	mv "${WORKDIR}/nanopb-${NANOPB_COMMIT}" subprojects/nanopb || die
	meson subprojects packagefiles --apply || die

	default
}

src_configure() {
	# Fails tests (bug #730120)
	filter-lto

	# bug #906379
	use elibc_musl && append-cppflags -D_LARGEFILE64_SOURCE

	local emesonargs=(
		-Dsamples=$(usex test true false)
		-Dtests=$(usex test true false)
	)

	meson_src_configure
}
