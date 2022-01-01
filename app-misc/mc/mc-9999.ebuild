# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/MidnightCommander/mc.git"
	LIVE_ECLASSES="git-r3 autotools"
	LIVE_EBUILD=yes
fi

inherit flag-o-matic ${LIVE_ECLASSES}

if [[ -z ${LIVE_EBUILD} ]]; then
	SRC_URI="http://ftp.midnight-commander.org/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"
fi

DESCRIPTION="GNU Midnight Commander is a text based file manager"
HOMEPAGE="https://midnight-commander.org"

LICENSE="GPL-3"
SLOT="0"
IUSE="+edit gpm nls samba sftp +slang spell test unicode X"

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

RESTRICT="!test? ( test )"

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
		--enable-charset
		--enable-vfs
		--with-screen=$(usex slang 'slang' "ncurses$(usex unicode 'w' '')")
		$(use_enable kernel_linux vfs-undelfs)
		# Today mclib does not expose any headers and is linked to
		# single 'mc' binary. Thus there is no advantage of having
		# a library. Let's avoid shared library altogether
		# as it also conflicts with sci-libs/mc: bug #685938
		--disable-mclib
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

src_test() {
	# CK_FORK=no to avoid using fork() in check library
	# as mc mocks fork() itself: bug #644462.
	#
	# VERBOSE=1 to make test failures contain detailed
	# information.
	CK_FORK=no emake check VERBOSE=1
}
src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS doc/{FAQ,NEWS,README}

	# fix bug #334383
	if use kernel_linux && [[ ${EUID} == 0 ]] ; then
		fowners root:tty /usr/libexec/mc/cons.saver
		fperms g+s /usr/libexec/mc/cons.saver
	fi
}

pkg_postinst() {
	if use spell && ! has_version app-dicts/aspell-en ; then
		elog "'spell' USE flag is enabled however app-dicts/aspell-en is not installed."
		elog "You should manually set 'spell_language' in the Misc section of ~/.config/mc/ini"
		elog "It has to be set to one of your installed aspell dictionaries or 'NONE'"
		elog
	fi
	elog "To enable exiting to latest working directory,"
	elog "put this into your ~/.bashrc:"
	elog ". ${EPREFIX}/usr/libexec/mc/mc.sh"
}
