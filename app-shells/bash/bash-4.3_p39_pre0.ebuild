# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Old ebuild to help with people doing live upgrades w/old portage versions.
# We use the bundled versions of readline & termcap to avoid external deps
# (which in turn would require those packages to keep an old EAPI version).

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs

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

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="http://tiswww.case.edu/php/chet/bash/bashtop.html"
SRC_URI="mirror://gnu/bash/${MY_P}.tar.gz $(patches)"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
# Note: We export this because portage wants it enabled.
IUSE="+readline"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.gz
}

src_prepare() {
	# Include official patches
	[[ ${PLEVEL} -gt 0 ]] && epatch $(patches -s)

	# Avoid regenerating docs after patches #407985
	sed -i -r '/^(HS|RL)USER/s:=.*:=:' doc/Makefile.in || die
	touch -r . doc/*

	epatch "${FILESDIR}"/${PN}-4.3-compat-lvl.patch
	epatch "${FILESDIR}"/${PN}-4.3-append-process-segfault.patch
	epatch "${FILESDIR}"/${PN}-4.3-mapfile-improper-array-name-validation.patch
	epatch "${FILESDIR}"/${PN}-4.3-arrayfunc.patch
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
		-DSSH_SOURCE_BASHRC

	# Force internal copy of termcap to be used (to avoid ncurses dep).
	export bash_cv_termcap_lib=gnutermcap

	# Disable the plugins logic by hand since bash doesn't
	# provide a way of doing it.
	export ac_cv_func_dl{close,open,sym}=no \
		ac_cv_lib_dl_dlopen=no ac_cv_header_dlfcn_h=no
	sed -i \
		-e '/LOCAL_LDFLAGS=/s:-rdynamic::' \
		configure || die

	tc-export AR #444070
	econf \
		--docdir='$(datarootdir)'/doc/${PF} \
		--htmldir='$(docdir)/html' \
		--disable-nls \
		--without-curses \
		--without-afs \
		--disable-net-redirections \
		--disable-profiling \
		--disable-mem-scramble \
		--without-bash-malloc \
		--enable-readline \
		--enable-history \
		--enable-bang-history \
		"${myconf[@]}"
}

src_compile() {
	emake || die
}

src_install() {
	local f

	emake DESTDIR="${D}" install || die

	dodir /bin
	mv "${D}"/usr/bin/bash "${D}"/bin/ || die
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
	sed -i \
		"${sed_args[@]}" \
		"${D}"/etc/skel/.bashrc \
		"${D}"/etc/bash/bashrc || die
}
