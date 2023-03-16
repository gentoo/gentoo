# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="threads(+)"
inherit waf-utils multilib-minimal python-single-r1

DESCRIPTION="Simple database API"
HOMEPAGE="https://tdb.samba.org/"
SRC_URI="https://samba.org/ftp/tdb/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test"

RDEPEND="
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	virtual/libcrypt
"
BDEPEND="
	${PYTHON_DEPS}
	app-text/docbook-xml-dtd:4.2
"

WAF_BINARY="${S}/buildtools/bin/waf"

src_prepare() {
	default
	python_fix_shebang .
	multilib_copy_sources
}

multilib_src_configure() {
	MAKEOPTS+=" -j1"

	local extra_opts=(
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--disable-dependency-tracking
		--disable-warnings-as-errors
	)

	if ! multilib_is_native_abi || ! use python ; then
		extra_opts+=( --disable-python )
	fi

	waf-utils_src_configure "${extra_opts[@]}"
}

multilib_src_compile() {
	waf-utils_src_compile
}

multilib_src_test() {
	# the default src_test runs 'make test' and 'make check', letting
	# the tests fail occasionally (reason: unknown)
	emake check
}

multilib_src_install() {
	waf-utils_src_install
	use python && python_optimize
}
