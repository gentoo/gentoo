# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils flag-o-matic toolchain-funcs multilib

# Official patchlevel
# See ftp://ftp.cwru.edu/pub/bash/bash-4.3-patches/
PLEVEL=${PV##*_p}
MY_PV=${PV/_p*}
MY_PV=${MY_PV/_/-}
MY_P=${PN}-${MY_PV}
[[ ${PV} != *_p* ]] && PLEVEL=0
patches() {
	local opt=$1 plevel=${2:-${PLEVEL}} pn=${3:-${PN}} pv=${4:-${MY_PV}}
	[[ ${plevel} -eq 0 ]] && return 1
	eval set -- {1..${plevel}}
	set -- $(printf "${pn}${pv/\.}-%03d " "$@")
	if [[ ${opt} == -s ]] ; then
		echo "${@/#/${DISTDIR}/}"
	else
		local u
		for u in ftp://ftp.cwru.edu/pub/bash mirror://gnu/${pn} ; do
			printf "${u}/${pn}-${pv}-patches/%s " "$@"
		done
	fi
}

# The version of readline this bash normally ships with.
READLINE_VER="6.3"

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="http://tiswww.case.edu/php/chet/bash/bashtop.html"
SRC_URI="mirror://gnu/bash/${MY_P}.tar.gz $(patches)"
[[ ${PV} == *_rc* ]] && SRC_URI+=" ftp://ftp.cwru.edu/pub/bash/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ia64 m68k ~mips ~ppc ppc64 s390 sh ~sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="afs bashlogger examples mem-scramble +net nls plugins +readline vanilla"

DEPEND=">=sys-libs/ncurses-5.2-r2
	readline? ( >=sys-libs/readline-${READLINE_VER} )
	nls? ( virtual/libintl )"
RDEPEND="${DEPEND}
	!<sys-apps/portage-2.1.6.7_p1
	!<sys-apps/paludis-0.26.0_alpha5"
# we only need yacc when the .y files get patched (bash42-005)
DEPEND+=" virtual/yacc"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if is-flag -malign-double ; then #7332
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
}

src_prepare() {
	# Include official patches
	[[ ${PLEVEL} -gt 0 ]] && epatch $(patches -s)

	# Clean out local libs so we know we use system ones w/releases.
	if [[ ${PV} != *_rc* ]] ; then
		rm -rf lib/{readline,termcap}/*
		touch lib/{readline,termcap}/Makefile.in # for config.status
		sed -ri -e 's:\$[(](RL|HIST)_LIBSRC[)]/[[:alpha:]]*.h::g' Makefile.in || die
	fi

	# Avoid regenerating docs after patches #407985
	sed -i -r '/^(HS|RL)USER/s:=.*:=:' doc/Makefile.in || die
	touch -r . doc/*

	epatch "${FILESDIR}"/${PN}-4.3-compat-lvl.patch
	epatch "${FILESDIR}"/${PN}-4.3-append-process-segfault.patch
	epatch "${FILESDIR}"/${PN}-4.3-mapfile-improper-array-name-validation.patch
	epatch "${FILESDIR}"/${PN}-4.3-arrayfunc.patch

	epatch_user
}

src_configure() {
	local myconf=()

	# For descriptions of these, see config-top.h
	# bashrc/#26952 bash_logout/#90488 ssh/#24762
	append-cppflags \
		-DDEFAULT_PATH_VALUE=\'\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"\' \
		-DSTANDARD_UTILS_PATH=\'\"/bin:/usr/bin:/sbin:/usr/sbin\"\' \
		-DSYS_BASHRC=\'\"/etc/bash/bashrc\"\' \
		-DSYS_BASH_LOGOUT=\'\"/etc/bash/bash_logout\"\' \
		-DNON_INTERACTIVE_LOGIN_SHELLS \
		-DSSH_SOURCE_BASHRC \
		$(use bashlogger && echo -DSYSLOG_HISTORY)

	# Don't even think about building this statically without
	# reading Bug 7714 first.  If you still build it statically,
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
	export ac_cv_rl_version=${READLINE_VER}

	# Force linking with system curses ... the bundled termcap lib
	# sucks bad compared to ncurses.  For the most part, ncurses
	# is here because readline needs it.  But bash itself calls
	# ncurses in one or two small places :(.

	if [[ ${PV} != *_rc* ]] ; then
		# Use system readline only with released versions.
		myconf+=( --with-installed-readline=. )
	fi

	if use plugins; then
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
	tc-export AR #444070
	econf \
		--docdir='$(datarootdir)'/doc/${PF} \
		--htmldir='$(docdir)/html' \
		--with-curses \
		$(use_with afs) \
		$(use_enable net net-redirections) \
		--disable-profiling \
		$(use_enable mem-scramble) \
		$(use_with mem-scramble bash-malloc) \
		$(use_enable readline) \
		$(use_enable readline history) \
		$(use_enable readline bang-history) \
		"${myconf[@]}"
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
	newins "${FILESDIR}"/bashrc-r2 bashrc
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
		sed_args+=( #432338
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
			insinto /usr/share/doc/${PF}/${d}
			for f in ${d}/* ; do
				if [[ ${f##*/} != PERMISSION ]] && [[ ${f##*/} != *README ]] ; then
					doexe ${f}
				else
					doins ${f}
				fi
			done
		done
	fi

	doman doc/*.1
	newdoc CWRU/changelog ChangeLog
	dosym bash.info /usr/share/info/bashref.info
}

pkg_preinst() {
	if [[ -e ${EROOT}/etc/bashrc ]] && [[ ! -d ${EROOT}/etc/bash ]] ; then
		mkdir -p "${EROOT}"/etc/bash
		mv -f "${EROOT}"/etc/bashrc "${EROOT}"/etc/bash/
	fi

	if [[ -L ${EROOT}/bin/sh ]] ; then
		# rewrite the symlink to ensure that its mtime changes. having /bin/sh
		# missing even temporarily causes a fatal error with paludis.
		local target=$(readlink "${EROOT}"/bin/sh)
		local tmp=$(emktemp "${EROOT}"/bin)
		ln -sf "${target}" "${tmp}"
		mv -f "${tmp}" "${EROOT}"/bin/sh
	fi
}

pkg_postinst() {
	# If /bin/sh does not exist, provide it
	if [[ ! -e ${EROOT}/bin/sh ]] ; then
		ln -sf bash "${EROOT}"/bin/sh
	fi
}
