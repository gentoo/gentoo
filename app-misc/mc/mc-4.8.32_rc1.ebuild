# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_P="${P/_/-}"
MY_PV="${PV/_rc/-pre}"
DESCRIPTION="GNU Midnight Commander is a text based file manager"
HOMEPAGE="https://midnight-commander.org"
SRC_URI="https://github.com/MidnightCommander/mc/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3"
SLOT="0"
IUSE="+edit gpm sftp +slang spell test unicode X"

REQUIRED_USE="spell? ( edit )"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.30.0:2
	gpm? ( sys-libs/gpm )
	kernel_linux? ( sys-fs/e2fsprogs[tools(+)] )
	sftp? ( net-libs/libssh2 )
	slang? ( >=sys-libs/slang-2 )
	!slang? ( sys-libs/ncurses:=[unicode(+)?] )
	spell? ( app-text/aspell )
	X? (
		x11-libs/libX11
		x11-libs/libICE
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libSM
	)
"

RDEPEND="
	${DEPEND}
	spell? ( app-dicts/aspell-en )
"

# Force nls so xgettext is installed.  Will revert this.
BDEPEND="
	sys-devel/gettext
	app-arch/xz-utils
	virtual/pkgconfig
	test? ( dev-libs/check )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.8.26-ncurses-mouse.patch
	"${FILESDIR}"/${PN}-4.8.29-gentoo-tools.patch
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

	# Copied from autogen.sh
	xgettext --keyword=_ --keyword=N_ --keyword=Q_ --output=- \
		`find . -name '*.[ch]'` | sed -ne '/^#:/{s/#://;s/:[0-9]*/\
/g;s/ //g;p;}' | \
		grep -v '^$' | sort | uniq >po/POTFILES.in || die

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
		--enable-nls
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

	# This test fails.  Disable for now
	# https://midnight-commander.org/ticket/4567
	rm tests/src/vfs/extfs/helpers-list/data/iso9660.xorriso.* || die

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
