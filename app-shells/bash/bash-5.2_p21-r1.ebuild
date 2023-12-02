# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/chetramey.asc
inherit flag-o-matic toolchain-funcs prefix verify-sig

# Uncomment if we have a patchset
#GENTOO_PATCH_DEV="sam"
#GENTOO_PATCH_VER="${PV}"

# Official patchlevel
# See ftp://ftp.cwru.edu/pub/bash/bash-5.1-patches/
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

# The version of readline this bash normally ships with.
# Note: right now, we don't use the system copy of readline for bash for non-releases.
READLINE_VER="8.2_p1"

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="https://tiswww.case.edu/php/chet/bash/bashtop.html https://git.savannah.gnu.org/cgit/bash.git"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/bash.git"
	EGIT_BRANCH=devel
	inherit git-r3
elif is_release ; then
	SRC_URI="mirror://gnu/bash/${MY_P}.tar.gz"
	SRC_URI+=" verify-sig? ( mirror://gnu/bash/${MY_P}.tar.gz.sig )"

	if [[ ${PLEVEL} -gt 0 ]] ; then
		# bash-5.1 -> bash51
		my_p=${PN}$(ver_rs 1-2 '' $(ver_cut 1-2))

		patch_url=
		my_patch_index=

		upstream_url_base="mirror://gnu/bash"
		mirror_url_base="ftp://ftp.cwru.edu/pub/bash"

		for ((my_patch_index=1; my_patch_index <= ${PLEVEL} ; my_patch_index++)) ; do
			printf -v mangled_patch_ver ${my_p}-%03d ${my_patch_index}
			patch_url="${upstream_url_base}/${MY_P}-patches/${mangled_patch_ver}"

			SRC_URI+=" ${patch_url}"
			SRC_URI+=" verify-sig? ( ${patch_url}.sig )"

			# Add in the mirror URL too.
			SRC_URI+=" ${patch_url/${upstream_url_base}/${mirror_url_base}}"
			SRC_URI+=" verify-sig? ( ${patch_url/${upstream_url_base}/${mirror_url_base}} )"

			MY_PATCHES+=( "${DISTDIR}"/${mangled_patch_ver} )
		done

		unset my_p patch_url my_patch_index upstream_url_base mirror_url_base
	fi
else
	SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz ftp://ftp.cwru.edu/pub/bash/${MY_P}.tar.gz"
	SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${MY_P}.tar.gz.sig ftp://ftp.cwru.edu/pub/bash/${MY_P}.tar.gz.sig )"
fi

if [[ -n ${GENTOO_PATCH_VER} ]] ; then
	SRC_URI+=" https://dev.gentoo.org/~${GENTOO_PATCH_DEV}/distfiles/${CATEGORY}/${PN}/${PN}-${GENTOO_PATCH_VER}-patches.tar.xz"
fi

LICENSE="GPL-3+"
SLOT="0"
if is_release ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi
IUSE="afs bashlogger examples mem-scramble +net nls plugins pgo +readline"

DEPEND="
	>=sys-libs/ncurses-5.2-r2:=
	nls? ( virtual/libintl )
"
if is_release ; then
	DEPEND+=" readline? ( >=sys-libs/readline-${READLINE_VER}:= )"
fi
RDEPEND="
	${DEPEND}
"
# We only need bison (yacc) when the .y files get patched (bash42-005, bash51-011)
BDEPEND="
	pgo? ( dev-util/gperf )
	verify-sig? ( sec-keys/openpgp-keys-chetramey )
"

S="${WORKDIR}/${MY_P}"

# EAPI 8 tries to append it but it doesn't exist here
QA_CONFIGURE_OPTIONS="--disable-static"

PATCHES=(
	#"${WORKDIR}"/${PN}-${GENTOO_PATCH_VER}/

	# Patches from Chet sent to bash-bug ml
	"${FILESDIR}"/${PN}-5.0-syslog-history-extern.patch
	"${FILESDIR}"/${PN}-5.2_p15-random-ub.patch
	"${FILESDIR}"/${PN}-5.2_p15-configure-clang16.patch
	"${FILESDIR}"/${PN}-5.2_p21-wpointer-to-int.patch
	"${FILESDIR}"/${PN}-5.2_p21-configure-strtold.patch
)

