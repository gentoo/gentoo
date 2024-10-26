# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit edo guile

[[ ${PV} == 20211124 ]] && COMMIT=2bdacb72a65ab63264b2edc9dac9692df7ec9b3e

DESCRIPTION="Simple yaml module for Guile using the ffi-helper from nyacc"
HOMEPAGE="https://github.com/mwette/guile-libyaml/"
SRC_URI="https://github.com/mwette/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="
	${GUILE_DEPS}
	dev-libs/libyaml
"
DEPEND="${RDEPEND}"
BDEPEND="dev-scheme/guile-nyacc"

src_compile() {
	my_compile() {
		guild() {
			GUILE_LOAD_COMPILED_PATH="${BUILD_DIR}" GUILE_LOAD_PATH="${S}" edo "${GUILD}" "${@}" || die
		}
		# Generate bindings using NYACC
		guild compile-ffi --no-exec "${S}"/yaml/libyaml.ffi

		# Compile modules
		mkdir -p "${BUILD_DIR}"/ccache || die
		guild compile -o "${BUILD_DIR}"/ccache/libyaml.go "${S}"/yaml/libyaml.scm
		guild compile -o "${BUILD_DIR}"/ccache/yaml.go "${S}"/yaml.scm
	}

	guile_foreach_impl my_compile
}

src_install() {
	my_install() {
		local site_dir="$(${GUILE} -c '(display (%site-dir))')"
		mkdir -p "${SLOTTED_D}/${site_dir}/yaml" || die
		cp "${S}/yaml/libyaml.scm" "${SLOTTED_D}/${site_dir}/yaml/" || die
		cp "${S}/yaml.scm" "${SLOTTED_D}/${site_dir}/" || die

		local site_ccache_dir="$(${GUILE} -c '(display (%site-ccache-dir))')"
		mkdir -p "${SLOTTED_D}/${site_ccache_dir}/yaml" || die
		cp "${BUILD_DIR}/ccache/libyaml.go" "${SLOTTED_D}/${site_ccache_dir}/yaml/" || die
		cp "${BUILD_DIR}/ccache/yaml.go" "${SLOTTED_D}/${site_ccache_dir}/" || die
	}

	guile_foreach_impl my_install
	guile_merge_roots
	guile_unstrip_ccache

	einstalldocs
}
