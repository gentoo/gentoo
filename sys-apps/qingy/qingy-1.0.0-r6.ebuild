# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common flag-o-matic pam systemd

GENTOO_THEME_VERSION="2.1"

DESCRIPTION="A DirectFB getty replacement"
HOMEPAGE="http://qingy.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://gentoo/${PN}-gentoo-theme-${GENTOO_THEME_VERSION}.tar.bz2
	https://dev.gentoo.org/~gienah/2big4tree/sys-apps/qingy/${P}-screensavers.patch.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="crypt emacs gpm pam static X"

DEPEND="
	>=sys-libs/ncurses-5.7-r7:=
	crypt? ( >=dev-libs/libgcrypt-1.2.1:= )
	emacs? ( >=app-editors/emacs-23.1:* )
	pam? ( >=sys-libs/pam-0.75-r11 )
	X? (
		x11-libs/libX11:=
		x11-libs/libXScrnSaver:=
	)
"
RDEPEND="
	${RDEPEND}
	pam? ( sys-auth/pambase )
"
BDEPEND="virtual/pkgconfig"

SITEFILE="50${PN}-gentoo.el"

PATCHES=(
	"${FILESDIR}"/${P}-tinfo.patch
	# bug #359637 and bug #462634 - fixes from upstream
	"${WORKDIR}"/${P}-screensavers.patch
)

src_prepare() {
	default

	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	append-cflags -fcommon

	local myeconfargs=(
		--sbindir=/sbin
		--with-lispdir="${SITELISP}"/${PN}
		--disable-optimizations
		--disable-static
		--disable-DirectFB-support

		$(use_enable emacs)
		$(use_enable pam)
		$(use_enable static static-build)
		$(use_enable gpm gpm-lock)
		$(use_enable X x-support)
		$(use_enable crypt crypto libgcrypt)
	)

	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myeconfargs[@]}"
}

src_install() {
	# Copy documentation manually as make install only installs info files
	# INSTALL is left because it contains also configuration informations
	dodoc AUTHORS ChangeLog INSTALL NEWS README THANKS TODO

	# Install the program
	default

	find "${ED}" -name '*.la' -delete || die

	# Set the settings file umask to 600, in case somebody
	# wants to make use of the autologin feature
	fperms 600 /etc/qingy/settings

	# Install Gentoo theme
	dodir /usr/share/${PN}/themes/gentoo
	cp "${WORKDIR}"/gentoo/* "${ED}"/usr/share/${PN}/themes/gentoo || die

	# Alter config file so that it uses our theme
	sed -i 's/theme = "default"/theme = "gentoo"/' "${ED}"/etc/${PN}/settings || die

	# Install log rotation policy
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}-logrotate ${PN}

	use emacs && elisp-site-file-install "${FILESDIR}"/${SITEFILE}

	rm "${ED}"/etc/pam.d/qingy || die

	if use pam; then
		pamd_mimic system-local-login qingy auth account password session
	fi

	systemd_newunit "${FILESDIR}/${PN}_at.service" "${PN}@.service"
}

pkg_postinst() {
	einfo "In order to use qingy you must first edit your ${EROOT}/etc/inittab"
	einfo "Check the documentation at ${HOMEPAGE}"
	einfo "for instructions on how to do that."
	echo
	einfo "Also, make sure to adjust qingy settings file (${EROOT}/etc/qingy/settings)"
	einfo "to your preferences/machine configuration..."

	if use crypt; then
		echo
		einfo "You will have to create a key pair using 'qingy-keygen'"
		echo
		ewarn "Note that sometimes a generated key-pair may pass the internal tests"
		ewarn "but fail to work properly. You will get a 'regenerate your keys'"
		ewarn "message. If this is your case, please remove ${EROOT}/etc/qingy/public_key"
		ewarn "and ${EROOT}/etc/qingy/private_key and run qingy-keygen again..."
	fi

	use emacs && echo && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
