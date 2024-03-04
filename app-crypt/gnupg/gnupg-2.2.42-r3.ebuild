# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Maintainers should:
# 1. Join the "Gentoo" project at https://dev.gnupg.org/project/view/27/
# 2. Subscribe to release tasks like https://dev.gnupg.org/T6159
# (find the one for the current release then subscribe to it +
# any subsequent ones linked within so you're covered for a while.)

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gnupg.asc
# in-source builds are not supported: https://dev.gnupg.org/T6313#166339
inherit flag-o-matic out-of-source multiprocessing systemd toolchain-funcs verify-sig

MY_P="${P/_/-}"

DESCRIPTION="The GNU Privacy Guard, a GPL OpenPGP implementation"
HOMEPAGE="https://gnupg.org/"
SRC_URI="mirror://gnupg/gnupg/${MY_P}.tar.bz2"
SRC_URI+=" verify-sig? ( mirror://gnupg/gnupg/${P}.tar.bz2.sig )"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="bzip2 doc ldap nls readline selinux +smartcard ssl test tofu tools usb user-socket wks-server"
RESTRICT="!test? ( test )"

# Existence of executables is checked during configuration.
# Note: On each bump, update dep bounds on each version from configure.ac!
DEPEND="
	>=dev-libs/libassuan-2.5.0
	>=dev-libs/libgcrypt-1.8.0:=
	>=dev-libs/libgpg-error-1.38
	>=dev-libs/libksba-1.3.5
	>=dev-libs/npth-1.2
	>=net-misc/curl-7.10
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	ldap? ( net-nds/openldap:= )
	readline? ( sys-libs/readline:= )
	smartcard? ( usb? ( virtual/libusb:1 ) )
	ssl? ( >=net-libs/gnutls-3.0:= )
	tofu? ( >=dev-db/sqlite-3.7 )
"
RDEPEND="
	${DEPEND}
	nls? ( virtual/libintl )
	selinux? ( sec-policy/selinux-gpg )
	wks-server? ( virtual/mta )
"
PDEPEND="
	app-crypt/pinentry
"
BDEPEND="
	virtual/pkgconfig
	doc? ( sys-apps/texinfo )
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-gnupg )
"

DOCS=(
	ChangeLog NEWS README THANKS TODO VERSION
	doc/FAQ doc/DETAILS doc/HACKING doc/TRANSLATE doc/OpenPGP doc/KEYSERVER
)

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.20-gpgscm-Use-shorter-socket-path-lengts-to-improve-tes.patch
	"${FILESDIR}"/${P}-bug923248-insecure-backup.patch
	"${FILESDIR}"/${P}-dirmngr-proxy.patch
	"${FILESDIR}"/${P}-gpgme-tests.patch
)

src_prepare() {
	default

	# Inject SSH_AUTH_SOCK into user's sessions after enabling gpg-agent-ssh.socket in systemctl --user mode,
	# idea borrowed from libdbus, see
	#   https://gitlab.freedesktop.org/dbus/dbus/-/blob/master/bus/systemd-user/dbus.socket.in#L6
	#
	# This cannot be upstreamed, as it requires determining the exact prefix of 'systemctl',
	# which in turn requires discovery in Autoconf, something that upstream deeply resents.
	sed -e "/DirectoryMode=/a ExecStartPost=-${EPREFIX}/bin/systemctl --user set-environment SSH_AUTH_SOCK=%t/gnupg/S.gpg-agent.ssh" \
		-i doc/examples/systemd-user/gpg-agent-ssh.socket || die
}

my_src_configure() {
	# Upstream don't support LTO, bug #854222.
	filter-lto

	local myconf=(
		$(use_enable bzip2)
		$(use_enable nls)
		$(use_enable smartcard scdaemon)
		$(use_enable ssl gnutls)
		$(use_enable test all-tests)
		$(use_enable test tests)
		$(use_enable tofu)
		$(use smartcard && use_enable usb ccid-driver || echo '--disable-ccid-driver')
		$(use_enable wks-server wks-tools)
		$(use_with ldap)
		$(use_with readline)

		# Hardcode mailprog to /usr/libexec/sendmail even if it does not exist.
		# As of GnuPG 2.3, the mailprog substitution is used for the binary called
		# by wks-client & wks-server; and if it's autodetected but not not exist at
		# build time, then then 'gpg-wks-client --send' functionality will not
		# work. This has an unwanted side-effect in stage3 builds: there was a
		# [R]DEPEND on virtual/mta, which also brought in virtual/logger, bloating
		# the build where the install guide previously make the user chose the
		# logger & mta early in the install.
		--with-mailprog=/usr/libexec/sendmail

		--disable-ntbtls
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
		append-cppflags -I"${ESYSROOT}/usr/include/libusb-1.0"
	fi

	# bug #663142
	if use user-socket; then
		myconf+=( --enable-run-gnupg-user-socket )
	fi

	# glib fails and picks up clang's internal stdint.h causing weird errors
	tc-is-clang && export gl_cv_absolute_stdint_h="${ESYSROOT}"/usr/include/stdint.h

	econf "${myconf[@]}"
}

my_src_compile() {
	default

	use doc && emake -C doc html
}

my_src_test() {
	export TESTFLAGS="--parallel=$(makeopts_jobs)"

	default
}

my_src_install() {
	emake DESTDIR="${D}" install

	use tools && dobin \
		tools/{gpg-zip,gpgconf,gpgsplit,gpg-check-pattern} \
		tools/make-dns-cert

	dosym gpg /usr/bin/gpg2
	dosym gpgv /usr/bin/gpgv2
	echo ".so man1/gpg.1" > "${ED}"/usr/share/man/man1/gpg2.1 || die
	echo ".so man1/gpgv.1" > "${ED}"/usr/share/man/man1/gpgv2.1 || die

	dodir /etc/env.d
	echo "CONFIG_PROTECT=/usr/share/gnupg/qualified.txt" >> "${ED}"/etc/env.d/30gnupg || die

	use doc && dodoc doc/gnupg.html/*
}

my_src_install_all() {
	einstalldocs

	use tools && dobin tools/{convert-from-106,mail-signed-keys,lspgpot}

	use doc && dodoc doc/*.png

	systemd_douserunit doc/examples/systemd-user/*.{service,socket}
}
