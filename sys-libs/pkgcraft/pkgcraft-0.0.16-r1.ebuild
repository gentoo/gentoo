# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=" "

RUST_MIN_VER="1.77.1"

inherit edo cargo flag-o-matic multiprocessing toolchain-funcs

DESCRIPTION="C library for pkgcraft"
HOMEPAGE="https://pkgcraft.github.io/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcraft/pkgcraft"
	inherit git-r3

	S="${WORKDIR}"/${P}/crates/pkgcraft-c

	BDEPEND="test? ( dev-util/cargo-nextest )"
else
	MY_P=${PN}-c-${PV}
	SRC_URI="https://github.com/pkgcraft/pkgcraft/releases/download/${MY_P}/${MY_P}.tar.xz"
	S="${WORKDIR}"/${MY_P}

	KEYWORDS="amd64 ~arm64"
fi

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0/${PV}"
IUSE="test"
RESTRICT="!test? ( test )"

# clang needed for bindgen
BDEPEND+="
	dev-util/cargo-c
	llvm-core/clang
"

QA_FLAGS_IGNORED="usr/lib.*/libpkgcraft.so.*"

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_compile() {
	local cargoargs=(
		--library-type=cdylib
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
		$(usev !debug '--release')
	)

	# For scallop building bash
	tc-export AR CC

	# scallop uses modified bash-5.2 which relies on unprotoyped functions
	append-cflags -std=gnu17

	# Can pass -vv if need more output from e.g. scallop configure
	edo cargo cbuild "${cargoargs[@]}"
}

src_test() {
	if [[ ${PV} == 9999 ]] ; then
		# It's interesting to test the whole thing rather than just
		# pkgcraft-c.
		cd "${WORKDIR}"/${P} || die

		local -x NEXTEST_TEST_THREADS="$(makeopts_jobs)"

		# Need nextest per README (separate processes required)
		# Invocation from https://github.com/pkgcraft/pkgcraft/blob/main/.github/workflows/ci.yml#L56
		edo cargo nextest run $(usev !debug '--release') --color always --all-features --tests
	else
		# There are no tests for pkgcraft-c. Test via e.g. dev-python/pkgcraft.
		:;
	fi
}

src_install() {
	local cargoargs=(
		--library-type=cdylib
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
		--destdir="${ED}"
		$(usev !debug '--release')
	)

	edo cargo cinstall "${cargoargs[@]}"
}
