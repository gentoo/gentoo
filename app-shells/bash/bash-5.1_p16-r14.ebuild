# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/chetramey.asc
inherit flag-o-matic toolchain-funcs prefix verify-sig

# Uncomment if we have a patchset.
#GENTOO_PATCH_DEV="sam"
#GENTOO_PATCH_VER="${PV}"

MY_PV=${PV/_p*}
MY_PV=${MY_PV/_/-}
MY_P=${PN}-${MY_PV}
MY_PATCHES=()

# Determine the patchlevel. See https://ftp.gnu.org/gnu/bash/bash-5.1-patches/.
case ${PV} in
	*_p*)
		PLEVEL=${PV##*_p}
		;;
	9999|*_alpha*|*_beta*|*_rc*)
		# Set a negative patchlevel to indicate that it's a pre-release.
		PLEVEL=-1
		;;
	*)
		PLEVEL=0
esac

# The version of readline this bash normally ships with. Note that we only use
# the bundled copy of readline for pre-releases.
READLINE_VER="8.1"

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="https://tiswww.case.edu/php/chet/bash/bashtop.html https://git.savannah.gnu.org/cgit/bash.git"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/bash.git"
	EGIT_BRANCH=devel
	inherit git-r3
else
	my_urls=( "mirror://gnu/bash/${MY_P}.tar.gz" )

	# bash-5.1 -> bash51
	my_p=${PN}$(ver_cut 1-2) my_p=${my_p/.}

	for (( my_patch_idx = 1; my_patch_idx <= PLEVEL; my_patch_idx++ )); do
		printf -v my_patch_ver %s-%03d "${my_p}" "${my_patch_idx}"
		my_urls+=( "mirror://gnu/bash/${MY_P}-patches/${my_patch_ver}" )
		MY_PATCHES+=( "${DISTDIR}/${my_patch_ver}" )
	done

	SRC_URI="${my_urls[*]} verify-sig? ( ${my_urls[*]/%/.sig} )"

	unset -v my_urls my_p my_patch_idx my_patch_ver
fi

if [[ ${GENTOO_PATCH_VER} ]]; then
	SRC_URI+=" https://dev.gentoo.org/~${GENTOO_PATCH_DEV:?}/distfiles/${CATEGORY}/${PN}/${PN}-${GENTOO_PATCH_VER:?}-patches.tar.xz"
fi

S=${WORKDIR}/${MY_P}

LICENSE="GPL-3+"
SLOT="${MY_PV}"
if (( PLEVEL >= 0 )); then
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi
IUSE="afs bashlogger examples mem-scramble +net nls plugins +readline"

DEPEND="
	>=sys-libs/ncurses-5.2-r2:=
	nls? ( virtual/libintl )
"
if (( PLEVEL >= 0 )); then
	DEPEND+=" readline? ( >=sys-libs/readline-${READLINE_VER}:= )"
fi
RDEPEND="
	${DEPEND}
"
# We only need bison (yacc) when the .y files get patched (bash42-005, bash51-011).
BDEPEND="
	sys-devel/bison
	verify-sig? ( sec-keys/openpgp-keys-chetramey )
"

# EAPI 8 tries to append it but it doesn't exist here.
QA_CONFIGURE_OPTIONS="--disable-static"

QA_CONFIG_IMPL_DECL_SKIP+=(
	# this is fixed in autoconf 2.71, used in bash 5.2. The check fails
	# regardless of GCC version. bug #916480
	makedev
)

PATCHES=(
	#"${WORKDIR}"/${PN}-${GENTOO_PATCH_VER}/

	# Patches to or from Chet, posted to the bug-bash mailing list.
	"${FILESDIR}/${PN}-5.0-syslog-history-extern.patch"
	"${FILESDIR}/${PN}-5.1_p16-configure-clang16.patch"
)

pkg_setup() {
	# bug #7332
	if is-flag -malign-double; then
		eerror "Detected bad CFLAGS '-malign-double'.  Do not use this"
		eerror "as it breaks LFS (struct stat64) on x86."
		die "remove -malign-double from your CFLAGS mr ricer"
	fi

	if use bashlogger; then
		ewarn "The logging patch should ONLY be used in restricted (i.e. honeypot) envs."
		ewarn "This will log ALL output you enter into the shell, you have been warned."
	fi
}

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

		if [[ ${GENTOO_PATCH_VER} ]]; then
			unpack "${PN}-${GENTOO_PATCH_VER}-patches.tar.xz"
		fi
	fi
}

