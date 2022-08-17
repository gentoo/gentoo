# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# There's no standard way of versioning the point releases upstream
# make anyway, so while this was added for RC versions, it's fine
# in general.
QA_PKGCONFIG_VERSION=$(ver_cut 1-2)
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/chetramey.asc
inherit flag-o-matic multilib multilib-minimal preserve-libs toolchain-funcs usr-ldscript verify-sig

# Official patches
# See ftp://ftp.cwru.edu/pub/bash/readline-8.1-patches/
PLEVEL="${PV##*_p}"
MY_PV="${PV/_p*}"
MY_PV="${MY_PV/_/-}"
MY_P="${PN}-${MY_PV}"
is_release() {
	case ${PV} in
		9999|*_alpha*|*_beta*|*_rc*) return 1 ;;
		*) return 0 ;;
	esac
}
[[ ${PV} != *_p* ]] && PLEVEL=0
patches() {
	[[ ${PLEVEL} -eq 0 ]] && return 1
	local opt=$1
	eval set -- {1..${PLEVEL}}
	set -- $(printf "${PN}${MY_PV/\.}-%03d " "$@")
	if [[ ${opt} == -s ]] ; then
		echo "${@/#/${DISTDIR}/}"
	else
		local u
		for u in mirror://gnu/${PN} ftp://ftp.cwru.edu/pub/bash ; do
			printf "${u}/${PN}-${MY_PV}-patches/%s " "$@"
			printf "${u}/${PN}-${MY_PV}-patches/%s.sig " "$@"
		done
	fi
}

DESCRIPTION="Another cute console display library"
HOMEPAGE="https://tiswww.case.edu/php/chet/readline/rltop.html https://git.savannah.gnu.org/cgit/readline.git"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/readline.git"
	EGIT_BRANCH=devel
	inherit git-r3
elif is_release ; then
	SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz $(patches)"
	SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${MY_P}.tar.gz.sig )"
else
	SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz ftp://ftp.cwru.edu/pub/bash/${MY_P}.tar.gz"
	SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${MY_P}.tar.gz.sig ftp://ftp.cwru.edu/pub/bash/${MY_P}.tar.gz.sig )"
fi

if ! is_release ; then
	inherit autotools
fi

LICENSE="GPL-3"
SLOT="0/8"  # subslot matches SONAME major
if is_release ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi
IUSE="static-libs +unicode utils"

RDEPEND=">=sys-libs/ncurses-5.9-r3:=[static-libs?,unicode(+)?,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-chetramey )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.0-no_rpath.patch
	"${FILESDIR}"/${PN}-6.2-rlfe-tgoto.patch #385091
	"${FILESDIR}"/${PN}-7.0-headers.patch
	"${FILESDIR}"/${PN}-8.0-headers.patch

	# TODO: rebase
	#"${FILESDIR}"/${PN}-8.0-darwin-shlib-versioning.patch
)

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	else
		# Needed because we don't want the patches being unpacked
		# (which emits annoying and useless error messages)
		verify-sig_src_unpack
		unpack ${MY_P}.tar.gz
	fi
}

src_prepare() {
	[[ ${PLEVEL} -gt 0 ]] && eapply -p0 $(patches -s)
	default

	is_release || eautoreconf

	if use prefix && [[ ! -x "${BROOT}"/usr/bin/pkg-config ]] ; then
		# If we're bootstrapping, make a guess. We don't have pkg-config
		# around yet. bug #818103.
		# Incorrectly populating this leads to underlinked libreadline.
		local ncurses_libs
		local ncurses_libs_suffix=$(usex unicode w '')

		ncurses_libs="-lncurses${ncurses_libs_suffix}"

		if has_version "sys-libs/ncurses[tinfo(+)]" ; then
			ncurses_libs+=" -ltinfo${ncurses_libs_suffix}"
		fi
	else
		# Force ncurses linking. #71420
		# Use pkg-config to get the right values. #457558
		local ncurses_libs=$($(tc-getPKG_CONFIG) ncurses$(usex unicode w '') --libs)
	fi

	sed -i \
		-e "/^SHLIB_LIBS=/s:=.*:='${ncurses_libs}':" \
		support/shobj-conf || die
	sed -i \
		-e "/^[[:space:]]*LIBS=.-lncurses/s:-lncurses:${ncurses_libs}:" \
		examples/rlfe/configure || die

	# fix building under Gentoo/FreeBSD; upstream FreeBSD deprecated
	# objformat for years, so we don't want to rely on that.
	sed -i -e '/objformat/s:if .*; then:if true; then:' support/shobj-conf || die

	ln -s ../.. examples/rlfe/readline || die # for local readline headers
}

