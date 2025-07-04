# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs prefix

# Uncomment if we have a patchset
GENTOO_PATCH_DEV="sam"
GENTOO_PATCH_VER="${PV}-r2"

# Official patchlevel
# See ftp://ftp.cwru.edu/pub/bash/bash-4.4-patches/
PLEVEL="${PV##*_p}"
MY_PV="${PV/_p*}"
MY_PV="${MY_PV/_/-}"
MY_P="${PN}-${MY_PV}"
is_release() {
	case ${PV} in
	*_alpha*|*_beta*|*_rc*) return 1 ;;
	*) return 0 ;;
	esac
}
[[ ${PV} != *_p* ]] && PLEVEL=0
patches() {
	local opt=${1} plevel=${2:-${PLEVEL}} pn=${3:-${PN}} pv=${4:-${MY_PV}}
	[[ ${plevel} -eq 0 ]] && return 1
	eval set -- {1..${plevel}}
	set -- $(printf "${pn}${pv/\.}-%03d " "$@")
	if [[ ${opt} == -s ]] ; then
		echo "${@/#/${DISTDIR}/}"
	else
		printf "mirror://gnu/${pn}/${pn}-${pv}-patches/%s " "$@"
	fi
}

# The version of readline this bash normally ships with.
READLINE_VER="7.0"

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="https://tiswww.case.edu/php/chet/bash/bashtop.html"
if is_release ; then
	SRC_URI="mirror://gnu/bash/${MY_P}.tar.gz $(patches)"
fi

if [[ -n ${GENTOO_PATCH_VER} ]] ; then
	SRC_URI+=" https://dev.gentoo.org/~${GENTOO_PATCH_DEV}/distfiles/${CATEGORY}/${PN}/${PN}-${GENTOO_PATCH_VER}-patches.tar.xz"
fi

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="${MY_PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="afs bashlogger examples mem-scramble +net nls plugins +readline"

DEPEND="
	>=sys-libs/ncurses-5.2-r2:0=
	nls? ( virtual/libintl )
	readline? ( >=sys-libs/readline-${READLINE_VER}:0= )
"
RDEPEND="
	${DEPEND}
"
# We only need bison (yacc) when the .y files get patched (bash42-005)
#BDEPEND="sys-devel/bison"

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
	unpack ${MY_P}.tar.gz

	if [[ -n ${GENTOO_PATCH_VER} ]] ; then
		unpack ${PN}-${GENTOO_PATCH_VER}-patches.tar.xz
	fi
}

src_prepare() {
	# Include official patches
	[[ ${PLEVEL} -gt 0 ]] && eapply -p0 $(patches -s)

	eapply "${WORKDIR}"/${P}-r2-patches/${PN}-4.4-jobs_overflow.patch # bug #644720
	eapply "${WORKDIR}"/${P}-r2-patches/${PN}-4.4-set-SHOBJ_STATUS.patch # bug #644720

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

	eapply_user
}

src_configure() {
	# Upstream only test with Bison and require GNUisms like YYEOF and
	# YYERRCODE. The former at least may be in POSIX soon:
	# https://www.austingroupbugs.net/view.php?id=1269.
	# configure warns on use of non-Bison but doesn't abort. The result
	# may misbehave at runtime.
	unset YACC

	# bash 5.3 drops unprototyped functions, earlier versions are
	# incompatible with C23.
	append-cflags $(test-flags-CC -std=gnu17)

	if tc-is-cross-compiler; then
		export CFLAGS_FOR_BUILD="${BUILD_CFLAGS} -std=gnu17"
	fi

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

	# Historically, we always used the builtin readline, but since
	# our handling of SONAME upgrades has gotten much more stable
	# in the PM (and the readline ebuild itself preserves the old
	# libs during upgrades), linking against the system copy should
	# be safe.
	# Exact cached version here doesn't really matter as long as it
	# is at least what's in the DEPEND up above.
	export ac_cv_rl_version=${READLINE_VER%%_*}

	if is_release ; then
		# Use system readline only with released versions.
		myconf+=( --with-installed-readline=. )
	fi

	if use plugins ; then
		append-ldflags -Wl,-rpath,/usr/$(get_libdir)/bash
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
	emake

	if use plugins ; then
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
