# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils autotools multilib multilib-minimal portability toolchain-funcs versionator

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="http://www.lua.org/"
TEST_PV="5.3.4" # no 5.3.5-specific release yet
TEST_A="${PN}-${TEST_PV}-tests.tar.gz"
PKG_A="${P}.tar.gz"
SRC_URI="
	http://www.lua.org/ftp/${PKG_A}
	test? ( https://www.lua.org/tests/${TEST_A} )"

LICENSE="MIT"
SLOT="5.3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+deprecated emacs readline static test test-complete"
RESTRICT="!test? ( test )"

RDEPEND="readline? ( sys-libs/readline:0= )
	app-eselect/eselect-lua
	!dev-lang/lua:0"
DEPEND="${RDEPEND}
	sys-devel/libtool"
PDEPEND="emacs? ( app-emacs/lua-mode )"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/lua${SLOT}/luaconf.h
)

src_prepare() {
	local PATCH_PV=$(get_version_component_range 1-2)

	epatch "${FILESDIR}"/${PN}-${PATCH_PV}-make-r1.patch

	# use glibtool on Darwin (versus Apple libtool)
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e '/LIBTOOL = /s:/libtool:/glibtool:' \
			Makefile src/Makefile || die
	fi

	[ -d "${FILESDIR}/${PV}" ] && \
		EPATCH_SOURCE="${FILESDIR}/${PV}" EPATCH_SUFFIX="upstream.patch" epatch

	# correct lua versioning
	sed -i -e 's/\(LIB_VERSION = \)6:1:1/\10:0:0/' src/Makefile || die

	sed -i -e 's:\(/README\)\("\):\1.gz\2:g' doc/readme.html || die

	if ! use readline ; then
		sed -i -e '/#define LUA_USE_READLINE/d' src/luaconf.h || die
	fi

	# Using dynamic linked lua is not recommended for performance
	# reasons. http://article.gmane.org/gmane.comp.lang.lua.general/18519
	# Mainly, this is of concern if your arch is poor with GPRs, like x86
	# Note that this only affects the interpreter binary (named lua), not the lua
	# compiler (built statically) nor the lua libraries (both shared and static
	# are installed)
	if use static ; then
		sed -i -e 's:\(-export-dynamic\):-static \1:' src/Makefile || die
	fi

	# upstream does not use libtool, but we do (see bug #336167)
	cp "${FILESDIR}/configure.in" "${S}/configure.ac" || die
	eautoreconf

	# A slotted Lua uses different directories for headers & names for
	# libraries, and pkgconfig should reflect that.
	sed -r -i \
		-e "/^Libs:/s,((-llua)($| )),\2${SLOT}\3," \
		-e "/^Cflags:/s,((-I..includedir.)($| )),\2/lua${SLOT}\3," \
		"${S}"/etc/lua.pc

	# custom Makefiles
	multilib_copy_sources
}

multilib_src_configure() {
	sed -i \
		-e 's:\(define LUA_ROOT\s*\).*:\1"'${EPREFIX}'/usr/":' \
		-e "s:\(define LUA_CDIR\s*LUA_ROOT \"\)lib:\1$(get_libdir):" \
		src/luaconf.h \
	|| die "failed patching luaconf.h"

	econf
}

multilib_src_compile() {
	tc-export CC

	# what to link to liblua
	liblibs="-lm"
	liblibs="${liblibs} $(dlopen_lib)"

	# what to link to the executables
	mylibs=
	use readline && mylibs="-lreadline"

	cd src

	local myCFLAGS=""
	use deprecated && myCFLAGS="-DLUA_COMPAT_ALL"

	case "${CHOST}" in
		*-mingw*) : ;;
		*) myCFLAGS+=" -DLUA_USE_LINUX" ;;
	esac

	emake CC="${CC}" CFLAGS="${myCFLAGS} ${CFLAGS}" \
			SYSLDFLAGS="${LDFLAGS}" \
			RPATH="${EPREFIX}/usr/$(get_libdir)/" \
			LUA_LIBS="${mylibs}" \
			LIB_LIBS="${liblibs}" \
			V=$(get_version_component_range 1-2) \
			gentoo_all
}

multilib_src_install() {
	emake INSTALL_TOP="${ED}/usr" INSTALL_LIB="${ED}/usr/$(get_libdir)" \
			V=${SLOT} gentoo_install

	# We want packages to find our things...
	cp "${FILESDIR}/lua.pc" "${WORKDIR}"
	sed -i \
		-e "s:^prefix= :prefix= ${EPREFIX}:" \
		-e "s:^V=.*:V= ${PATCH_PV}:" \
		-e "s:^R=.*:R= ${PV}:" \
		-e "s:/,lib,:/$(get_libdir):g" \
		"${WORKDIR}/lua.pc"

	insinto "/usr/$(get_libdir)/pkgconfig"
	newins "${WORKDIR}/lua.pc" "lua${SLOT}.pc"
}

multilib_src_install_all() {
	dodoc README
	dohtml doc/*.html doc/*.png doc/*.css doc/*.gif

	newman doc/lua.1 lua${SLOT}.1
	newman doc/luac.1 luac${SLOT}.1
}

# Makefile contains a dummy target that doesn't do tests
# but causes issues with slotted lua (bug #510360)
src_test() {
	debug-print-function ${FUNCNAME} "$@"
	cd "${WORKDIR}/lua-${TEST_PV}-tests" || die
	# https://www.lua.org/tests/
	# There are two sets:
	# basic
	# complete.
	#
	# The basic subset is selected by passing -e'_U=true'
	# The complete set is noted to contain tests that may consume too much memory or have non-portable tests.
	# attrib.lua for example needs some multilib customization (have to compile the stuff in libs/ for each ABI)
	use test-complete || TEST_OPTS="-e_U=true"
	TEST_MARKER="${T}/test.failed"
	rm -f "${TEST_MARKER}"

	# If we are failing, set the marker file, and only check it after done all ABIs
	abi_src_test() {
		debug-print-function ${FUNCNAME} "$@"
		TEST_LOG="${T}/test.${MULTIBUILD_ID}.log"
		eval "${BUILD_DIR}"/src/lua${SLOT} ${TEST_OPTS} all.lua 2>&1 | tee "${TEST_LOG}" || die
		grep -sq -e "final OK" "${TEST_LOG}" || echo "FAIL ${MULTIBUILD_ID}" >>"${TEST_MARKER}"
		return 0
	}

	multilib_foreach_abi abi_src_test

	if [ -e "${TEST_MARKER}" ]; then
		cat "${TEST_MARKER}"
		die "Tests failed"
	fi
}
