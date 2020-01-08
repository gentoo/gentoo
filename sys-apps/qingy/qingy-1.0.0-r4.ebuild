# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools elisp-common eutils pam systemd

GENTOO_THEME_VERSION="2.1"

DESCRIPTION="A DirectFB getty replacement"
HOMEPAGE="http://qingy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://gentoo/${PN}-gentoo-theme-${GENTOO_THEME_VERSION}.tar.bz2
	https://dev.gentoo.org/~gienah/2big4tree/sys-apps/qingy/${P}-screensavers.patch.gz
	https://dev.gentoo.org/~gienah/2big4tree/sys-apps/qingy/${P}-consolekit-pam.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="consolekit crypt emacs gpm opensslcrypt pam static X"

RDEPEND="
	>=sys-libs/ncurses-5.7-r7:=
	opensslcrypt? ( dev-libs/openssl:0= )
	crypt? ( >=dev-libs/libgcrypt-1.2.1:0= )
	emacs? ( >=app-editors/emacs-23.1:* )
	pam? ( >=sys-libs/pam-0.75-r11 )
	X? (
		x11-libs/libX11:=
		x11-libs/libXScrnSaver:=
	)
"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4.1.4-r1
	virtual/pkgconfig
"
RDEPEND="${RDEPEND}
	consolekit? (
		sys-auth/consolekit
		sys-apps/dbus )
	pam? ( sys-auth/pambase )
"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	eapply "${FILESDIR}"/${P}-tinfo.patch
	# bug #359637 and bug #462634 - fixes from upstream
	epatch "${DISTDIR}"/${P}-screensavers.patch.gz
	# bug #372675 - fix from upstream
	epatch "${DISTDIR}"/${P}-consolekit-pam.patch.gz
	default
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	local crypto_support="--disable-crypto"
	local emacs_support="--disable-emacs --without-lispdir"

	if use crypt && use opensslcrypt; then
		echo
		ewarn "You can have openssl or libgcrypt as a crypto library, not both."
		ewarn "Using libgcrypt now..."
		echo
	fi

	use emacs && emacs_support="--enable-emacs --with-lispdir=${SITELISP}/${PN}"
	use opensslcrypt && crypto_support="--enable-crypto=openssl"
	use crypt && crypto_support="--enable-crypto=libgcrypt"
	econf \
		--sbindir=/sbin \
		--disable-optimizations \
		--disable-static \
		--disable-DirectFB-support \
		$(use_enable consolekit) \
		$(use_enable pam) \
		$(use_enable static static-build) \
		$(use_enable gpm gpm-lock) \
		$(use_enable X x-support) \
		${crypto_support} \
		${emacs_support}
}

src_install() {
	# Copy documentation manually as make install only installs info files
	# INSTALL is left because it contains also configuration informations
	dodoc AUTHORS ChangeLog INSTALL NEWS README THANKS TODO

	# Install the program
	default
	find "${D}" -name '*.la' -delete || die

	# Set the settings file umask to 600, in case somebody
	# wants to make use of the autologin feature
	/bin/chmod 600 "${D}"/etc/qingy/settings

	# Install Gentoo theme
	dodir /usr/share/${PN}/themes/gentoo
	cp "${WORKDIR}"/gentoo/* "${D}"/usr/share/${PN}/themes/gentoo || die

	# Alter config file so that it uses our theme
	sed -i 's/theme = "default"/theme = "gentoo"/' "${D}"/etc/${PN}/settings

	# Install log rotation policy
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}-logrotate ${PN}

	use emacs && elisp-site-file-install "${FILESDIR}"/${SITEFILE}

	rm "${D}"/etc/pam.d/qingy
	pamd_mimic system-local-login qingy auth account password session

	systemd_newunit "${FILESDIR}/${PN}_at.service" "${PN}@.service"
}

pkg_postinst() {
	einfo "In order to use qingy you must first edit your /etc/inittab"
	einfo "Check the documentation at ${HOMEPAGE}"
	einfo "for instructions on how to do that."
	echo
	einfo "Also, make sure to adjust qingy settings file (/etc/qingy/settings)"
	einfo "to your preferences/machine configuration..."

	if use crypt; then
		echo
		einfo "You will have to create a key pair using 'qingy-keygen'"
		echo
		ewarn "Note that sometimes a generated key-pair may pass the internal tests"
		ewarn "but fail to work properly. You will get a 'regenerate your keys'"
		ewarn "message. If this is your case, please remove /etc/qingy/public_key"
		ewarn "and /etc/qingy/private_key and run qingy-keygen again..."
	fi

	use emacs && echo && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
