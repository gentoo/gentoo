# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic

MY_P=${P/_/-}

DESCRIPTION="GNU Midnight Commander is a text based file manager"
HOMEPAGE="http://www.midnight-commander.org"
SRC_URI="http://ftp.midnight-commander.org/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"
IUSE="+edit gpm mclib nls samba sftp +slang spell test X +xdg"

REQUIRED_USE="spell? ( edit )"

RDEPEND=">=dev-libs/glib-2.26.0:2
	gpm? ( sys-libs/gpm )
	kernel_linux? ( sys-fs/e2fsprogs )
	samba? ( net-fs/samba )
	sftp? ( net-libs/libssh2 )
	slang? ( >=sys-libs/slang-2 )
	!slang? ( sys-libs/ncurses:0= )
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

PATCHES=(
	"${FILESDIR}"/${PN}-4.8.13-tinfo.patch
)

S=${WORKDIR}/${MY_P}

src_prepare() {
	[[ -n ${LIVE_EBUILD} ]] && ./autogen.sh

	default

	# These tests fail, so disable them instead of disabling the entire
	# test suite. Please check on each bump if this is still necessary.
	rm tests/src/vfs/extfs/helpers-list/data/{u7z,urar}.* || die

	eautoreconf
}

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
