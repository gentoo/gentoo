# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools optfeature portability toolchain-funcs

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="https://www.lua.org/"
TEST_PV="5.4.4"
TEST_P="${PN}-${TEST_PV}-tests"
SRC_URI="
	https://www.lua.org/ftp/${P}.tar.gz
	test? ( https://www.lua.org/tests/${TEST_P}.tar.gz )"

LICENSE="MIT"
SLOT="5.4"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+deprecated readline test test-complete"

COMMON_DEPEND="
	>=app-eselect/eselect-lua-3
	readline? ( sys-libs/readline:0= )
	!dev-lang/lua:0"
# Cross-compiling note:
# Must use libtool from the target system (DEPEND) because
# libtool from the build system (BDEPEND) is for building
# native binaries.
DEPEND="
	${COMMON_DEPEND}
	sys-devel/libtool"
RDEPEND="${COMMON_DEPEND}"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/lua-5.4.2-r2-make.patch
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

	# Using dynamic linked lua is not recommended for performance
	# reasons. http://article.gmane.org/gmane.comp.lang.lua.general/18519
	# Mainly, this is of concern if your arch is poor with GPRs, like x86
	# Note that this only affects the interpreter binary (named lua), not the lua
	# compiler (built statically) nor the lua libraries.

	# upstream does not use libtool, but we do (see bug #336167)
	cp "${FILESDIR}/configure.in" "${S}/configure.ac" || die
	eautoreconf
}

src_configure() {
	sed -i \
		-e 's:\(define LUA_ROOT\s*\).*:\1"'${EPREFIX}'/usr/":' \
		-e "s:\(define LUA_CDIR\s*LUA_ROOT \"\)lib:\1$(get_libdir):" \
		src/luaconf.h \
	|| die "failed patching luaconf.h"

	econf
}

src_compile() {
	tc-export CC

	# what to link to liblua
	liblibs="-lm"
	liblibs="${liblibs} $(dlopen_lib)"

	# what to link to the executables
	mylibs=
	use readline && mylibs="-lreadline"

	cd src

	local myCFLAGS=""
	use deprecated && myCFLAGS+="-DLUA_COMPAT_5_3 "
	use readline && myCFLAGS+="-DLUA_USE_READLINE "

	case "${CHOST}" in
		*-mingw*) : ;;
		*) myCFLAGS+="-DLUA_USE_LINUX " ;;
	esac

	emake CC="${CC}" CFLAGS="${myCFLAGS} ${CFLAGS}" \
			SYSLDFLAGS="${LDFLAGS}" \
			RPATH="${EPREFIX}/usr/$(get_libdir)/" \
			LUA_LIBS="${mylibs}" \
			LIB_LIBS="${liblibs}" \
			V=$(ver_cut 1-2) \
			LIBTOOL="${ESYSROOT}/usr/bin/libtool" \
			gentoo_all
}

src_install() {
	emake INSTALL_TOP="${ED}/usr" INSTALL_LIB="${ED}/usr/$(get_libdir)" \
			V=${SLOT} gentoo_install

	case ${SLOT} in
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

	DOCS="README"
	HTML_DOCS="doc/*.html doc/*.png doc/*.css doc/*.gif"
	einstalldocs
	newman doc/lua.1 lua${SLOT}.1
	newman doc/luac.1 luac${SLOT}.1
	find "${ED}" -name '*.la' -delete || die
	find "${ED}" -name 'liblua*.a' -delete || die
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
	TEST_OPTS="$(usex test-complete '' '-e_U=true')"
	TEST_MARKER="${T}/test.failed"
	rm -f "${TEST_MARKER}"

	TEST_LOG="${T}/test.log"
	eval "${S}"/src/lua${SLOT} ${TEST_OPTS} all.lua 2>&1 | tee "${TEST_LOG}" || die
	grep -sq -e "final OK" "${TEST_LOG}" || echo "FAIL" >>"${TEST_MARKER}"

	if [ -e "${TEST_MARKER}" ]; then
		cat "${TEST_MARKER}"
		die "Tests failed"
	fi
}

pkg_postinst() {
	eselect lua set --if-unset "${PN}${SLOT}"

	optfeature "Lua support for Emacs" app-emacs/lua-mode
}
