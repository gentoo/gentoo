# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic systemd toolchain-funcs

MY_P="${P/_/-}"

DESCRIPTION="The GNU Privacy Guard, a GPL OpenPGP implementation"
HOMEPAGE="https://gnupg.org/"
SRC_URI="mirror://gnupg/gnupg/${MY_P}.tar.bz2
	scd-shared-access? ( https://raw.githubusercontent.com/GPGTools/MacGPG2/5ca182f54b7b6cd635d1c0a4713953834489fdd9/patches/gnupg/scdaemon_shared-access.patch -> ${PN}-2.2.16-scdaemon_shared-access.patch )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="bzip2 doc ldap nls readline scd-shared-access selinux +smartcard ssl tofu tools usb user-socket wks-server"

# Existence of executables is checked during configuration.
DEPEND=">=dev-libs/libassuan-2.5.0
	>=dev-libs/libgcrypt-1.8.0
	>=dev-libs/libgpg-error-1.29
	>=dev-libs/libksba-1.3.4
	>=dev-libs/npth-1.2
	>=net-misc/curl-7.10
	bzip2? ( app-arch/bzip2 )
	ldap? ( net-nds/openldap )
	readline? ( sys-libs/readline:0= )
	smartcard? ( usb? ( virtual/libusb:1 ) )
	ssl? ( >=net-libs/gnutls-3.0:0= )
	sys-libs/zlib
	tofu? ( >=dev-db/sqlite-3.7 )"

RDEPEND="${DEPEND}
	app-crypt/pinentry
	nls? ( virtual/libintl )
	selinux? ( sec-policy/selinux-gpg )
	wks-server? ( virtual/mta )"

BDEPEND="virtual/pkgconfig
	doc? ( sys-apps/texinfo )
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${MY_P}"

DOCS=(
	ChangeLog NEWS README THANKS TODO VERSION
	doc/FAQ doc/DETAILS doc/HACKING doc/TRANSLATE doc/OpenPGP doc/KEYSERVER
)

PATCHES=(
	"${FILESDIR}/${PN}-2.1.20-gpgscm-Use-shorter-socket-path-lengts-to-improve-tes.patch"
)

src_prepare() {
	default

	# Made optional because it's a non-official patch
	if use scd-shared-access ; then
		# Patch taken from
		# https://github.com/GPGTools/MacGPG2/tree/dev/patches/gnupg
		eapply "${DISTDIR}/${PN}-2.2.16-scdaemon_shared-access.patch"
	fi

	# Inject SSH_AUTH_SOCK into user's sessions after enabling gpg-agent-ssh.socket in systemctl --user mode,
	# idea borrowed from libdbus, see
	#   https://gitlab.freedesktop.org/dbus/dbus/-/blob/master/bus/systemd-user/dbus.socket.in#L6
	#
	# This cannot be upstreamed, as it requires determining the exact prefix of 'systemctl',
	# which in turn requires discovery in Autoconf, something that upstream deeply resents.
	sed -e "/DirectoryMode=/a ExecStartPost=-${EPREFIX}/bin/systemctl --user set-environment SSH_AUTH_SOCK=%t/gnupg/S.gpg-agent.ssh" \
		-i doc/examples/systemd-user/gpg-agent-ssh.socket || die
}

src_configure() {
	local myconf=(
		$(use_enable bzip2)
		$(use_enable nls)
		$(use_enable smartcard scdaemon)
		$(use_enable ssl gnutls)
		$(use_enable tofu)
		$(use smartcard && use_enable usb ccid-driver || echo '--disable-ccid-driver')
		$(use_enable wks-server wks-tools)
		$(use_with ldap)
		$(use_with readline)
		--with-mailprog=/usr/libexec/sendmail
		--disable-ntbtls
		--enable-all-tests
		--enable-gpg
		--enable-gpgsm
		--enable-large-secmem
		CC_FOR_BUILD="$(tc-getBUILD_CC)"
		GPG_ERROR_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpg-error-config"
		KSBA_CONFIG="${ESYSROOT}/usr/bin/ksba-config"
		LIBASSUAN_CONFIG="${ESYSROOT}/usr/bin/libassuan-config"
		LIBGCRYPT_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-libgcrypt-config"
		NPTH_CONFIG="${ESYSROOT}/usr/bin/npth-config"
		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
	)

	if use prefix && use usb; then
		# bug #649598
		append-cppflags -I"${EPREFIX}/usr/include/libusb-1.0"
	fi

	#bug 663142
	if use user-socket; then
		myconf+=( --enable-run-gnupg-user-socket )
	fi

	# glib fails and picks up clang's internal stdint.h causing weird errors
	[[ ${CC} == *clang ]] && \
		export gl_cv_absolute_stdint_h=/usr/include/stdint.h

	# Hardcode mailprog to /usr/libexec/sendmail even if it does not exist.
	# As of GnuPG 2.3, the mailprog substitution is used for the binary called
	# by wks-client & wks-server; and if it's autodetected but not not exist at
	# build time, then then 'gpg-wks-client --send' functionality will not
	# work. This has an unwanted side-effect in stage3 builds: there was a
	# [R]DEPEND on virtual/mta, which also brought in virtual/logger, bloating
	# the build where the install guide previously make the user chose the
	# logger & mta early in the install.

	econf "${myconf[@]}"
}

src_compile() {
	default

	use doc && emake -C doc html
}

src_test() {
	#Bug: 638574
	use tofu && export TESTFLAGS=--parallel
	default
}

src_install() {
	default

	use tools &&
		dobin \
			tools/{convert-from-106,gpg-check-pattern} \
			tools/{gpg-zip,gpgconf,gpgsplit,lspgpot,mail-signed-keys} \
			tools/make-dns-cert

	dosym gpg /usr/bin/gpg2
	dosym gpgv /usr/bin/gpgv2
	echo ".so man1/gpg.1" > "${ED}"/usr/share/man/man1/gpg2.1 || die
	echo ".so man1/gpgv.1" > "${ED}"/usr/share/man/man1/gpgv2.1 || die

	dodir /etc/env.d
	echo "CONFIG_PROTECT=/usr/share/gnupg/qualified.txt" >> "${ED}"/etc/env.d/30gnupg || die

	use doc && dodoc doc/gnupg.html/* doc/*.png

	systemd_douserunit doc/examples/systemd-user/*.{service,socket}
}
