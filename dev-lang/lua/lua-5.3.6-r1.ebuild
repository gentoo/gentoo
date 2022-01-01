# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib multilib-minimal portability toolchain-funcs

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="http://www.lua.org/"
TEST_PV="5.3.4"
TEST_A="${PN}-${TEST_PV}-tests.tar.gz"
PKG_A="${P}.tar.gz"
SRC_URI="
	http://www.lua.org/ftp/${PKG_A}
	test? ( https://www.lua.org/tests/${TEST_A} )"

LICENSE="MIT"
SLOT="5.3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+deprecated readline static test test-complete"
RESTRICT="!test? ( test )"

RDEPEND="readline? ( sys-libs/readline:0= )
	app-eselect/eselect-lua
	!dev-lang/lua:0"
DEPEND="${RDEPEND}
	sys-devel/libtool"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/lua${SLOT}/luaconf.h
)

PATCHES=(
	"${FILESDIR}/${PN}-$(ver_cut 1-2)-make-r1.patch"
)

src_prepare() {
	default

	# use glibtool on Darwin (versus Apple libtool)
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e '/LIBTOOL = /s:/libtool:/glibtool:' \
			Makefile src/Makefile || die
	fi

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
	use deprecated && myCFLAGS="-DLUA_COMPAT_5_1 -DLUA_COMPAT_5_2"

	case "${CHOST}" in
		*-mingw*) : ;;
		*) myCFLAGS+=" -DLUA_USE_LINUX" ;;
	esac

	emake CC="${CC}" CFLAGS="${myCFLAGS} ${CFLAGS}" \
			SYSLDFLAGS="${LDFLAGS}" \
			RPATH="${EPREFIX}/usr/$(get_libdir)/" \
			LUA_LIBS="${mylibs}" \
			LIB_LIBS="${liblibs}" \
			V=$(ver_cut 1-2) \
			gentoo_all
}

multilib_src_install() {
	emake INSTALL_TOP="${ED}/usr" INSTALL_LIB="${ED}/usr/$(get_libdir)" \
			V=${SLOT} gentoo_install

	case $SLOT in
		0)
			LIBNAME="lua"
			INCLUDEDIR_SUFFIX=''
			;;
		*)	LIBNAME="lua${SLOT}"
			INCLUDEDIR_SUFFIX="/lua${SLOT}"
			;;
	esac

	# We want packages to find our things...
	# A slotted Lua uses different directories for headers & names for
	# libraries, and pkgconfig should reflect that.
	local PATCH_PV=$(ver_cut 1-2)
	cp "${FILESDIR}/lua.pc" "${WORKDIR}" || die
	sed -r -i \
		-e "/^INSTALL_INC=/s,(/include)$,\1/lua${SLOT}," \
		-e "s:^prefix= :prefix= ${EPREFIX}:" \
		-e "s:^V=.*:V= ${PATCH_PV}:" \
		-e "s:^R=.*:R= ${PV}:" \
		-e "s:/,lib,:/$(get_libdir):g" \
		-e "/^Libs:/s:( )(-llua)($| ):\1-l${LIBNAME}\3:" \
		-e "/^includedir=/s:include$:include${INCLUDEDIR_SUFFIX}:" \
		"${WORKDIR}/lua.pc" || die

	insinto "/usr/$(get_libdir)/pkgconfig"
	newins "${WORKDIR}/lua.pc" "lua${SLOT}.pc"
	# Copy Debian's symlink support:
	# https://salsa.debian.org/lua-team/lua5.3/blob/master/debian/rules#L19
	# FreeBSD calls the pkgconfig 'lua-5.3.pc'
	# Older systems called it 'lua53.pc'
	dosym "lua${SLOT}.pc" "/usr/$(get_libdir)/pkgconfig/lua-${SLOT}.pc"
	dosym "lua${SLOT}.pc" "/usr/$(get_libdir)/pkgconfig/lua${SLOT/.}.pc"
}

multilib_src_install_all() {
	DOCS="README"
	HTML_DOCS="doc/*.html doc/*.png doc/*.css doc/*.gif"
	einstalldocs
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

pkg_postinst() {
	if has_version "app-editor/emacs"; then
		if ! has_version "app-emacs/lua-mode"; then
			einfo "Install app-emacs/lua-mode for lua support for emacs"
		fi
	fi
}
