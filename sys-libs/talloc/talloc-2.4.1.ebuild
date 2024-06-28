# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="threads(+)"
inherit waf-utils python-single-r1 multilib-minimal

DESCRIPTION="Samba talloc library"
HOMEPAGE="https://talloc.samba.org/"
SRC_URI="https://www.samba.org/ftp/${PN}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3+ LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE="compat +python test valgrind"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	!elibc_SunOS? (
		!elibc_Darwin? (
			dev-libs/libbsd[${MULTILIB_USEDEP}]
		)
	)
	python? ( ${PYTHON_DEPS} )
"
# Valgrind is automagic here but it's a build-only dep so it's not so bad.
DEPEND="
	${RDEPEND}
	valgrind? ( dev-debug/valgrind )
"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxslt
	sys-devel/gettext
"

WAF_BINARY="${S}/buildtools/bin/waf"

MULTILIB_WRAPPED_HEADERS=(
	# python goes only for native
	/usr/include/pytalloc.h
)

pkg_setup() {
	# Try to turn off distcc and ccache for people that have a problem with it
	export DISTCC_DISABLE=1
	export CCACHE_DISABLE=1

	python-single-r1_pkg_setup
}

src_prepare() {
	default

	if [[ ${CHOST} == *-darwin* ]] ; then
		# Drop irritating ABI names (e.g. cpython-37m)
		# We're only installing one implementation anyway
		sed -i "s/+ conf.all_envs\['default'\]\['PYTHON_SO_ABI_FLAG'\]//" wscript || die
		sed -i "s/name = bld.pyembed_libname('pytalloc-util')/name = 'pytalloc-util'/" wscript || die
	fi

	if use test ; then
		# TODO: Fix python tests to run w/ USE=python.
		truncate -s0 test_pytalloc.py || die
	fi

	# WAF
	multilib_copy_sources
}

multilib_src_configure() {
	local extra_opts=(
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--disable-dependency-tracking
		--disable-warnings-as-errors

		$(usev compat --enable-talloc-compat1)
		$(multilib_native_usex python '' --disable-python)
		$([[ ${CHOST} == *-solaris* ]] && echo '--disable-symbol-versions')
	)

	waf-utils_src_configure "${extra_opts[@]}"
}

multilib_src_compile() {
	waf-utils_src_compile
}

multilib_src_install() {
	waf-utils_src_install

	# waf is stupid, and no, we can't fix the build-system, since it's provided
	# as a brilliant binary blob thats decompressed on the fly
	if [[ ${CHOST} == *-darwin* ]] ; then
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libtalloc.2.dylib \
			"${ED}"/usr/$(get_libdir)/libtalloc.${PV}.dylib || die

		if use python ; then
			install_name_tool \
				-id "${EPREFIX}"/usr/$(get_libdir)/libpytalloc-util.2.dylib \
				"${ED}"/usr/$(get_libdir)/libpytalloc-util.${PV}.dylib || die
			install_name_tool \
				-change "${BUILD_DIR}/bin/default/libtalloc.dylib" \
				"${EPREFIX}"/usr/$(get_libdir)/libtalloc.2.dylib \
				"${ED}"/usr/$(get_libdir)/libpytalloc-util.${PV}.dylib || die

			install_name_tool \
				-id "${EPREFIX}"/usr/$(get_libdir)/libpytalloc-util.dylib \
				"${ED}"/usr/$(get_libdir)/libpytalloc-util.dylib || die
			install_name_tool \
				-change "${BUILD_DIR}/bin/default/libtalloc.dylib" \
				"${EPREFIX}"/usr/$(get_libdir)/libtalloc.2.dylib \
				"${ED}"/usr/$(get_libdir)/libpytalloc-util.dylib || die

			install_name_tool \
				-change "${BUILD_DIR}/bin/default/libpytalloc-util.dylib" \
				"${EPREFIX}"/usr/$(get_libdir)/libpytalloc-util.dylib \
				"${D}"$(python_get_sitedir)/talloc*.bundle || die
			install_name_tool \
				-change "${BUILD_DIR}/bin/default/libtalloc.dylib" \
				"${EPREFIX}"/usr/$(get_libdir)/libtalloc.2.dylib \
				"${D}"$(python_get_sitedir)/talloc*.bundle || die
		fi
	fi
}
