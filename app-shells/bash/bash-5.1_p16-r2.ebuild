# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/chetramey.asc
inherit flag-o-matic toolchain-funcs prefix verify-sig

# Uncomment if we have a patchset
GENTOO_PATCH_DEV="sam"
GENTOO_PATCH_VER="${PV}"

# Official patchlevel
# See ftp://ftp.cwru.edu/pub/bash/bash-5.1-patches/
PLEVEL="${PV##*_p}"
MY_PV="${PV/_p*}"
MY_PV="${MY_PV/_/-}"
MY_P="${PN}-${MY_PV}"
MY_PATCHES=()

is_release() {
	case ${PV} in
		*_alpha*|*_beta*|*_rc*)
			return 1
			;;
		*)
			return 0
			;;
	esac
}

[[ ${PV} != *_p* ]] && PLEVEL=0

# The version of readline this bash normally ships with.
READLINE_VER="8.1"

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="https://tiswww.case.edu/php/chet/bash/bashtop.html"

if is_release ; then
	SRC_URI="mirror://gnu/bash/${MY_P}.tar.gz"
	SRC_URI+=" verify-sig? ( mirror://gnu/bash/${MY_P}.tar.gz.sig )"

	if [[ ${PLEVEL} -gt 0 ]] ; then
		# bash-5.1 -> bash51
		my_p=${PN}$(ver_rs 1-2 '' $(ver_cut 1-2))

	        patch_url=
		my_patch_index=

		for ((my_patch_index=1; my_patch_index <= ${PLEVEL} ; my_patch_index++)) ; do
			for url in mirror://gnu/${pn} ftp://ftp.cwru.edu/pub/bash ; do
				patch_url=$(printf "${url}/${PN}-$(ver_cut 1-2)-patches/${my_p}-%03d" ${my_patch_index})
				SRC_URI+=" ${patch_url}"
				SRC_URI+=" verify-sig? ( ${patch_url}.sig )"

			done

			MY_PATCHES+=( "${DISTDIR}"/$(printf ${my_p}-%03d ${my_patch_index}) )
		done

		unset my_pn patch_url my_patch_index
	fi
else
	SRC_URI="ftp://ftp.cwru.edu/pub/bash/${MY_P}.tar.gz"
	SRC_URI+=" verify-sig? ( ftp://ftp.cwru.edu/pub/bash/${MY_P}.tar.gz.sig )"
fi

if [[ -n ${GENTOO_PATCH_VER} ]] ; then
	SRC_URI+=" https://dev.gentoo.org/~${GENTOO_PATCH_DEV}/distfiles/${CATEGORY}/${PN}/${PN}-${GENTOO_PATCH_VER}-patches.tar.xz"
fi

LICENSE="GPL-3"
SLOT="0"
[[ "${PV}" == *_rc* ]] || \
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="afs bashlogger examples mem-scramble +net nls plugins +readline"

DEPEND="
	>=sys-libs/ncurses-5.2-r2:0=
	nls? ( virtual/libintl )
	readline? ( >=sys-libs/readline-${READLINE_VER}:0= )
"
RDEPEND="
	${DEPEND}
"
# We only need yacc when the .y files get patched (bash42-005, bash51-011)
BDEPEND="app-alternatives/yacc
	verify-sig? ( sec-keys/openpgp-keys-chetramey )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	# Patches from Chet sent to bashbug ml
	"${WORKDIR}"/${PN}-${GENTOO_PATCH_VER}-patches/${PN}-5.0-syslog-history-extern.patch
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

	eapply -p0 "${PATCHES[@]}"
	eapply_user
}

src_configure() {
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
	emake

	if use plugins ; then
		emake -C examples/loadables all others
	fi
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
		-e "s:#${USERLAND}#@::"
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
