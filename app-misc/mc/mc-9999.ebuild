# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/MidnightCommander/mc.git git://repo.or.cz/midnight-commander.git"
	LIVE_ECLASSES="git-r3 autotools"
	LIVE_EBUILD=yes
fi

inherit flag-o-matic ${LIVE_ECLASSES}

MY_P=${P/_/-}

if [[ -z ${LIVE_EBUILD} ]]; then
	SRC_URI="http://ftp.midnight-commander.org/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"
fi

DESCRIPTION="GNU Midnight Commander is a text based file manager"
HOMEPAGE="https://www.midnight-commander.org"

LICENSE="GPL-3"
SLOT="0"
IUSE="+edit gpm mclib nls samba sftp +slang spell test unicode X +xdg"

REQUIRED_USE="spell? ( edit )"

RDEPEND=">=dev-libs/glib-2.26.0:2
	gpm? ( sys-libs/gpm )
	kernel_linux? ( sys-fs/e2fsprogs )
	samba? ( net-fs/samba )
	sftp? ( net-libs/libssh2 )
	slang? ( >=sys-libs/slang-2 )
	!slang? ( sys-libs/ncurses:0=[unicode?] )
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

pkg_pretend() {
	if use slang && use unicode ; then
		ewarn "\"unicode\" USE flag only takes effect when the \"slang\" USE flag is disabled."
	fi
}

src_prepare() {
	default

	[[ -n ${LIVE_EBUILD} ]] && ./autogen.sh
}

src_configure() {
	[[ ${CHOST} == *-solaris* ]] && append-ldflags "-lnsl -lsocket"

	local myeconfargs=(
		--disable-dependency-tracking
		--disable-silent-rules
		--enable-charset
		--enable-vfs
		--with-homedir=$(usex xdg 'XDG' '.mc')
		--with-screen=$(usex slang 'slang' "ncurses$(usex unicode 'w')")
		$(use_enable kernel_linux vfs-undelfs)
		$(use_enable mclib)
		$(use_enable nls)
		$(use_enable samba vfs-smb)
		$(use_enable sftp vfs-sftp)
		$(use_enable spell aspell)
		$(use_enable test tests)
		$(use_with gpm gpm-mouse)
		$(use_with X x)
		$(use_with edit internal-edit)
	)
	econf "${myeconfargs[@]}"
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
			-i "${ED%/}"/usr/libexec/mc/ext.d/*.sh || die
	fi
}

pkg_postinst() {
	elog "To enable exiting to latest working directory,"
	elog "put this into your ~/.bashrc:"
	elog ". ${EPREFIX}/usr/libexec/mc/mc.sh"
}
