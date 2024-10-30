# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_P="${P/_/-}"
DESCRIPTION="GNU Midnight Commander is a text based file manager"
HOMEPAGE="https://midnight-commander.org"
SRC_URI="http://ftp.midnight-commander.org/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~ppc-macos ~x64-macos"
IUSE="+edit gpm nls sftp +slang spell test unicode X"

REQUIRED_USE="spell? ( edit )"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=dev-libs/glib-2.30.0:2
	gpm? ( sys-libs/gpm )
	kernel_linux? ( sys-fs/e2fsprogs[tools(+)] )
	sftp? ( net-libs/libssh2 )
	slang? ( >=sys-libs/slang-2 )
	!slang? ( sys-libs/ncurses:=[unicode(+)?] )
	spell? ( app-text/aspell )
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
	)
"

DEPEND="
	${COMMON_DEPEND}
	X? ( x11-base/xorg-proto )
"

RDEPEND="
	${DEPEND}
	spell? ( app-dicts/aspell-en )
"

BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( dev-libs/check )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.8.26-ncurses-mouse.patch
	"${FILESDIR}"/${PN}-4.8.29-gentoo-tools.patch
	"${FILESDIR}"/${P}-fix-chdir.patch
)

# This is a check for AIX, on Linux mc uses statvfs() regardless of whether
# LFS64 interfaces are available in libc or not.
QA_CONFIG_IMPL_DECL_SKIP=(
	statvfs64
)

src_prepare() {
	default

	# Bug #906194, #922483
	if use elibc_musl; then
		eapply "${FILESDIR}"/${PN}-4.8.30-musl-tests.patch
		eapply "${FILESDIR}"/${PN}-4.8.31-musl-tests.patch
	fi

	eautoreconf
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
	# Bug #759466
	if [[ ${EUID} == 0 ]] ; then
		ewarn "You are emerging ${PN} as root with 'userpriv' disabled."
		ewarn "Expect some test failures, or emerge with 'FEATURES=userpriv'!"
	fi

	# CK_FORK=no to avoid using fork() in check library
	# as mc mocks fork() itself: bug #644462.
	#
	# VERBOSE=1 to make test failures contain detailed
	# information.
	CK_FORK=no emake check VERBOSE=1
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README

	# fix bug #334383
	if use kernel_linux && [[ ${EUID} == 0 ]] ; then
		fowners root:tty /usr/libexec/mc/cons.saver
		fperms g+s /usr/libexec/mc/cons.saver
	fi
}

pkg_postinst() {
	elog "${PN} extension scripts depend on many external tools, install them as needed"
	elog
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
