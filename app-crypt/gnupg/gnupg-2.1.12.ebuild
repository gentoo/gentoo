# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="The GNU Privacy Guard, a GPL OpenPGP implementation"
HOMEPAGE="http://www.gnupg.org/"
MY_P="${P/_/-}"
SRC_URI="mirror://gnupg/gnupg/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="bzip2 doc +gnutls ldap nls readline selinux smartcard tofu tools usb"

COMMON_DEPEND_LIBS="
	dev-libs/npth
	>=dev-libs/libassuan-2.4.1
	>=dev-libs/libgcrypt-1.6.2[threads]
	>=dev-libs/libgpg-error-1.21
	>=dev-libs/libksba-1.2.0
	>=net-misc/curl-7.10
	gnutls? ( >=net-libs/gnutls-3.0:0= )
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

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-signature-checking.patch" \
		"${FILESDIR}/${PN}-2.1-fix-gentoo-dash-issue.patch"
	epatch_user
}

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

	# glib fails and picks up clang's internal stdint.h causing weird errors
	[[ ${CC} == *clang ]] && \
		export gl_cv_absolute_stdint_h=/usr/include/stdint.h

	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--enable-gpg \
		--enable-gpgsm \
		--enable-large-secmem \
		--without-adns \
		"${myconf[@]}" \
		$(use_enable bzip2) \
		$(use_enable gnutls) \
		$(use_with ldap) \
		$(use_enable nls) \
		$(use_with readline) \
		$(use_enable tofu) \
		CC_FOR_BUILD="$(tc-getBUILD_CC)"
}

src_compile() {
	default

	if use doc; then
		cd doc
		emake html
	fi
}

src_install() {
	default

	use tools && dobin tools/{convert-from-106,gpg-check-pattern} \
		tools/{gpg-zip,gpgconf,gpgsplit,lspgpot,mail-signed-keys,make-dns-cert}

	emake DESTDIR="${D}" -f doc/Makefile uninstall-nobase_dist_docDATA
	# The help*txt files are read from the datadir by GnuPG directly.
	# They do not work if compressed or moved!
	#rm "${ED}"/usr/share/gnupg/help* || die

	dodoc ChangeLog NEWS README THANKS TODO VERSION doc/FAQ doc/DETAILS \
		doc/HACKING doc/TRANSLATE doc/OpenPGP doc/KEYSERVER doc/help*

	dosym gpg2 /usr/bin/gpg
	dosym gpgv2 /usr/bin/gpgv
	echo ".so man1/gpg2.1" > "${ED}"/usr/share/man/man1/gpg.1
	echo ".so man1/gpgv2.1" > "${ED}"/usr/share/man/man1/gpgv.1

	dodir /etc/env.d
	echo "CONFIG_PROTECT=/usr/share/gnupg/qualified.txt" >> "${ED}"/etc/env.d/30gnupg

	if use doc; then
		dohtml doc/gnupg.html/* doc/*.png
	fi
}

pkg_postinst() {
	elog "If you wish to view images emerge:"
	elog "media-gfx/xloadimage, media-gfx/xli or any other viewer"
	elog "Remember to use photo-viewer option in configuration file to activate"
	elog "the right viewer."
	elog

	if use smartcard; then
		elog "To use your OpenPGP smartcard (or token) with GnuPG you need one of"
		use usb && elog " - a CCID-compatible reader, used directly through libusb;"
		elog " - sys-apps/pcsc-lite and a compatible reader device;"
		elog " - dev-libs/openct and a compatible reader device;"
		elog " - a reader device and drivers exporting either PC/SC or CT-API interfaces."
		elog ""
		elog "General hint: you probably want to try installing sys-apps/pcsc-lite and"
		elog "app-crypt/ccid first."
	fi

	ewarn "Please remember to restart gpg-agent if a different version"
	ewarn "of the agent is currently used. If you are unsure of the gpg"
	ewarn "agent you are using please run 'killall gpg-agent',"
	ewarn "and to start a fresh daemon just run 'gpg-agent --daemon'."

	if [[ -n ${REPLACING_VERSIONS} ]]; then
		elog "If upgrading from a version prior than 2.1 you might have to re-import"
		elog "secret keys after restarting the gpg-agent as the new version is using"
		elog "a new storage mechanism."
		elog "You can migrate the keys using gpg --import \$HOME/.gnupg/secring.gpg"
	fi
}
