# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gnupg.asc
# in-source builds are not supported: https://dev.gnupg.org/T6313#166339
inherit autotools flag-o-matic out-of-source multiprocessing systemd toolchain-funcs

EGIT_TAG="gnupg-${PV%_p*}-freepg"
[[ ${PV} == *_p* ]] && EGIT_TAG+="-${PV#*_p}"
MY_P="gnupg-${EGIT_TAG}"

DESCRIPTION="GnuPG fork with improved RFC9850 compatibility"
HOMEPAGE="https://gnupg.org/"
SRC_URI="
	https://gitlab.com/freepg/gnupg/-/archive/${EGIT_TAG}/${MY_P}.tar.bz2
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bzip2 doc ldap nls readline selinux +smartcard ssl test +tofu tpm tools usb user-socket wks-server"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( tofu )"

# Existence of executables is checked during configuration.
# Note: On each bump, update dep bounds on each version from configure.ac!
DEPEND="
	>=dev-libs/libassuan-3.0.0:=
	>=dev-libs/libgcrypt-1.11.0:=
	>=dev-libs/libgpg-error-1.51
	>=dev-libs/libksba-1.6.3
	>=dev-libs/npth-1.2
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	ldap? ( net-nds/openldap:= )
	readline? ( sys-libs/readline:0= )
	smartcard? ( usb? ( virtual/libusb:1 ) )
	tofu? ( >=dev-db/sqlite-3.27 )
	tpm? ( >=app-crypt/tpm2-tss-2.4.0:= )
	ssl? ( >=net-libs/gnutls-3.2:0= )
"
RDEPEND="
	${DEPEND}
	nls? ( virtual/libintl )
	selinux? ( sec-policy/selinux-gpg )
	wks-server? ( virtual/mta )
	!app-crypt/gnupg
"
PDEPEND="
	app-alternatives/gpg[-reference]
	app-crypt/pinentry
"
BDEPEND="
	virtual/pkgconfig
	doc? ( sys-apps/texinfo )
	nls? ( sys-devel/gettext )
"
# maintainer mode
BDEPEND+="
	media-gfx/fig2dev
	virtual/imagemagick-tools
"

DOCS=(
	ChangeLog NEWS README THANKS TODO VERSION
	doc/FAQ doc/DETAILS doc/HACKING doc/TRANSLATE doc/OpenPGP doc/KEYSERVER
)

PATCHES=(
	"${FILESDIR}"/gnupg-2.1.20-gpgscm-Use-shorter-socket-path-lengts-to-improve-tes.patch
)

src_prepare() {
	default
	eautoreconf
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
		$(use_enable tofu keyboxd)
		$(use_enable tofu sqlite)
		$(usex tpm '--with-tss=intel' '--disable-tpm2d')
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
		--enable-gpgsm
		--enable-large-secmem

		# needed from building from git
		--enable-maintainer-mode

		CC_FOR_BUILD="$(tc-getBUILD_CC)"
		GPGRT_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpgrt-config"

		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
	)

	if use prefix && use usb; then
		# bug #649598
		append-cppflags -I"${ESYSROOT}/usr/include/libusb-1.0"
	fi

	if [[ ${CHOST} == *-solaris* ]] ; then
		# https://dev.gnupg.org/T7368
		export ac_cv_should_define__xopen_source=yes
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

	# rename for app-alternatives/gpg
	mv "${ED}"/usr/bin/gpg{,-freepg} || die
	mv "${ED}"/usr/bin/gpgv{,-freepg} || die

	use tools && dobin tools/{gpgconf,gpgsplit,gpg-check-pattern} tools/make-dns-cert

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
	newdoc doc/examples/systemd-user/README README-systemd
}

pkg_preinst() {
	if has_version app-crypt/gnupg; then
		elog "When switching between GnuPG and FreePG, it is recommended to stop all"
		elog "daemons, using: gpgconf --kill all"
	fi
}

pkg_postrm() {
	if has_version app-crypt/gnupg; then
		elog "When switching between GnuPG and FreePG, it is recommended to stop all"
		elog "daemons, using: gpgconf --kill all"
	fi
}
