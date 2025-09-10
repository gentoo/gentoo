# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit flag-o-matic libtool python-single-r1 verify-sig

DESCRIPTION="Command-line tool and library to read and convert trace files"
HOMEPAGE="https://babeltrace.org/"
SRC_URI="
	https://www.efficios.com/files/${PN}/${PN}$(ver_cut 1)-${PV}.tar.bz2
	verify-sig? ( https://www.efficios.com/files/${PN}/${PN}$(ver_cut 1)-${PV}.tar.bz2.asc )
"
S="${WORKDIR}/${PN}$(ver_cut 1)-${PV}"

LICENSE="GPL-2"
SLOT="2/$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc +elfutils +man plugins python"
REQUIRED_USE="plugins? ( python ) python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	>=dev-libs/glib-2.28:2
	elfutils? ( >=dev-libs/elfutils-0.154 )
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="
	${DEPEND}
	!dev-util/babeltrace:0/2
"
BDEPEND="
	>=sys-devel/bison-2.5
	app-alternatives/lex
	python? (
		>=dev-lang/swig-3.0
		$(python_gen_cond_dep 'dev-python/setuptools[${PYTHON_USEDEP}]' python3_12)
		doc? ( >=dev-python/sphinx-1.3 )
	)
	doc? ( >=app-text/doxygen-1.8.6 )
	man? (
		>=app-text/asciidoc-8.6.8
		>=app-text/xmlto-0.0.25
	)
	verify-sig? ( sec-keys/openpgp-keys-jeremiegalarneau )
"
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/jeremiegalarneau.asc

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# Test requires plugins to be enabled. bug #957014
	if use !plugins; then
		rm tests/bindings/python/bt2/test_mip1.py || die
	fi

	# Needed for LTO -Werror
	elibtoolize
}

src_configure() {
	# ODR violation in currentCtfScanner. Not yet reported upstream
	# as bug tracker account is pending approval.
	filter-lto

	use python && export PYTHON_CONFIG="${EPYTHON}-config"

	local myeconfargs=(
		$(use_enable doc api-doc)
		$(use_enable elfutils debug-info)
		$(use_enable man man-pages)
		$(use_enable python python-bindings)
		$(usex python $(use_enable doc python-bindings-doc) --disable-python-bindings-doc)
		$(use_enable plugins python-plugins)
		--disable-built-in-plugins
		--disable-built-in-python-plugin-support
		--disable-Werror
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# bug #956668
	python_optimize "${ED}"

	find "${D}" -name '*.la' -delete || die
}
