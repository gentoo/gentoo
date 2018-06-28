# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit systemd toolchain-funcs

MY_P="${P/_/-}"

DESCRIPTION="The GNU Privacy Guard, a GPL OpenPGP implementation"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI="mirror://gnupg/gnupg/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="bzip2 doc ldap nls readline selinux +smartcard ssl tofu tools usb wks-server"

COMMON_DEPEND_LIBS="
	>=dev-libs/npth-1.2
	>=dev-libs/libassuan-2.5.0
	>=dev-libs/libgcrypt-1.7.3
	>=dev-libs/libgpg-error-1.28
	>=dev-libs/libksba-1.3.4
	>=net-misc/curl-7.10
	ssl? ( >=net-libs/gnutls-3.0:0= )
	sys-libs/zlib
	ldap? ( net-nds/openldap )
	bzip2? ( app-arch/bzip2 )
	readline? ( sys-libs/readline:0= )
	smartcard? ( usb? ( virtual/libusb:0 ) )
	tofu? ( >=dev-db/sqlite-3.7 )
	"
COMMON_DEPEND_BINS="app-crypt/pinentry
	!app-crypt/dirmngr"

# Existence of executables is checked during configuration.
DEPEND="${COMMON_DEPEND_LIBS}
	${COMMON_DEPEND_BINS}
	nls? ( sys-devel/gettext )
	doc? ( sys-apps/texinfo )"

RDEPEND="${COMMON_DEPEND_LIBS}
	${COMMON_DEPEND_BINS}
	selinux? ( sec-policy/selinux-gpg )
	nls? ( virtual/libintl )"

S="${WORKDIR}/${MY_P}"

DOCS=(
	ChangeLog NEWS README THANKS TODO VERSION
	doc/FAQ doc/DETAILS doc/HACKING doc/TRANSLATE doc/OpenPGP doc/KEYSERVER
)

PATCHES=(
	"${FILESDIR}/${PN}-2.1.20-gpgscm-Use-shorter-socket-path-lengts-to-improve-tes.patch"
)

src_configure() {
	local myconf=()

	if use smartcard; then
		myconf+=(
			--enable-scdaemon
			$(use_enable usb ccid-driver)
		)
	else
		myconf+=( --disable-scdaemon )
	fi

	if use elibc_SunOS || use elibc_AIX; then
		myconf+=( --disable-symcryptrun )
	else
		myconf+=( --enable-symcryptrun )
	fi

	# as of 2.2.8 by default sendmail is tested but not actually used
	myconf+=( --without-mailprog )

	# glib fails and picks up clang's internal stdint.h causing weird errors
	[[ ${CC} == *clang ]] && \
		export gl_cv_absolute_stdint_h=/usr/include/stdint.h

	econf \
		"${myconf[@]}" \
		$(use_enable bzip2) \
		$(use_enable ssl gnutls) \
		$(use_enable nls) \
		$(use_enable tofu) \
		$(use_enable wks-server wks-tools) \
		$(use_with ldap) \
		$(use_with readline) \
		--enable-gpg \
		--enable-gpgsm \
		--enable-large-secmem \
		--enable-all-tests \
		CC_FOR_BUILD="$(tc-getBUILD_CC)"
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
