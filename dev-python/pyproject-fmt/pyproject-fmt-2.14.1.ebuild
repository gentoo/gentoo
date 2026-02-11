# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{11..14} )

RUST_MIN_VER="1.87.0"
CRATES="
"

declare -A GIT_CRATES=(
	[tombi-accessor]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-accessor'
	[tombi-ast-editor]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-ast-editor'
	[tombi-ast]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-ast'
	[tombi-cache]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-cache'
	[tombi-comment-directive-serde]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-comment-directive-serde'
	[tombi-comment-directive-store]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-comment-directive-store'
	[tombi-comment-directive]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-comment-directive'
	[tombi-config]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-config'
	[tombi-date-time]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-date-time'
	[tombi-diagnostic]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-diagnostic'
	[tombi-document-tree]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-document-tree'
	[tombi-document]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-document'
	[tombi-formatter]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-formatter'
	[tombi-future]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-future'
	[tombi-json-lexer]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-json-lexer'
	[tombi-json-syntax]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-json-syntax'
	[tombi-json-value]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-json-value'
	[tombi-json]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-json'
	[tombi-lexer]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-lexer'
	[tombi-parser]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-parser'
	[tombi-regex]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-regex'
	[tombi-rg-tree]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-rg-tree'
	[tombi-schema-store]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-schema-store'
	[tombi-severity-level]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-severity-level'
	[tombi-syntax]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-syntax'
	[tombi-text]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-text'
	[tombi-toml-text]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-toml-text'
	[tombi-toml-version]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-toml-version'
	[tombi-uri]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-uri'
	[tombi-validator]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-validator'
	[tombi-version-sort]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-version-sort'
	[tombi-x-keyword]='https://github.com/tombi-toml/tombi;73d0800f0cf60e04fea74992d7abb6fcac435749;tombi-%commit%/crates/tombi-x-keyword'
)

inherit cargo distutils-r1 pypi

DESCRIPTION="Format your pyproject.toml file"
HOMEPAGE="
	https://github.com/tox-dev/pyproject-fmt/
	https://pypi.org/project/pyproject-fmt/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
	https://github.com/gentoo-crate-dist/toml-fmt/releases/download/pyproject-fmt%2F${PV}/toml-fmt-${P}-crates.tar.xz
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT MPL-2.0
	Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	~dev-python/toml-fmt-common-1.2.0[${PYTHON_USEDEP}]
"
# tox is called as a subprocess, to get targets from tox.ini
BDEPEND="
	test? (
		dev-python/tox
	)
"

EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib/py.*/site-packages/pyproject_fmt/_lib.*.so"

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e '/strip/d' pyproject.toml || die
}

python_test_all() {
	# default features cause linking errors because they make pyo3
	# wrongly assume it's compiling a Python extension
	# https://github.com/tox-dev/toml-fmt/issues/23
	cargo_src_test --no-default-features
}
