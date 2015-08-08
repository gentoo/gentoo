# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs linux-info systemd

DESCRIPTION="Manage special features such as screen and keyboard backlight on Apple MacBook Pro/PowerBook"
HOMEPAGE="http://technologeek.org/projects/pommed/index.html"
ALIOTH_NUMBER="3583"
SRC_URI="http://alioth.debian.org/frs/download.php/${ALIOTH_NUMBER}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gtk X"

COMMON_DEPEND="media-libs/alsa-lib
	x86? ( sys-apps/pciutils )
	amd64? (  sys-apps/pciutils )
	dev-libs/confuse
	>=sys-apps/dbus-1.1
	dev-libs/dbus-glib
	sys-libs/zlib
	media-libs/audiofile
	gtk? ( x11-libs/gtk+:2 )
	X? ( x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXpm )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	media-sound/alsa-utils
	virtual/eject"

pkg_setup() {
	if ! use ppc; then
		linux-info_pkg_setup

		CONFIG_CHECK="~DMIID"
		check_extra_config
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${P}.patch"
}

src_compile() {
	cd "${S}"/pommed
	emake CC="$(tc-getCC)" OFLIB=1 || die "emake pommed failed"

	if use gtk; then
		cd "${S}"/gpomme
		local POFILES=""
		for LANG in ${LINGUAS}; do
			if [ -f po/${LANG}.po ]; then
				POFILES="${POFILES} po/${LANG}.po"
			fi
		done
		emake CC="$(tc-getCC)" POFILES="${POFILES}" || die "emake gpomme failed"
	fi
	if use X; then
		cd "${S}"/wmpomme
		emake CC="$(tc-getCC)" || die "emake wmpomme failed"
	fi
}

src_install() {
	insinto /etc
	if use x86 || use amd64; then
		newins pommed.conf.mactel pommed.conf
	elif use ppc; then
		newins pommed.conf.pmac pommed.conf
	fi

	insinto /etc/dbus-1/system.d
	newins dbus-policy.conf pommed.conf

	insinto /usr/share/pommed
	doins pommed/data/*.wav

	dobin pommed/pommed

	newinitd "${FILESDIR}"/pommed.rc pommed
	systemd_dounit "${FILESDIR}"/${PN}.service

	dodoc AUTHORS ChangeLog README TODO

	if use gtk ; then
		dobin gpomme/gpomme
		for LANG in ${LINGUAS}; do
			if [ -f gpomme/po/${LANG}.mo ]; then
				einfo "Installing lang ${LANG}"
				insinto /usr/share/locale/${LANG}/LC_MESSAGES/
				doins gpomme/po/${LANG}.mo
			fi
		done

		domenu gpomme/gpomme.desktop gpomme/gpomme-c.desktop
		insinto /usr/share/gpomme/
		doins -r gpomme/themes
	fi

	if use X ; then
		dobin wmpomme/wmpomme
	fi
}
