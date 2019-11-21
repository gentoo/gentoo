# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

MY_P=${P/_/-}

DESCRIPTION="GNU Midnight Commander is a text based file manager"
HOMEPAGE="https://www.midnight-commander.org"
SRC_URI="http://ftp.midnight-commander.org/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"
IUSE="+edit gpm nls samba sftp +slang spell test unicode X +xdg"

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

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-3933-iso9660-1.patch
	"${FILESDIR}"/${P}-3933-iso9660-2.patch
	"${FILESDIR}"/${PN}-4.8.23-gettext.patch
	"${FILESDIR}"/${PN}-4.8.23-gettext-test.patch
	"${FILESDIR}"/${PN}-4.8.23-vfs-gc-SEGV.patch
)

pkg_pretend() {
	if use slang && use unicode ; then
		ewarn "\"unicode\" USE flag only takes effect when the \"slang\" USE flag is disabled."
	fi
}

src_configure() {
	[[ ${CHOST} == *-solaris* ]] && append-ldflags "-lnsl -lsocket"

	local myeconfargs=(
		--disable-dependency-tracking
		--disable-silent-rules
		--enable-charset
		--enable-vfs
		--with-homedir=$(usex xdg 'XDG' '.mc')
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
	dodoc AUTHORS README NEWS

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
