# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == 20211124 ]] && COMMIT=2bdacb72a65ab63264b2edc9dac9692df7ec9b3e

DESCRIPTION="Simple yaml module for Guile using the ffi-helper from nyacc"
HOMEPAGE="https://github.com/mwette/guile-libyaml/"
SRC_URI="https://github.com/mwette/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

RDEPEND="
	>=dev-scheme/guile-2.0.0:=
	dev-libs/libyaml
"
DEPEND="${RDEPEND}"
BDEPEND="dev-scheme/guile-nyacc"

# guile generates ELF files without use of C or machine code
# It's a portage's false positive. bug #677600
QA_PREBUILT='*[.]go'

guild_local() {
	GUILE_LOAD_COMPILED_PATH="${S}" GUILE_LOAD_PATH="${S}" guild "${@}" || die
}

src_prepare() {
	default

	# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112
	find "${S}" -name "*.scm" -exec touch {} + || die
}

src_compile() {
	# Generate bindings using NYACC
	guild_local compile-ffi --no-exec yaml/libyaml.ffi

	# Compile modules
	mkdir -p "${S}"/ccache || die
	guild_local compile -o "${S}"/ccache/libyaml.go "${S}"/yaml/libyaml.scm
	guild_local compile -o "${S}"/ccache/yaml.go "${S}"/yaml.scm
}

src_install() {
	local site_dir="$(guile -c '(display (%site-dir))')"
	insinto "${site_dir}"/yaml
	doins yaml/libyaml.scm
	insinto "${site_dir}"
	doins yaml.scm

	local site_ccache_dir="$(guile -c '(display (%site-ccache-dir))')"
	insinto "${site_ccache_dir}"/yaml
	doins ccache/libyaml.go
	insinto "${site_ccache_dir}"
	doins ccache/yaml.go

	einstalldocs
}