src_prepare() {
	# Include official patches.
	(( PLEVEL > 0 )) && eapply -p0 "${MY_PATCHES[@]}"

	# Clean out local libs so we know we use system ones w/releases. The
	# touch utility is invoked for the benefit of config.status.
	if (( PLEVEL >= 0 )); then
		rm -rf lib/{readline,termcap}/* \
		&& touch lib/{readline,termcap}/Makefile.in \
		&& sed -i -E 's:\$[{(](RL|HIST)_LIBSRC[)}]/[[:alpha:]_-]*\.h::g' Makefile.in \
		|| die
	fi

	# Prefixify hardcoded path names. No-op for non-prefix.
	hprefixify pathnames.h.in

	# Avoid regenerating docs after patches, bug #407985.
	sed -i -E '/^(HS|RL)USER/s:=.*:=:' doc/Makefile.in \
	&& touch -r . doc/* \
	|| die

	eapply -p0 "${PATCHES[@]}"
	eapply_user
}

src_configure() {
	local -a myconf

	# Upstream only test with Bison and require GNUisms like YYEOF and
	# YYERRCODE. The former at least may be in POSIX soon:
	# https://www.austingroupbugs.net/view.php?id=1269.
	# configure warns on use of non-Bison but doesn't abort. The result
	# may misbehave at runtime.
	unset -v YACC

	# bash 5.3 drops unprototyped functions, earlier versions are
	# incompatible with C23.
	append-cflags $(test-flags-CC -std=gnu17)

	if tc-is-cross-compiler; then
		export CFLAGS_FOR_BUILD="${BUILD_CFLAGS} -std=gnu17"
	fi

	myconf=(
		--disable-profiling

		# Force linking with system curses ... the bundled termcap lib
		# sucks bad compared to ncurses.  For the most part, ncurses
		# is here because readline needs it.  But bash itself calls
		# ncurses in one or two small places :(.
		--with-curses

		$(use_enable mem-scramble)
		$(use_enable net net-redirections)
		$(use_enable readline)
		$(use_enable readline bang-history)
		$(use_enable readline history)
		$(use_with afs)
		$(use_with mem-scramble bash-malloc)
	)

	# For descriptions of these, see config-top.h.
	# bashrc/#26952 bash_logout/#90488 ssh/#24762 mktemp/#574426
	append-cppflags \
		-DDEFAULT_PATH_VALUE=\'\""${EPREFIX}"/usr/local/sbin:"${EPREFIX}"/usr/local/bin:"${EPREFIX}"/usr/sbin:"${EPREFIX}"/usr/bin:"${EPREFIX}"/sbin:"${EPREFIX}"/bin\"\' \
		-DSTANDARD_UTILS_PATH=\'\""${EPREFIX}"/bin:"${EPREFIX}"/usr/bin:"${EPREFIX}"/sbin:"${EPREFIX}"/usr/sbin\"\' \
		-DSYS_BASHRC=\'\""${EPREFIX}"/etc/bash/bashrc\"\' \
		-DSYS_BASH_LOGOUT=\'\""${EPREFIX}"/etc/bash/bash_logout\"\' \
		-DNON_INTERACTIVE_LOGIN_SHELLS \
		-DSSH_SOURCE_BASHRC \
		$(use bashlogger && echo -DSYSLOG_HISTORY)

	use nls || myconf+=( --disable-nls )

	if (( PLEVEL >= 0 )); then
		# Historically, we always used the builtin readline, but since
		# our handling of SONAME upgrades has gotten much more stable
		# in the PM (and the readline ebuild itself preserves the old
		# libs during upgrades), linking against the system copy should
		# be safe.
		# Exact cached version here doesn't really matter as long as it
		# is at least what's in the DEPEND up above.
		export ac_cv_rl_version=${READLINE_VER%%_*}

		# Use system readline only with released versions.
		myconf+=( --with-installed-readline=. )
	fi

	if use plugins; then
		append-ldflags "-Wl,-rpath,${EPREFIX}/usr/$(get_libdir)/bash"
	else
		# Disable the plugins logic by hand since bash doesn't provide
		# a way of doing it.
		export ac_cv_func_dl{close,open,sym}=no \
			ac_cv_lib_dl_dlopen=no ac_cv_header_dlfcn_h=no

		sed -i -e '/LOCAL_LDFLAGS=/s:-rdynamic::' configure || die
	fi

	# bug #444070
	tc-export AR

	econf "${myconf[@]}"
}

src_compile() {
	emake

	if use plugins; then
		emake -C examples/loadables all others
	fi
}

src_install() {
	into /
	newbin bash bash-${SLOT}

	newman doc/bash.1 bash-${SLOT}.1
	newman doc/builtins.1 builtins-${SLOT}.1

	insinto /usr/share/info
	newins doc/bashref.info bash-${SLOT}.info
	dosym bash-${SLOT}.info /usr/share/info/bashref-${SLOT}.info

	dodoc README NEWS AUTHORS CHANGES COMPAT Y2K doc/FAQ doc/INTRO
}
