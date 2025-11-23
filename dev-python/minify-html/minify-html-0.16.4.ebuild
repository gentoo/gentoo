# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

CRATES=""
inherit cargo distutils-r1 pypi

DESCRIPTION="Extremely fast and smart HTML + JS + CSS minifier"
HOMEPAGE="
	https://github.com/wilsonzlin/minify-html/
	https://pypi.org/project/minify-html/
"
SRC_URI+=" https://github.com/gentoo-crate-dist/minify-html/releases/download/v${PV}/${P}-crates.tar.xz"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT MPL-2.0
	Unicode-3.0
"
# ring crate
LICENSE+=" openssl"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/minify_html/minify_html.*.so"

export PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1

src_prepare() {
	sed -i -e '/strip/d' Cargo.toml || die
	distutils-r1_src_prepare
}

python_test_all() {
	cargo_src_test
}
