# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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

# Determine the patchlevel.
case ${PV} in
	9999|*_alpha*|*_beta*|*_rc*)
		# Set a negative patchlevel to indicate that it's a pre-release.
		PLEVEL=-1
		;;
	*_p*)
		PLEVEL=${PV##*_p}
		;;
	*)
		PLEVEL=0
esac

DESCRIPTION="Another cute console display library"
HOMEPAGE="https://tiswww.case.edu/php/chet/readline/rltop.html https://git.savannah.gnu.org/cgit/readline.git"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/readline.git"
	EGIT_BRANCH=devel
	inherit git-r3
elif (( PLEVEL < 0 )) && [[ ${PV} == *_p* ]] ; then
	# It can be useful to have snapshots in the pre-release period once
	# the first alpha is out, as various bugs get reported and fixed from
	# the alpha, and the next pre-release is usually quite far away.
	#
	# i.e. if it's worth packaging the alpha, it's worth packaging a followup.
	READLINE_COMMIT="7cf2d923617659d216db3210f6247740f7dde1d8"
	SRC_URI="https://git.savannah.gnu.org/cgit/readline.git/snapshot/readline-${READLINE_COMMIT}.tar.gz -> ${P}-${READLINE_COMMIT}.tar.gz"
	S=${WORKDIR}/${PN}-${READLINE_COMMIT}
else
	SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz"
	SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${MY_P}.tar.gz.sig )"
	S="${WORKDIR}/${MY_P}"

	if [[ ${PLEVEL} -gt 0 ]] ; then
		# bash-5.1 -> bash51
		my_p=${PN}$(ver_rs 1-2 '' $(ver_cut 1-2))

		patch_url=
		my_patch_index=

		upstream_url_base="mirror://gnu/readline"

		for ((my_patch_index=1; my_patch_index <= ${PLEVEL} ; my_patch_index++)) ; do
			printf -v mangled_patch_ver ${my_p}-%03d ${my_patch_index}
			patch_url="${upstream_url_base}/${MY_P}-patches/${mangled_patch_ver}"

			SRC_URI+=" ${patch_url}"
			SRC_URI+=" verify-sig? ( ${patch_url}.sig )"

			MY_PATCHES+=( "${DISTDIR}"/${mangled_patch_ver} )
		done

		unset my_p patch_url my_patch_index upstream_url_base
	fi
fi

LICENSE="GPL-3+"
SLOT="0/8"  # subslot matches SONAME major
if (( PLEVEL >= 0 )); then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi
IUSE="static-libs +unicode utils"

RDEPEND=">=sys-libs/ncurses-5.9-r3:=[static-libs?,unicode(+)?,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-chetramey )
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.0-no_rpath.patch
	"${FILESDIR}"/${PN}-7.0-headers.patch
	"${FILESDIR}"/${PN}-8.0-headers.patch
	"${FILESDIR}"/${PN}-8.3-iwd-crash.patch
)

src_unpack() {
	local patch

	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	elif (( PLEVEL < 0 )) && [[ ${PV} == *_p* ]] ; then
		default
	else
		if use verify-sig; then
			verify-sig_verify_detached "${DISTDIR}/${MY_P}.tar.gz"{,.sig}

			for patch in "${MY_PATCHES[@]}"; do
				verify-sig_verify_detached "${patch}"{,.sig}
			done
		fi

		unpack "${MY_P}.tar.gz"

		if [[ ${GENTOO_PATCH_VER} ]]; then
			unpack "${PN}-${GENTOO_PATCH_VER}-patches.tar.xz"
		fi
	fi
}

src_prepare() {
	(( PLEVEL > 0 )) && eapply -p0 "${MY_PATCHES[@]}"

	default

	#(( PLEVEL < 0 )) && eautoreconf

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
		-e "/[[:space:]]*LIBS=.-lncurses/s:-lncurses:${ncurses_libs}:" \
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
