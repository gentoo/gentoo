# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mc/mc-9999.ebuild,v 1.15 2014/08/18 06:18:43 slyfox Exp $

EAPI=5

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/MidnightCommander/mc.git http://github.com/MidnightCommander/mc.git git://midnight-commander.org/git/mc.git"
	LIVE_ECLASSES="git-2 autotools"
	LIVE_EBUILD=yes
fi

inherit eutils flag-o-matic ${LIVE_ECLASSES}

MY_P=${P/_/-}

if [[ -z ${LIVE_EBUILD} ]]; then
	SRC_URI="http://www.midnight-commander.org/downloads/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"
fi

DESCRIPTION="GNU Midnight Commander is a text based file manager"
HOMEPAGE="http://www.midnight-commander.org"

LICENSE="GPL-3"
SLOT="0"
IUSE="+edit gpm mclib nls samba sftp +slang spell test X +xdg"

REQUIRED_USE="spell? ( edit )"

RDEPEND=">=dev-libs/glib-2.8:2
	gpm? ( sys-libs/gpm )
	kernel_linux? ( sys-fs/e2fsprogs )
	samba? ( net-fs/samba )
	sftp? ( net-libs/libssh2 )
	slang? ( >=sys-libs/slang-2 )
	!slang? ( sys-libs/ncurses )
	spell? ( app-text/aspell )
	X? ( x11-libs/libX11
		x11-libs/libICE
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libSM )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( dev-libs/check )
	"

[[ -n ${LIVE_EBUILD} ]] && DEPEND="${DEPEND} dev-vcs/cvs" # needed only for SCM source tree (autopoint uses cvs)

src_prepare() {
	epatch_user

	[[ -n ${LIVE_EBUILD} ]] && ./autogen.sh
}

S=${WORKDIR}/${MY_P}

src_configure() {
	local myscreen=ncurses
	use slang && myscreen=slang
	[[ ${CHOST} == *-solaris* ]] && append-ldflags "-lnsl -lsocket"

	local homedir=".mc"
	use xdg && homedir="XDG"

	econf \
		--disable-silent-rules \
		--disable-dependency-tracking \
		$(use_enable nls) \
		--enable-vfs \
		$(use_enable kernel_linux vfs-undelfs) \
		--enable-charset \
		$(use_with X x) \
		$(use_enable samba vfs-smb) \
		$(use_enable sftp vfs-sftp) \
		$(use_enable spell aspell) \
		$(use_with gpm gpm-mouse) \
		--with-screen=${myscreen} \
		$(use_with edit internal-edit) \
		$(use_enable mclib) \
		$(use_enable test tests) \
		--with-homedir=${homedir}
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS doc/{FAQ,NEWS,README}

	# fix bug #334383
	if use kernel_linux && [[ ${EUID} == 0 ]] ; then
		fowners root:tty /usr/libexec/mc/cons.saver
		fperms g+s /usr/libexec/mc/cons.saver
	fi

	if ! use xdg ; then
		sed 's@MC_XDG_OPEN="xdg-open"@MC_XDG_OPEN="/bin/false"@' \
			-i "${ED}"/usr/libexec/mc/ext.d/*.sh || die
	fi
}

pkg_postinst() {
	elog "To enable exiting to latest working directory,"
	elog "put this into your ~/.bashrc:"
	elog ". ${EPREFIX}/usr/libexec/mc/mc.sh"
}
