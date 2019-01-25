# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils autotools multilib portability toolchain-funcs versionator

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="http://www.lua.org/"
SRC_URI="http://www.lua.org/ftp/${P}.tar.gz"

LICENSE="MIT"
SLOT="5.2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-linux"
IUSE="+deprecated emacs readline static"

RDEPEND="readline? ( sys-libs/readline:0= )
	app-eselect/eselect-lua
	!dev-lang/lua:0"
DEPEND="${RDEPEND}
	sys-devel/libtool"
PDEPEND="emacs? ( app-emacs/lua-mode )"

src_prepare() {
	local PATCH_PV=$(get_version_component_range 1-2)

	epatch "${FILESDIR}"/${PN}-${PATCH_PV}-make-r1.patch

	[ -d "${FILESDIR}/${PV}" ] && \
		EPATCH_SOURCE="${FILESDIR}/${PV}" EPATCH_SUFFIX="upstream.patch" epatch

	sed -i \
		-e 's:\(define LUA_ROOT\s*\).*:\1"'${EPREFIX}'/usr/":' \
		-e "s:\(define LUA_CDIR\s*LUA_ROOT \"\)lib:\1$(get_libdir):" \
		src/luaconf.h \
	|| die "failed patching luaconf.h"

	# correct lua versioning
	sed -i -e 's/\(LIB_VERSION = \)6:1:1/\10:0:0/' src/Makefile

	sed -i -e 's:\(/README\)\("\):\1.gz\2:g' doc/readme.html

	if ! use readline ; then
		sed -i -e '/#define LUA_USE_READLINE/d' src/luaconf.h
	fi

	# Using dynamic linked lua is not recommended for performance
	# reasons. http://article.gmane.org/gmane.comp.lang.lua.general/18519
	# Mainly, this is of concern if your arch is poor with GPRs, like x86
	# Note that this only affects the interpreter binary (named lua), not the lua
	# compiler (built statically) nor the lua libraries (both shared and static
	# are installed)
	if use static ; then
		sed -i -e 's:\(-export-dynamic\):-static \1:' src/Makefile
	fi

	# upstream does not use libtool, but we do (see bug #336167)
	cp "${FILESDIR}/configure.in" "${S}"
	eautoreconf
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
			gentoo_all || die "emake failed"
}

src_install() {
	emake INSTALL_TOP="${ED}/usr" INSTALL_LIB="${ED}/usr/$(get_libdir)" \
			V=${SLOT} gentoo_install \
	|| die "emake install gentoo_install failed"

	dodoc README
	dohtml doc/*.html doc/*.png doc/*.css doc/*.gif

	newman doc/lua.1 lua${SLOT}.1
	newman doc/luac.1 luac${SLOT}.1

	# We want packages to find our things...
	cp "${FILESDIR}/lua.pc" "${WORKDIR}"
	sed -i \
		-e "s:^V=.*:V= ${PATCH_PV}:" \
		-e "s:^R=.*:R= ${PV}:" \
		-e "s:/,lib,:/$(get_libdir):g" \
		"${WORKDIR}/lua.pc"

	insinto "/usr/$(get_libdir)/pkgconfig"
	newins "${WORKDIR}/lua.pc" "lua${SLOT}.pc"
}

# Makefile contains a dummy target that doesn't do tests
# but causes issues with slotted lua (bug #510360)
src_test() { :; }
