# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib multilib-minimal portability toolchain-funcs versionator flag-o-matic

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="http://www.lua.org/"
SRC_URI="http://www.lua.org/ftp/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+deprecated emacs readline doc"

RDEPEND="readline? ( >=sys-libs/readline-6.2_p5-r1:0=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
PDEPEND="emacs? ( app-emacs/lua-mode )"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/luaconf.h
)

src_prepare() {
	# Correct documentation link
	sed -i -e 's:\(/README\)\("\):\1.gz\2:g' doc/readme.html || die

	# Using dynamic linked lua is not recommended for performance
	# reasons. http://article.gmane.org/gmane.comp.lang.lua.general/18519
	# Mainly, this is of concern if your arch is poor with GPRs, like x86.

	# Therefore both lua interpreter and compiler are statically linked to
	# the core library modules.

	# Note: This patch only adds the required targets to the makefiles
	# instead of relying upon libtool, which fails cross-compiling. Both
	# shared and static versions of lua libraries are installed.
	epatch "${FILESDIR}"/${P}-gentoo-build.patch

	# Rename deprecated functions in scripts
	use deprecated || epatch "${FILESDIR}"/${P}-disable-deprecated.patch

	# Remove readline dependency if not requested
	use readline || epatch "${FILESDIR}"/${P}-disable-readline.patch

	epatch "${FILESDIR}/${P}-fix_vararg_calls.patch"

	# Required by EAPI >= 6
	eapply_user

	# Add documentation URIs if needed
	use doc && \
		HTML_DOCS=( doc/*.{html,css,png,gif} ) && \
		DOCS="HISTORY README"

	# custom Makefiles
	multilib_copy_sources
}

multilib_src_configure() {
	# Fix directories according to FHS/Gentoo policy paths and ABI
	sed -i \
		-e 's:/usr/local:'${EPREFIX}'/usr:' \
		-e 's:/man/:/share/man/:' \
		-e "s:\([/\"]\)\<lib\>:\1$(get_libdir):g" \
		Makefile etc/lua.pc src/luaconf.h doc/manual.html || die
}

multilib_src_compile() {
	append-cflags "-DLUA_USE_LINUX"
	append-ldflags "-Wl,-E"
	tc-export AR CC CPP LD RANLIB
	emake \
		MYLDFLAGS="${LDFLAGS}" \
		MYCFLAGS="${CFLAGS}" \
		linux
}

multilib_src_install() {
	emake -j1 install INSTALL_TOP="${ED}/usr"

	insinto usr/$(get_libdir)/pkgconfig
	doins etc/lua.pc
}

multilib_src_install_all() {
	einstalldocs -r

	doicon etc/lua.ico

	doman doc/lua.1 doc/luac.1
}

multilib_src_test() {
	# These tests MUST succeed for the ebuild to succeed
	local MUST_SUCCEED="bisect cf echo env factorial fib fibfor hello printf sieve
	sort trace-calls trace-globals"

	# These tests MUST fail for the ebuild to succeed
	local MUST_FAIL="readonly"

	cd "${BUILD_DIR}" || die

	local test
	for test in ${MUST_SUCCEED}; do
		src/lua test/${test}.lua || die "test $test failed"
	done

	for test in ${MUST_FAIL}; do
		src/lua test/${test}.lua && die "test $test failed"
	done
}
