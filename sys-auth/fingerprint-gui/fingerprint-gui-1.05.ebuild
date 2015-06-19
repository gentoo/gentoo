# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/fingerprint-gui/fingerprint-gui-1.05.ebuild,v 1.4 2015/03/31 12:23:31 kensington Exp $

EAPI=4

inherit eutils multilib qt4-r2 udev

DESCRIPTION="Use Fingerprint Devices with Linux"
HOMEPAGE="http://www.n-view.net/Appliance/fingerprint/"
SRC_URI="http://ullrich-online.cc/nview/Appliance/${PN%-gui}/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+upekbsapi"

DEPEND="app-crypt/qca:2[openssl,qt4(+)]
	sys-auth/libfprint
	sys-auth/polkit-qt[qt4(+)]
	sys-libs/pam
	x11-libs/libfakekey
	dev-qt/qtcore:4
	!sys-auth/thinkfinger"
RDEPEND="${DEPEND}"

QA_SONAME="/usr/lib/libbsapi.so.* /usr/lib64/libbsapi.so.*"
QA_PRESTRIPPED="/usr/lib/libbsapi.so.* /usr/lib64/libbsapi.so.*"
QA_FLAGS_IGNORED="/usr/lib/libbsapi.so.* /usr/lib64/libbsapi.so.*"

src_prepare() {
	sed -e '/Icon=/s:=.*:=Fingerprint:' \
		-i bin/${PN}/${PN}.desktop || die
	sed -e "s:/etc/udev/rules.d:\"$(get_udevdir)\"/rules.d:g" \
		-i bin/${PN%-gui}-helper/${PN%-gui}-helper.pro || die
}

src_configure() {
	eqmake4 \
		PREFIX="${EROOT}"usr \
		LIB="$(get_libdir)" \
		LIBEXEC=libexec \
		LIBPOLKIT_QT=LIBPOLKIT_QT_1_1
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	rm -r "${ED}"/usr/share/doc/${PN} || die
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

	dodoc CHANGELOG README
	dohtml doc/*
}

pkg_postinst() {
	elog "Please take a thorough look a the Install-step-by-step.html"
	elog "in /usr/share/doc/${PF} for integration with pam/polkit/..."
	elog "Hint: You may want"
	elog "   auth        sufficient  pam_fingerprint-gui.so"
	elog "in /etc/pam.d/system-auth"
	einfo
	elog "There are udev rules to enforce group plugdev on the reader device"
	elog "Please put yourself in that group and re-trigger the udev rules."
}
