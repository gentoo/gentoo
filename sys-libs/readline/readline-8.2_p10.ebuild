# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# There's no standard way of versioning the point releases upstream
# make anyway, so while this was added for RC versions, it's fine
# in general.
QA_PKGCONFIG_VERSION=$(ver_cut 1-2)
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/chetramey.asc
inherit flag-o-matic multilib multilib-minimal preserve-libs toolchain-funcs verify-sig

# Official patches
# See ftp://ftp.cwru.edu/pub/bash/readline-8.1-patches/
PLEVEL="${PV##*_p}"
MY_PV="${PV/_p*}"
MY_PV="${MY_PV/_/-}"
MY_P="${PN}-${MY_PV}"
MY_PATCHES=()

is_release() {
	case ${PV} in
		9999|*_alpha*|*_beta*|*_rc*)
			return 1
			;;
		*)
			return 0
			;;
	esac
}

[[ ${PV} != *_p* ]] && PLEVEL=0

DESCRIPTION="Another cute console display library"
HOMEPAGE="https://tiswww.case.edu/php/chet/readline/rltop.html https://git.savannah.gnu.org/cgit/readline.git"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/readline.git"
	EGIT_BRANCH=devel
	inherit git-r3
elif is_release ; then
	SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz"
	SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/readline-8.1-rlfe-c99.patch.xz"
	SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${MY_P}.tar.gz.sig )"

	if [[ ${PLEVEL} -gt 0 ]] ; then
		# bash-5.1 -> bash51
		my_p=${PN}$(ver_rs 1-2 '' $(ver_cut 1-2))

		patch_url=
		my_patch_index=

		upstream_url_base="mirror://gnu/readline"
		mirror_url_base="ftp://ftp.cwru.edu/pub/readline"

		for ((my_patch_index=1; my_patch_index <= ${PLEVEL} ; my_patch_index++)) ; do
			printf -v mangled_patch_ver ${my_p}-%03d ${my_patch_index}
			patch_url="${upstream_url_base}/${MY_P}-patches/${mangled_patch_ver}"

			SRC_URI+=" ${patch_url}"
			SRC_URI+=" verify-sig? ( ${patch_url}.sig )"

			# Add in the mirror URL too.
			SRC_URI+=" ${patch_url/${upstream_url_base}/${mirror_url_base}}"
			SRC_URI+=" verify-sig? ( ${patch_url/${upstream_url_base}/${mirror_url_base}}.sig )"

			MY_PATCHES+=( "${DISTDIR}"/${mangled_patch_ver} )
		done

		unset my_p patch_url my_patch_index upstream_url_base mirror_url_base
	fi
else
	SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz ftp://ftp.cwru.edu/pub/readline/${MY_P}.tar.gz"
	SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${MY_P}.tar.gz.sig ftp://ftp.cwru.edu/pub/readline/${MY_P}.tar.gz.sig )"
fi

S="${WORKDIR}/${MY_P}"

if ! is_release ; then
	inherit autotools
fi

LICENSE="GPL-3+"
SLOT="0/8"  # subslot matches SONAME major
if is_release ; then
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi
IUSE="static-libs +unicode utils"

RDEPEND=">=sys-libs/ncurses-5.9-r3:=[static-libs?,unicode(+)?,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-chetramey )"

PATCHES=(
	"${FILESDIR}"/${PN}-5.0-no_rpath.patch
	"${FILESDIR}"/${PN}-7.0-headers.patch
	"${FILESDIR}"/${PN}-8.0-headers.patch
	"${WORKDIR}"/${PN}-8.1-rlfe-c99.patch

	# TODO: rebase
	#"${FILESDIR}"/${PN}-8.0-darwin-shlib-versioning.patch
)

src_unpack() {
	local patch

	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		if use verify-sig; then
			verify-sig_verify_detached "${DISTDIR}/${MY_P}.tar.gz"{,.sig}

			for patch in "${MY_PATCHES[@]}"; do
				verify-sig_verify_detached "${patch}"{,.sig}
			done
		fi

		unpack "${MY_P}.tar.gz"
		unpack readline-8.1-rlfe-c99.patch.xz

		#if [[ ${GENTOO_PATCH_VER} ]]; then
		#	unpack "${PN}-${GENTOO_PATCH_VER}-patches.tar.xz"
		#fi
	fi
}

src_prepare() {
	[[ ${PLEVEL} -gt 0 ]] && eapply -p0 "${MY_PATCHES[@]}"

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
		# Force ncurses linking, bug #71420.
		# Use pkg-config to get the right values, bug #457558.
		local ncurses_libs=$($(tc-getPKG_CONFIG) ncurses$(usex unicode w '') --libs)
	fi

	sed -i \
		-e "/^SHLIB_LIBS=/s:=.*:='${ncurses_libs}':" \
		support/shobj-conf || die
	sed -i \
		-e "/^[[:space:]]*LIBS=.-lncurses/s:-lncurses:${ncurses_libs}:" \
		examples/rlfe/configure || die

	# Fix building under Gentoo/FreeBSD; upstream FreeBSD deprecated
	# objformat for years, so we don't want to rely on that.
	sed -i -e '/objformat/s:if .*; then:if true; then:' support/shobj-conf || die

	# For local readline headers
	ln -s ../.. examples/rlfe/readline || die
}

src_configure() {
	# Fix implicit decls with widechar funcs
	append-cppflags -D_GNU_SOURCE
	# https://lists.gnu.org/archive/html/bug-readline/2010-07/msg00013.html
	append-cppflags -Dxrealloc=_rl_realloc -Dxmalloc=_rl_malloc -Dxfree=_rl_free

	# Make sure configure picks a better ar than `ar`, bug #484866
	export ac_cv_prog_AR="$(tc-getAR)"

	# Force the test since we used sed above to force it.
	export bash_cv_termcap_lib=ncurses

	# Control cross-compiling cases when we know the right answer.
	# In cases where the C library doesn't support wide characters, readline
	# itself won't work correctly, so forcing the answer below should be OK.
	if tc-is-cross-compiler ; then
		export bash_cv_func_sigsetjmp="present"
		export bash_cv_func_ctype_nonascii="yes"
		# bug #503312
		export bash_cv_wcwidth_broken="no"
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
		# Code is full of AC_TRY_RUN()
		mkdir -p examples/rlfe || die
		cd examples/rlfe || die

		ECONF_SOURCE="${S}"/examples/rlfe econf --cache-file="${BUILD_DIR}"/config.cache
	fi
}

multilib_src_compile() {
	emake

	if use utils && multilib_is_native_abi && ! tc-is-cross-compiler ; then
		# Code is full of AC_TRY_RUN()
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
	# Reappeared in bug #595324 with paludis so keeping this for now...
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
