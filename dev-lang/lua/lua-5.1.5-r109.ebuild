# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature portability toolchain-funcs

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="https://www.lua.org/"
SRC_URI="https://www.lua.org/ftp/${P}.tar.gz"

LICENSE="MIT"
SLOT="5.1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+deprecated readline"

COMMON_DEPEND="
	>=app-eselect/eselect-lua-3
	readline? ( >=sys-libs/readline-6.2_p5-r1:0= )
	!dev-lang/lua:0"
# Cross-compiling note:
# Must use libtool from the target system (DEPEND) because
# libtool from the build system (BDEPEND) is for building
# native binaries.
DEPEND="
	${COMMON_DEPEND}
	sys-devel/libtool"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	PATCHES=(
		"${FILESDIR}/lua-5.1.5-make.patch"
		"${FILESDIR}/${PN}-$(ver_cut 1-2)-module_paths.patch"
	)
	if ! use deprecated ; then
		# patches from 5.1.4 still apply
		PATCHES+=(
			"${FILESDIR}"/${PN}-5.1.4-deprecated.patch
			"${FILESDIR}"/${PN}-5.1.4-test.patch
		)
	fi
	if ! use readline ; then
		PATCHES+=(
			"${FILESDIR}"/${PN}-$(ver_cut 1-2)-readline.patch
		)
	fi

	default

	# use glibtool on Darwin (versus Apple libtool)
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e '/LIBTOOL = /s:libtool:glibtool:' \
			Makefile src/Makefile || die
	fi

	# correct lua versioning
	sed -i -e 's/\(LIB_VERSION = \)6:1:1/\16:5:1/' src/Makefile

	sed -i -e 's:\(/README\)\("\):\1.gz\2:g' doc/readme.html

	# Using dynamic linked lua is not recommended for performance
	# reasons. http://article.gmane.org/gmane.comp.lang.lua.general/18519
	# Mainly, this is of concern if your arch is poor with GPRs, like x86
	# Note that this only affects the interpreter binary (named lua), not the lua
	# compiler (built statically) nor the lua libraries.

	# A slotted Lua uses different directories for headers & names for
	# libraries, and pkgconfig should reflect that.
	sed -r -i \
		-e "/^INSTALL_INC=/s,(/include)$,\1/lua${SLOT}," \
		-e "/^includedir=/s,(/include)$,\1/lua${SLOT}," \
		-e "/^Libs:/s,((-llua)($| )),\2${SLOT}\3," \
		"${S}"/etc/lua.pc
}

src_configure() {
	# We want packages to find our things...
	sed -i \
		-e 's:/usr/local:'${EPREFIX}'/usr:' \
		-e "s:\([/\"]\)\<lib\>:\1$(get_libdir):g" \
		etc/lua.pc src/luaconf.h || die
}

src_compile() {
	tc-export CC
	myflags=
	# what to link to liblua
	liblibs="-lm"
	liblibs="${liblibs} $(dlopen_lib)"

	# what to link to the executables
	mylibs=
	if use readline; then
		mylibs="-lreadline"
	fi

	cd src
	emake CC="${CC}" CFLAGS="-DLUA_USE_LINUX ${CFLAGS}" \
			RPATH="${EPREFIX}/usr/$(get_libdir)/" \
			LUA_LIBS="${mylibs}" \
			LIB_LIBS="${liblibs}" \
			V=$(ver_cut 1-2) \
			LIBTOOL="${ESYSROOT}/usr/bin/libtool" \
			gentoo_all

	mv lua_test ../test/lua.static
}

src_install() {
	emake INSTALL_TOP="${ED}/usr" INSTALL_LIB="${ED}/usr/$(get_libdir)" \
			V=${SLOT} gentoo_install

	insinto /usr/$(get_libdir)/pkgconfig
	newins etc/lua.pc lua${SLOT}.pc

	DOCS="HISTORY README"
	HTML_DOCS="doc/*.html doc/*.png doc/*.css doc/*.gif"
	einstalldocs
	newman doc/lua.1 lua${SLOT}.1
	newman doc/luac.1 luac${SLOT}.1
	find "${ED}" -name '*.la' -delete || die
	find "${ED}" -name 'liblua*.a' -delete || die
}

src_test() {
	local positive="bisect cf echo env factorial fib fibfor hello printf sieve
	sort trace-calls trace-globals"
	local negative="readonly"
	local test

	cd "${S}" || die
	for test in ${positive}; do
		test/lua.static test/${test}.lua || die "test $test failed"
	done

	for test in ${negative}; do
		test/lua.static test/${test}.lua && die "test $test failed"
	done
}

pkg_postinst() {
	eselect lua set --if-unset "${PN}${SLOT}"

	optfeature "Lua support for Emacs" app-emacs/lua-mode
}
