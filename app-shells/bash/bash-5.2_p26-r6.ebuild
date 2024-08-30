# Copyright 1999-2024 Gentoo Authors
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

# Determine the patchlevel. See ftp://ftp.gnu.org/gnu/bash/bash-5.2-patches/.
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
READLINE_VER="8.2_p1"

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="https://tiswww.case.edu/php/chet/bash/bashtop.html https://git.savannah.gnu.org/cgit/bash.git"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/bash.git"
	EGIT_BRANCH=devel
	inherit git-r3
else
	my_urls=( {'mirror://gnu/bash','ftp://ftp.cwru.edu/pub/bash'}/"${MY_P}.tar.gz" )

	# bash-5.1 -> bash51
	my_p=${PN}$(ver_cut 1-2) my_p=${my_p/.}

	for (( my_patch_idx = 1; my_patch_idx <= PLEVEL; my_patch_idx++ )); do
		printf -v my_patch_ver %s-%03d "${my_p}" "${my_patch_idx}"
		my_urls+=( {'mirror://gnu/bash','ftp://ftp.cwru.edu/pub/bash'}/"${MY_P}-patches/${my_patch_ver}" )
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
SLOT="0"
if (( PLEVEL >= 0 )); then
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi
IUSE="afs bashlogger examples mem-scramble +net nls plugins pgo +readline"

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
	pgo? ( dev-util/gperf )
	verify-sig? ( sec-keys/openpgp-keys-chetramey )
"

# EAPI 8 tries to append it but it doesn't exist here.
QA_CONFIGURE_OPTIONS="--disable-static"

PATCHES=(
	#"${WORKDIR}"/${PN}-${GENTOO_PATCH_VER}/

	# Patches to or from Chet, posted to the bug-bash mailing list.
	"${FILESDIR}/${PN}-5.0-syslog-history-extern.patch"
	"${FILESDIR}/${PN}-5.2_p15-random-ub.patch"
	"${FILESDIR}/${PN}-5.2_p15-configure-clang16.patch"
	"${FILESDIR}/${PN}-5.2_p21-wpointer-to-int.patch"
	"${FILESDIR}/${PN}-5.2_p21-configure-strtold.patch"
	"${FILESDIR}/${PN}-5.2_p26-memory-leaks.patch"
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

	# Sometimes hangs (more noticeable w/ pgo), bug #907403.
	rm tests/run-jobs || die

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
	local -a pgo_generate_flags pgo_use_flags
	local flag

	# -fprofile-partial-training because upstream notes the test suite isn't
	# super comprehensive.
	# https://documentation.suse.com/sbp/all/html/SBP-GCC-10/index.html#sec-gcc10-pgo
	if use pgo; then
		pgo_generate_flags=(
			-fprofile-update=atomic
			-fprofile-dir="${T}"/pgo
			-fprofile-generate="${T}"/pgo
		)
		pgo_use_flags=(
			-fprofile-use="${T}"/pgo
			-fprofile-dir="${T}"/pgo
		)
		if flag=$(test-flags-CC -fprofile-partial-training); then
			pgo_generate_flags+=( "${flag}" )
			pgo_use_flags+=( "${flag}" )
		fi
	fi

	emake CFLAGS="${CFLAGS} ${pgo_generate_flags[*]}"
	use plugins && emake -C examples/loadables CFLAGS="${CFLAGS} ${pgo_generate_flags[*]}" all others

	# Build Bash and run its tests to generate profiles.
	if (( ${#pgo_generate_flags[@]} )); then
		# Used in test suite.
		unset -v A

		emake CFLAGS="${CFLAGS} ${pgo_generate_flags[*]}" -k check

		if tc-is-clang; then
			llvm-profdata merge "${T}"/pgo --output="${T}"/pgo/default.profdata || die
		fi

		# Rebuild Bash using the profiling data we just generated.
		emake clean
		emake CFLAGS="${CFLAGS} ${pgo_use_flags[*]}"
		use plugins && emake -C examples/loadables CFLAGS="${CFLAGS} ${pgo_use_flags[*]}" all others
	fi
}

src_test() {
	# Used in test suite.
	unset -v A

	default
}

src_install() {
	local d f

	default

	my_prefixify() {
		while read -r; do
			if [[ $REPLY == *$1* ]]; then
				REPLY=${REPLY/"/etc/"/"${EPREFIX}/etc/"}
			fi
			printf '%s\n' "${REPLY}" || ! break
		done < "$2" || die
	}

	dodir /bin
	mv -- "${ED}"/usr/bin/bash "${ED}"/bin/ || die
	dosym bash /bin/rbash

	insinto /etc/bash
	doins "${FILESDIR}"/bash_logout
	my_prefixify bashrc.d "${FILESDIR}"/bashrc-r1 | newins - bashrc

	insinto /etc/bash/bashrc.d
	my_prefixify DIR_COLORS "${FILESDIR}"/bashrc.d/10-gentoo-color.bash | newins - 10-gentoo-color.bash
	doins "${FILESDIR}"/bashrc.d/10-gentoo-title.bash
	if [[ ! ${EPREFIX} ]]; then
		doins "${FILESDIR}"/bashrc.d/15-gentoo-bashrc-check.bash
	fi

	insinto /etc/skel
	for f in bash{_logout,_profile,rc}; do
		newins "${FILESDIR}/dot-${f}" ".${f}"
	done

	if use plugins; then
		exeinto "/usr/$(get_libdir)/bash"
		set -- examples/loadables/*.o
		doexe "${@%.o}"

		insinto /usr/include/bash-plugins
		doins *.h builtins/*.h include/*.h lib/{glob/glob.h,tilde/tilde.h}
	fi

	if use examples; then
		for d in examples/{functions,misc,scripts,startup-files}; do
			exeinto "/usr/share/doc/${PF}/${d}"
			docinto "${d}"
			for f in "${d}"/*; do
				if [[ ${f##*/} != @(PERMISSION|*README) ]]; then
					doexe "${f}"
				else
					dodoc "${f}"
				fi
			done
		done
	fi

	# Install bash_builtins.1 and rbash.1.
	emake -C doc DESTDIR="${D}" install_builtins
	sed 's:bash\.1:man1/&:' doc/rbash.1 > "${T}"/rbash.1 || die
	doman "${T}"/rbash.1

	newdoc CWRU/changelog ChangeLog
	dosym bash.info /usr/share/info/bashref.info
}