pkg_setup() {
	# bug #7332
	if is-flag -malign-double ; then
		eerror "Detected bad CFLAGS '-malign-double'.  Do not use this"
		eerror "as it breaks LFS (struct stat64) on x86."
		die "remove -malign-double from your CFLAGS mr ricer"
	fi

	if use bashlogger ; then
		ewarn "The logging patch should ONLY be used in restricted (i.e. honeypot) envs."
		ewarn "This will log ALL output you enter into the shell, you have been warned."
	fi
}

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	else
		if use verify-sig ; then
			verify-sig_verify_detached "${DISTDIR}"/${MY_P}.tar.gz{,.sig}

			local patch
			for patch in "${MY_PATCHES[@]}" ; do
				verify-sig_verify_detached ${patch}{,.sig}
			done
		fi

		unpack ${MY_P}.tar.gz

		if [[ -n ${GENTOO_PATCH_VER} ]] ; then
			unpack ${PN}-${GENTOO_PATCH_VER}-patches.tar.xz
		fi
	fi
}

src_prepare() {
	# Include official patches
	[[ ${PLEVEL} -gt 0 ]] && eapply -p0 "${MY_PATCHES[@]}"

	# Clean out local libs so we know we use system ones w/releases.
	if is_release ; then
		rm -rf lib/{readline,termcap}/* || die
		touch lib/{readline,termcap}/Makefile.in || die # for config.status
		sed -ri -e 's:\$[{(](RL|HIST)_LIBSRC[)}]/[[:alpha:]_-]*\.h::g' Makefile.in || die
	fi

	# Prefixify hardcoded path names. No-op for non-prefix.
	hprefixify pathnames.h.in

	# Avoid regenerating docs after patches, bug #407985
	sed -i -r '/^(HS|RL)USER/s:=.*:=:' doc/Makefile.in || die
	touch -r . doc/* || die

	# Sometimes hangs (more noticeable w/ pgo), bug #907403.
	rm tests/run-jobs || die

	eapply -p0 "${PATCHES[@]}"
	eapply_user
}

src_configure() {
	# Upstream only test with Bison and require GNUisms like YYEOF and
	# YYERRCODE. The former at least may be in POSIX soon:
	# https://www.austingroupbugs.net/view.php?id=1269.
	# configure warns on use of non-Bison but doesn't abort. The result
	# may misbehave at runtime.
	unset YACC

	local myconf=(
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

	# For descriptions of these, see config-top.h
	# bashrc/#26952 bash_logout/#90488 ssh/#24762 mktemp/#574426
	append-cppflags \
		-DDEFAULT_PATH_VALUE=\'\""${EPREFIX}"/usr/local/sbin:"${EPREFIX}"/usr/local/bin:"${EPREFIX}"/usr/sbin:"${EPREFIX}"/usr/bin:"${EPREFIX}"/sbin:"${EPREFIX}"/bin\"\' \
		-DSTANDARD_UTILS_PATH=\'\""${EPREFIX}"/bin:"${EPREFIX}"/usr/bin:"${EPREFIX}"/sbin:"${EPREFIX}"/usr/sbin\"\' \
		-DSYS_BASHRC=\'\""${EPREFIX}"/etc/bash/bashrc\"\' \
		-DSYS_BASH_LOGOUT=\'\""${EPREFIX}"/etc/bash/bash_logout\"\' \
		-DNON_INTERACTIVE_LOGIN_SHELLS \
		-DSSH_SOURCE_BASHRC \
		$(use bashlogger && echo -DSYSLOG_HISTORY)

	# Don't even think about building this statically without
	# reading bug #7714 first.  If you still build it statically,
	# don't come crying to us with bugs ;).
	#use static && export LDFLAGS="${LDFLAGS} -static"
	use nls || myconf+=( --disable-nls )

	if is_release ; then
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

	if use plugins ; then
		append-ldflags -Wl,-rpath,"${EPREFIX}"/usr/$(get_libdir)/bash
	else
		# Disable the plugins logic by hand since bash doesn't
		# provide a way of doing it.
		export ac_cv_func_dl{close,open,sym}=no \
			ac_cv_lib_dl_dlopen=no ac_cv_header_dlfcn_h=no

		sed -i \
			-e '/LOCAL_LDFLAGS=/s:-rdynamic::' \
			configure || die
	fi

	# bug #444070
	tc-export AR

	econf "${myconf[@]}"
}

src_compile() {
	# -fprofile-partial-training because upstream note the test suite isn't super comprehensive
	# See https://documentation.suse.com/sbp/all/html/SBP-GCC-10/index.html#sec-gcc10-pgo
	local pgo_generate_flags=$(usev pgo "-fprofile-update=atomic -fprofile-dir=${T}/pgo -fprofile-generate=${T}/pgo $(test-flags-CC -fprofile-partial-training)")
	local pgo_use_flags=$(usev pgo "-fprofile-use=${T}/pgo -fprofile-dir=${T}/pgo $(test-flags-CC -fprofile-partial-training)")

	emake CFLAGS="${CFLAGS} ${pgo_generate_flags}"
	use plugins && emake -C examples/loadables CFLAGS="${CFLAGS} ${pgo_generate_flags}" all others

	# Build Bash and run its tests to generate profiles.
	if use pgo ; then
		# Used in test suite.
		unset A

		emake CFLAGS="${CFLAGS} ${pgo_generate_flags}" -k check

		if tc-is-clang; then
			llvm-profdata merge "${T}"/pgo --output="${T}"/pgo/default.profdata || die
		fi

		# Rebuild Bash using the profiling data we just generated.
		emake clean
		emake CFLAGS="${CFLAGS} ${pgo_use_flags}"
		use plugins && emake -C examples/loadables CFLAGS="${CFLAGS} ${pgo_use_flags}" all others
	fi
}

src_test() {
	# Used in test suite.
	unset A

	default
}

src_install() {
	local d f

	default

	dodir /bin
	mv "${ED}"/usr/bin/bash "${ED}"/bin/ || die
	dosym bash /bin/rbash

	insinto /etc/bash
	doins "${FILESDIR}"/bash_logout
	doins "$(prefixify_ro "${FILESDIR}"/bashrc)"

	keepdir /etc/bash/bashrc.d

	insinto /etc/skel
	for f in bash{_logout,_profile,rc} ; do
		newins "${FILESDIR}"/dot-${f} .${f}
	done

	local sed_args=(
		-e 's:#GNU#@::'
		-e '/#@/d'
	)

	if ! use readline ; then
		# bug #432338
		sed_args+=(
			-e '/^shopt -s histappend/s:^:#:'
			-e 's:use_color=true:use_color=false:'
		)
	fi

	sed -i \
		"${sed_args[@]}" \
		"${ED}"/etc/skel/.bashrc \
		"${ED}"/etc/bash/bashrc || die

	if use plugins ; then
		exeinto /usr/$(get_libdir)/bash
		doexe $(echo examples/loadables/*.o | sed 's:\.o::g')

		insinto /usr/include/bash-plugins
		doins *.h builtins/*.h include/*.h lib/{glob/glob.h,tilde/tilde.h}
	fi

	if use examples ; then
		for d in examples/{functions,misc,scripts,startup-files} ; do
			exeinto /usr/share/doc/${PF}/${d}
			docinto ${d}
			for f in ${d}/* ; do
				if [[ ${f##*/} != PERMISSION ]] && [[ ${f##*/} != *README ]] ; then
					doexe ${f}
				else
					dodoc ${f}
				fi
			done
		done
	fi

	# Install bash_builtins.1 and rbash.1
	emake -C doc DESTDIR="${D}" install_builtins
	sed 's:bash\.1:man1/&:' doc/rbash.1 > "${T}"/rbash.1 || die
	doman "${T}"/rbash.1

	newdoc CWRU/changelog ChangeLog
	dosym bash.info /usr/share/info/bashref.info
}

pkg_preinst() {
	if [[ -e ${EROOT}/etc/bashrc ]] && [[ ! -d ${EROOT}/etc/bash ]] ; then
		mkdir -p "${EROOT}"/etc/bash
		mv -f "${EROOT}"/etc/bashrc "${EROOT}"/etc/bash/
	fi
}

pkg_postinst() {
	# If /bin/sh does not exist, provide it
	if [[ ! -e ${EROOT}/bin/sh ]] ; then
		ln -sf bash "${EROOT}"/bin/sh
	fi
}
