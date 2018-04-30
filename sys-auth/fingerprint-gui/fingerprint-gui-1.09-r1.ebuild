# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils readme.gentoo-r1 udev user gnome2-utils

DESCRIPTION="Use Fingerprint Devices with Linux"
HOMEPAGE="http://www.ullrich-online.cc/fingerprint/ https://github.com/maksbotan/fingerprint-gui"
SRC_URI="https://github.com/maksbotan/fingerprint-gui/archive/v${PV}-qt5.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+upekbsapi"

DEPEND="
	app-crypt/qca[qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtx11extras:5
	sys-auth/libfprint
	sys-auth/polkit-qt[qt5(+)]
	sys-libs/pam
	x11-libs/libX11
	x11-libs/libfakekey
	dev-libs/libusb
	!sys-auth/thinkfinger
"
RDEPEND="${DEPEND}"

QA_SONAME="/usr/lib/libbsapi.so.* /usr/lib64/libbsapi.so.*"
QA_PRESTRIPPED="/usr/lib/libbsapi.so.* /usr/lib64/libbsapi.so.*"
QA_FLAGS_IGNORED="/usr/lib/libbsapi.so.* /usr/lib64/libbsapi.so.*"

S="${WORKDIR}/${P}-qt5"

HTML_DOCS=( doc/Hacking.html doc/Step-by-step-manual.html )

src_prepare() {
	eapply_user

	sed -e '/Icon=/s:=.*:=Fingerprint:' \
		-i bin/${PN}/${PN}.desktop || die
	sed -e "s:/etc/udev/rules.d:\"$(get_udevdir)\"/rules.d:g" \
		-i bin/${PN%-gui}-helper/${PN%-gui}-helper.pro || die
	sed -e 's:GROUP="plugdev":GROUP="fingerprint":' \
		-i bin/fingerprint-helper/92-fingerprint-gui-uinput.rules \
		-i upek/91-fingerprint-gui-upek.rules || die
	sed -e '/DOCDIR\s\+=/s:'${PN}':'${PF}/html':' \
		-i bin/fingerprint-gui/fingerprint-gui.pro || die
	sed -e '/#define DOCDIR/s:'${PN}':'${PF}/html':' \
		-i include/Globals.h || die
}

src_configure() {
	eqmake5 \
		PREFIX="${EROOT}"usr \
		LIB="$(get_libdir)" \
		LIBEXEC=libexec \
		LIBPOLKIT_QT=LIBPOLKIT_QT_1_1
}

src_install() {
	export INSTALL_ROOT="${D}" #submakes need it as well, re-install fails otherwise.
	emake -j1 install
	if use upekbsapi ; then
		use amd64 && dolib.so upek/lib64/libbsapi.so*
		use x86 && dolib.so upek/lib/libbsapi.so*
		udev_dorules upek/91-fingerprint-gui-upek.rules
		insinto /etc
		doins upek/upek.cfg
		#dodir /var/upek_data
		#fowners root:plugdev /var/upek_data
		#fperms 0775 /var/upek_data
	fi
	doicon src/res/Fingerprint.png

	einstalldocs

	keepdir /var/lib/fingerprint-gui

	readme.gentoo_create_doc
}

pkg_preinst() {
	enewgroup fingerprint

	gnome2_icon_cache_update
}

pkg_postinst() {
	einfo "Fixing permisisons of fingerprints..."
	find "${EROOT}"/var/lib/fingerprint-gui -exec chown root:root {} + || die "chown root:root failed"
	find "${EROOR}"/var/lib/fingerprint-gui -type d -exec chmod 755 {} + || die "chmod 755 failed"
	find "${EROOT}"/var/lib/fingerprint-gui -type f -exec chmod 600 {} + || die "chmod 600 failed"

	readme.gentoo_print_elog

	gnome2_icon_cache_update
}

FORCE_PRINT_ELOG=1
DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="Please take a thorough look a the Step-by-step-manual.html
in /usr/share/doc/${PF}/html for integration with pam/polkit/...
Hint: You may want
auth sufficient  pam_fingerprint-gui.so
in /etc/pam.d/system-auth

There are udev rules to enforce group fingerprint on the reader device
Please put yourself in that group and re-trigger the udev rules."
