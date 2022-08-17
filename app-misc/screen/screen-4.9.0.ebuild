# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic pam tmpfiles

DESCRIPTION="screen manager with VT100/ANSI terminal emulation"
HOMEPAGE="https://www.gnu.org/software/screen/"

if [[ ${PV} != 9999 ]] ; then
	SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
else
	inherit git-r3
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/screen.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}" # needed for setting S later on
	S="${WORKDIR}"/${P}/src
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug nethack pam selinux multiuser"

DEPEND=">=sys-libs/ncurses-5.2:=
	virtual/libcrypt:=
	pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}
	acct-group/utmp
	selinux? ( sec-policy/selinux-screen )"
BDEPEND="sys-apps/texinfo"

PATCHES=(
	# Don't use utempter even if it is found on the system.
	"${FILESDIR}"/${PN}-4.3.0-no-utempter.patch
	"${FILESDIR}"/${PN}-4.6.2-utmp-exit.patch
)

src_prepare() {
	default

	# sched.h is a system header and causes problems with some C libraries
	mv sched.h _sched.h || die
	sed -i '/include/ s:sched.h:_sched.h:' screen.h || die

	# Fix manpage
	sed -i \
		-e "s:/usr/local/etc/screenrc:${EPREFIX}/etc/screenrc:g" \
		-e "s:/usr/local/screens:${EPREFIX}/tmp/screen:g" \
		-e "s:/local/etc/screenrc:${EPREFIX}/etc/screenrc:g" \
		-e "s:/etc/utmp:${EPREFIX}/var/run/utmp:g" \
		-e "s:/local/screens/S\\\-:${EPREFIX}/tmp/screen/S\\\-:g" \
		doc/screen.1 || die

	if [[ ${CHOST} == *-darwin* ]] || use elibc_musl; then
		sed -i -e '/^#define UTMPOK/s/define/undef/' acconfig.h || die
	fi

	# disable musl dummy headers for utmp[x]
	use elibc_musl && append-cppflags "-D_UTMP_H -D_UTMPX_H"

	# reconfigure
	eautoreconf
}

src_configure() {
	append-cppflags "-DMAXWIN=${MAX_SCREEN_WINDOWS:-100}"

	if [[ ${CHOST} == *-solaris* ]]; then
		# enable msg_header by upping the feature standard compatible
		# with c99 mode
		append-cppflags -D_XOPEN_SOURCE=600
	fi

	use nethack || append-cppflags "-DNONETHACK"
	use debug && append-cppflags "-DDEBUG"

	local myeconfargs=(
		--with-socket-dir="${EPREFIX}/tmp/${PN}"
		--with-sys-screenrc="${EPREFIX}/etc/screenrc"
		--with-pty-mode=0620
		--with-pty-group=5
		--enable-rxvt_osc
		--enable-telnet
		--enable-colors256
		$(use_enable pam)
	)
	econf "${myeconfargs[@]}"
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

	emake DESTDIR="${D}" SCREEN="${P}" install

	local tmpfiles_perms tmpfiles_group

	if use multiuser || use prefix ; then
		fperms 4755 /usr/bin/${P}
		tmpfiles_perms="0755"
		tmpfiles_group="root"
	else
		fowners root:utmp /usr/bin/${P}
		fperms 2755 /usr/bin/${P}
		tmpfiles_perms="0775"
		tmpfiles_group="utmp"
	fi

	newtmpfiles - screen.conf <<<"d /tmp/screen ${tmpfiles_perms} root ${tmpfiles_group}"

	insinto /usr/share/${PN}
	doins terminfo/{screencap,screeninfo.src}

	insinto /etc
	doins "${FILESDIR}"/screenrc

	if use pam; then
		pamd_mimic_system screen auth
	fi

	dodoc "${DOCS[@]}"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Some dangerous key bindings have been removed or changed to more safe values."
		elog "We enable some xterm hacks in our default screenrc, which might break some"
		elog "applications. Please check /etc/screenrc for information on these changes."
	fi

	tmpfiles_process screen.conf

	ewarn "This revision changes the screen socket location to ${EROOT}/tmp/${PN}"
}