pkg_preinst() {
	if [[ -e ${EROOT}/etc/bashrc ]] && [[ ! -d ${EROOT}/etc/bash ]]; then
		mkdir -p -- "${EROOT}"/etc/bash \
		&& mv -f -- "${EROOT}"/etc/bashrc "${EROOT}"/etc/bash/ \
		|| die
	fi
}

pkg_postinst() {
	local old_ver

	# If /bin/sh does not exist, provide it.
	if [[ ! -e ${EROOT}/bin/sh ]]; then
		ln -sf -- bash "${EROOT}"/bin/sh || die
	fi

	read -r old_ver <<<"${REPLACING_VERSIONS}"
	if [[ ! $old_ver ]]; then
		:
	elif ver_test "$old_ver" -ge "5.2" && ver_test "$old_ver" -ge "5.2_p26-r6"; then
		return
	elif ver_test "$old_ver" -lt "5.2" && ver_test "$old_ver" -ge "5.1_p16-r13"; then
		return
	fi

	while read -r; do ewarn "${REPLY}"; done <<'EOF'
Files situated under /etc/bash/bashrc.d must now have a suffix of .sh or .bash.

Gentoo now defaults to defining PROMPT_COMMAND as an array. Depending on the
characteristics of the operating environment, this array may contain a command
to set the terminal's window title. Those already choosing to customise the
PROMPT_COMMAND variable are now advised to append their commands like so:

PROMPT_COMMAND+=('custom command goes here')

Gentoo no longer defaults to having bash manipulate the window title in the case
that the terminal is controlled by sshd(8), unless screen or tmux are in use.
Those wanting to set the title unconditionally may adjust ~/.bashrc - or create
a custom /etc/bash/bashrc.d drop-in - to set PROMPT_COMMMAND like so:

PROMPT_COMMAND=(genfun_set_win_title)

Those who would prefer for bash never to interfere with the window title may
now opt out of the default title setting behaviour, either with the "unset -v
PROMPT_COMMAND" command or by re-defining PROMPT_COMMAND as desired.
EOF
}
