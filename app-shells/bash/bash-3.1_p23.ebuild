# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

# Uncomment if we have a patchset
GENTOO_PATCH_DEV="sam"
GENTOO_PATCH_VER="${PV}"

# Official patchlevel
# See ftp://ftp.cwru.edu/pub/bash/bash-3.1-patches/
PLEVEL="${PV##*_p}"
MY_PV="${PV/_p*}"
MY_PV="${MY_PV/_/-}"
MY_P="${PN}-${MY_PV}"
[[ ${PV} != *_p* ]] && PLEVEL=0
patches() {
	local opt=${1} plevel=${2:-${PLEVEL}} pn=${3:-${PN}} pv=${4:-${MY_PV}}
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
HOMEPAGE="https://tiswww.case.edu/php/chet/bash/bashtop.html"
SRC_URI="mirror://gnu/bash/${MY_P}.tar.gz $(patches)"

if [[ -n ${GENTOO_PATCH_VER} ]] ; then
	SRC_URI+=" https://dev.gentoo.org/~${GENTOO_PATCH_DEV}/distfiles/${CATEGORY}/${PN}/${PN}-${GENTOO_PATCH_VER}-patches.tar.xz"
fi

LICENSE="GPL-2"
SLOT="${MY_PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="afs +net nls +readline static"

LIB_DEPEND=">=sys-libs/ncurses-5.2-r2[static-libs(+)]
	nls? ( virtual/libintl )
	readline? ( >=sys-libs/readline-6.2[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${WORKDIR}"/${PN}-${GENTOO_PATCH_VER}-patches/autoconf-mktime-2.53.patch # bug #220040
	"${WORKDIR}"/${PN}-${GENTOO_PATCH_VER}-patches/${PN}-2.05b-parallel-build.patch # bug #41002
	"${WORKDIR}"/${PN}-${GENTOO_PATCH_VER}-patches/${PN}-3.1-protos.patch
	"${WORKDIR}"/${PN}-${GENTOO_PATCH_VER}-patches/${PN}-3.1-ulimit.patch
	"${WORKDIR}"/${PN}-${GENTOO_PATCH_VER}-patches/${PN}-3.0-read-memleak.patch
	"${WORKDIR}"/${PN}-${GENTOO_PATCH_VER}-patches/${PN}-3.0-trap-fg-signals.patch
	"${WORKDIR}"/${PN}-${GENTOO_PATCH_VER}-patches/${PN}-3.1-fix-dash-login-shell.patch # bug #118257
	"${WORKDIR}"/${PN}-${GENTOO_PATCH_VER}-patches/${PN}-3.1-dev-fd-test-as-user.patch # bug #131875
	"${WORKDIR}"/${PN}-${GENTOO_PATCH_VER}-patches/${PN}-3.1-dev-fd-buffer-overflow.patch # bug #431850
)

pkg_setup() {
	# bug #7332
	if is-flag -malign-double ; then
		eerror "Detected bad CFLAGS '-malign-double'.  Do not use this"
		eerror "as it breaks LFS (struct stat64) on x86."
		die "remove -malign-double from your CFLAGS mr ricer"
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

	# Clean out local libs so we know we use system ones
	rm -rf lib/{readline,termcap}/* || die
	touch lib/{readline,termcap}/Makefile.in || die # for config.status
	sed -ri -e 's:\$[{(](RL|HIST)_LIBSRC[)}]/[[:alpha:]_-]*\.h::g' Makefile.in || die

	default
}

src_configure() {
	#/var/tmp/portage/app-shells/bash-3.2_p57/temp/ccW7JJDK.ltrans2.ltrans.o: in function `shell_execve':
	# <artificial>:(.text+0x8b30): undefined reference to `__setostype'
	#
	# It works fine in bash 4+. Backporting may not be worth it.
	filter-lto

	local myconf=(
		--with-installed-readline=.

		# Force linking with system curses ... the bundled termcap lib
		# sucks bad compared to ncurses.  For the most part, ncurses
		# is here because readline needs it.  But bash itself calls
		# ncurses in one or two small places :(.
		--with-curses

		$(use_with afs)
		$(use_enable net net-redirections)
		--disable-profiling
		--without-gnu-malloc
		$(use_enable readline)
		$(use_enable readline history)
		$(use_enable readline bang-history)
	)

	# Force pgrp synchronization
	# https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=81653
	export bash_cv_pgrp_pipe=yes

	# For descriptions of these, see config-top.h
	# bashrc/#26952 bash_logout/#90488 ssh/#24762 mktemp/#574426
	append-cppflags \
		-DDEFAULT_PATH_VALUE=\'\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"\' \
		-DSTANDARD_UTILS_PATH=\'\"/bin:/usr/bin:/sbin:/usr/sbin\"\' \
		-DSYS_BASHRC=\'\"/etc/bash/bashrc\"\' \
		-DSYS_BASH_LOGOUT=\'\"/etc/bash/bash_logout\"\' \
		-DNON_INTERACTIVE_LOGIN_SHELLS \
		-DSSH_SOURCE_BASHRC \
		-DUSE_MKTEMP -DUSE_MKSTEMP

	use static && append-ldflags -static
	use nls || myconf+=( --disable-nls )

	# Historically, we always used the builtin readline, but since
	# our handling of SONAME upgrades has gotten much more stable
	# in the PM (and the readline ebuild itself preserves the old
	# libs during upgrades), linking against the system copy should
	# be safe.
	# Exact cached version here doesn't really matter as long as it
	# is at least what's in the DEPEND up above.
	export ac_cv_rl_version=6.2

	# bug #444070
	tc-export AR

	econf "${myconf[@]}"
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
