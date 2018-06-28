# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SCM=""
[[ "${PV}" = 9999 ]] && SCM="git-r3"
inherit autotools eutils flag-o-matic pam toolchain-funcs user ${SCM}
unset SCM

DESCRIPTION="screen manager with VT100/ANSI terminal emulation"
HOMEPAGE="https://www.gnu.org/software/screen/"

if [[ "${PV}" != 9999 ]] ; then
	SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
	KEYWORDS="alpha amd64 ~arm arm64 hppa ia64 m68k ~mips ~ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
else
	EGIT_REPO_URI="git://git.savannah.gnu.org/screen.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}" # needed for setting S later on
	S="${WORKDIR}"/${P}/src
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug nethack pam selinux multiuser"

CDEPEND="
	>=sys-libs/ncurses-5.2:0=
	pam? ( virtual/pam )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-screen )"
DEPEND="${CDEPEND}
	sys-apps/texinfo"

PATCHES=(
	# Don't use utempter even if it is found on the system.
	"${FILESDIR}"/${PN}-4.3.0-no-utempter.patch
)

pkg_setup() {
	# Make sure utmp group exists, as it's used later on.
	enewgroup utmp 406
}

src_prepare() {
	default

	# sched.h is a system header and causes problems with some C libraries
	mv sched.h _sched.h || die
	sed -i '/include/ s:sched.h:_sched.h:' screen.h || die

	# Fix manpage.
	sed -i \
		-e "s:/usr/local/etc/screenrc:${EPREFIX}/etc/screenrc:g" \
		-e "s:/usr/local/screens:${EPREFIX}/tmp/screen:g" \
		-e "s:/local/etc/screenrc:${EPREFIX}/etc/screenrc:g" \
		-e "s:/etc/utmp:${EPREFIX}/var/run/utmp:g" \
		-e "s:/local/screens/S\\\-:${EPREFIX}/tmp/screen/S\\\-:g" \
		doc/screen.1 \
		|| die

	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e '/^#define UTMPOK/s/define/undef/' acconfig.h || die
	fi

	# reconfigure
	eautoreconf
}

src_configure() {
	append-cppflags "-DMAXWIN=${MAX_SCREEN_WINDOWS:-100}"

	if [[ ${CHOST} == *-solaris* ]] ; then
		# enable msg_header by upping the feature standard compatible
		# with c99 mode
		append-cppflags -D_XOPEN_SOURCE=600
	fi

	use nethack || append-cppflags "-DNONETHACK"
	use debug && append-cppflags "-DDEBUG"

	econf \
		--with-socket-dir="${EPREFIX}/tmp/screen" \
		--with-sys-screenrc="${EPREFIX}/etc/screenrc" \
		--with-pty-mode=0620 \
		--with-pty-group=5 \
		--enable-rxvt_osc \
		--enable-telnet \
		--enable-colors256 \
		$(use_enable pam)
}

src_compile() {
	LC_ALL=POSIX emake comm.h term.h
	emake osdef.h

	emake -C doc screen.info
	default
}

src_install() {
	local DOCS=(
		README ChangeLog INSTALL TODO NEWS* patchlevel.h
		doc/{FAQ,README.DOTSCREEN,fdpat.ps,window_to_display.ps}
	)

	default

	local tmpfiles_perms tmpfiles_group

	if use multiuser || use prefix
	then
		fperms 4755 /usr/bin/screen-${PV}
		tmpfiles_perms="0755"
		tmpfiles_group="root"
	else
		fowners root:utmp /usr/bin/screen-${PV}
		fperms 2755 /usr/bin/screen-${PV}
		tmpfiles_perms="0775"
		tmpfiles_group="utmp"
	fi

	dodir /etc/tmpfiles.d
	echo "d /tmp/screen ${tmpfiles_perms} root ${tmpfiles_group}" \
		> "${ED}"/etc/tmpfiles.d/screen.conf

	insinto /usr/share/screen
	doins terminfo/{screencap,screeninfo.src}

	insinto /etc
	doins "${FILESDIR}"/screenrc

	pamd_mimic_system screen auth
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]
	then
		elog "Some dangerous key bindings have been removed or changed to more safe values."
		elog "We enable some xterm hacks in our default screenrc, which might break some"
		elog "applications. Please check /etc/screenrc for information on these changes."
	fi

	# Add /tmp/screen in case it doesn't exist yet. This should solve
	# problems like bug #508634 where tmpfiles.d isn't in effect.
	local rundir="${EROOT%/}/tmp/screen"
	if [[ ! -d ${rundir} ]] ; then
		if use multiuser || use prefix ; then
			tmpfiles_group="root"
		else
			tmpfiles_group="utmp"
		fi
		mkdir -m 0775 "${rundir}"
		chgrp ${tmpfiles_group} "${rundir}"
	fi

	ewarn "This revision changes the screen socket location to ${rundir}"
}