src_configure() {
	# fix implicit decls with widechar funcs
	append-cppflags -D_GNU_SOURCE
	# https://lists.gnu.org/archive/html/bug-readline/2010-07/msg00013.html
	append-cppflags -Dxrealloc=_rl_realloc -Dxmalloc=_rl_malloc -Dxfree=_rl_free

	# Make sure configure picks a better ar than `ar`. #484866
	export ac_cv_prog_AR=$(tc-getAR)

	# Force the test since we used sed above to force it.
	export bash_cv_termcap_lib=ncurses

	# Control cross-compiling cases when we know the right answer.
	# In cases where the C library doesn't support wide characters, readline
	# itself won't work correctly, so forcing the answer below should be OK.
	if tc-is-cross-compiler ; then
		use kernel_Winnt || export bash_cv_func_sigsetjmp='present'
		export bash_cv_func_ctype_nonascii='yes'
		export bash_cv_wcwidth_broken='no' #503312
	fi

	# This is for rlfe, but we need to make sure LDFLAGS doesn't change
	# so we can re-use the config cache file between the two.
	append-ldflags -L.

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myeconfargs=(
		--cache-file="${BUILD_DIR}"/config.cache
		--with-curses
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"

	if use utils && multilib_is_native_abi && ! tc-is-cross-compiler ; then
		# code is full of AC_TRY_RUN()
		mkdir -p examples/rlfe || die
		cd examples/rlfe || die
		ECONF_SOURCE="${S}"/examples/rlfe \
		econf --cache-file="${BUILD_DIR}"/config.cache
	fi
}

multilib_src_compile() {
	emake

	if use utils && multilib_is_native_abi && ! tc-is-cross-compiler ; then
		# code is full of AC_TRY_RUN()
		cd examples/rlfe || die
		local l
		for l in readline history ; do
			ln -s ../../shlib/lib${l}$(get_libname)* lib${l}$(get_libname) || die
			ln -s ../../lib${l}.a lib${l}.a || die
		done
		emake
	fi
}

multilib_src_install() {
	default

	if multilib_is_native_abi ; then
		gen_usr_ldscript -a readline history #4411

		if use utils && ! tc-is-cross-compiler; then
			dobin examples/rlfe/rlfe
		fi
	fi
}

multilib_src_install_all() {
	HTML_DOCS="doc/history.html doc/readline.html doc/rluserman.html" einstalldocs
	dodoc USAGE
	docinto ps
	dodoc doc/*.ps
}
pkg_preinst() {
	# bug #29865
	# Reappeared in #595324 with paludis so keeping this for now...
	preserve_old_lib \
		/$(get_libdir)/lib{history,readline}$(get_libname 4) \
		/$(get_libdir)/lib{history,readline}$(get_libname 5) \
		/$(get_libdir)/lib{history,readline}$(get_libname 6) \
		/$(get_libdir)/lib{history,readline}$(get_libname 7)
}

pkg_postinst() {
	preserve_old_lib_notify \
		/$(get_libdir)/lib{history,readline}$(get_libname 4) \
		/$(get_libdir)/lib{history,readline}$(get_libname 5) \
		/$(get_libdir)/lib{history,readline}$(get_libname 6) \
		/$(get_libdir)/lib{history,readline}$(get_libname 7)
}
