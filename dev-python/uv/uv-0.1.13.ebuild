# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[async_zip]='https://github.com/charliermarsh/rs-async-zip;d76801da0943de985254fc6255c0e476b57c5836;rs-async-zip-%commit%'
	[pubgrub]='https://github.com/zanieb/pubgrub;aab132a3d4d444dd8dd41d8c4e605abd69dacfe1;pubgrub-%commit%'
)

inherit cargo check-reqs

DESCRIPTION="A Python package installer and resolver, written in Rust"
HOMEPAGE="
	https://github.com/astral-sh/uv/
	https://pypi.org/project/uv/
"
# pypi sdist misses scripts/, needed for tests
SRC_URI="
	https://github.com/astral-sh/uv/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://dev.gentoo.org/~mgorny/dist/${P}-crates.tar.xz
	"
fi

# most of the code
LICENSE="|| ( Apache-2.0 MIT )"
# crates/pep508-rs is || ( Apache-2.0 BSD-2 ) which is covered below
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD ISC MIT
	MPL-2.0 Unicode-DFS-2016
"
# ring crate
LICENSE+=" openssl"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="test"
PROPERTIES="test_network"

BDEPEND="
	test? (
		dev-lang/python:3.8
		dev-lang/python:3.9
		dev-lang/python:3.10
		dev-lang/python:3.11
		dev-lang/python:3.12
	)
"

PATCHES=(
	# skip broken tests:
	# - requiring pinned CPython versions (3.8.12, 3.11.7, 3.12.1)
	# - requiring specific terminal width (COLUMNS don't seem to work)
	# - other (perhaps failing because of other skipped tests?)
	"${FILESDIR}/uv-0.1.13-skip-tests.patch"
)

QA_FLAGS_IGNORED="usr/bin/.*"

check_space() {
	local CHECKREQS_DISK_BUILD=3G
	use debug && CHECKREQS_DISK_BUILD=9G
	check-reqs_pkg_setup
}

pkg_pretend() {
	check_space
}

pkg_setup() {
	check_space
}

src_compile() {
	cd crates/uv || die
	cargo_src_compile
}

src_test() {
	cd crates/uv || die
	cargo_src_test
}

src_install() {
	cd crates/uv || die
	cargo_src_install
}
