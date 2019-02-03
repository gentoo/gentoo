# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="af ar ast az bg bs ca cs da de el_GR en_AU en_CA en_GB eo es eu fi fo fr ga gl he hr hu id it ja km ko lo lt lv mr ms nb nl nl_BE nn pa pl pt pt_BR ro ru si sk sl sr@latin sv ta te th tr ug uk uz zh_CN zh_TW"
PLOCALE_BACKUP="en_GB"

PYTHON_COMPAT=( python2_7 )

inherit desktop l10n perl-functions python-single-r1 xdg-utils

MY_PV_KDE="0.18"
MY_PV_NAUTILUS="0.02"
MY_PV_NEMO="0.04"
MY_PV_THUNAR="0.06"

DESCRIPTION="A graphical front-end for ClamAV"
HOMEPAGE="https://dave-theunsub.github.io/clamtk/"
SRC_URI="https://bitbucket.org/davem_/clamtk/downloads/${P}.tar.xz
	kde? ( https://bitbucket.org/davem_/${PN}-kde/downloads/${PN}-kde-${MY_PV_KDE}.tar.xz )
	nautilus? ( https://bitbucket.org/davem_/${PN}-gnome/downloads/${PN}-gnome-${MY_PV_NAUTILUS}.tar.xz )
	nemo? ( https://bitbucket.org/davem_/nemo-sendto-${PN}/downloads/nemo-sendto-${PN}-${MY_PV_NEMO}.tar.xz )
	thunar? ( https://bitbucket.org/davem_/thunar-sendto-${PN}/downloads/thunar-sendto-${PN}-${MY_PV_THUNAR}.tar.xz )"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde nautilus nemo +nls thunar"
REQUIRED_USE="nautilus? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="app-antivirus/clamav
	dev-perl/File-chdir
	dev-perl/Gtk2
	dev-perl/JSON
	dev-perl/LWP-Protocol-https
	dev-perl/LWP-UserAgent-Cached
	dev-perl/Locale-gettext
	dev-perl/Text-CSV
	dev-perl/glib-perl
	dev-perl/libwww-perl
	virtual/perl-Digest-MD5
	virtual/perl-Digest-SHA
	virtual/perl-Encode
	virtual/perl-MIME-Base64
	virtual/perl-Time-Piece
	x11-themes/faenza-icon-theme
	nautilus? ( dev-python/nautilus-python[${PYTHON_USEDEP}] )"

DEPEND="nls? ( sys-devel/gettext )"

DOCS=( CHANGES credits.md DISCLAIMER README.md )

PATCHES=( "$FILESDIR"/change_icon_path.patch )

pkg_setup() {
	if use nautilus; then
		python-single-r1_pkg_setup
	fi
}

src_unpack() {
	default

	unpack "${S}"/clamtk.1.gz

	if use kde; then
		unpack "${S}"/../clamtk-kde-${MY_PV_KDE}/clamtk-kde.1.gz
	fi

	if use nautilus; then
		unpack "${S}"/../clamtk-gnome-${MY_PV_NAUTILUS}/clamtk-gnome.1.gz
	fi

	if use nemo; then
		unpack "${S}"/../nemo-sendto-clamtk-${MY_PV_NEMO}/nemo-sendto-clamtk.1.gz
	fi

	if use thunar; then
		unpack "${S}"/../thunar-sendto-clamtk-${MY_PV_THUNAR}/thunar-sendto-clamtk.1.gz
	fi
}

src_prepare() {
	remove_locales() {
		rm "po/${1}.mo" || die
	}

	if use nls; then
		l10n_find_plocales_changes 'po' '' '.mo'
		l10n_for_each_disabled_locale_do remove_locales
	fi

	default
}

src_install() {
	install_locales() {
		domo "po/${1}.mo" || die
	}

	dobin clamtk

	perl_set_version
	insinto "${VENDOR_LIB}"/ClamTk
	doins lib/*.pm

	if use nls; then
		l10n_for_each_locale_do install_locales
	fi

	doicon images/clamtk.png images/clamtk.xpm

	domenu clamtk.desktop

	doman ../clamtk.1

	if use kde; then
		insinto /usr/share/kservices5/ServiceMenus
		doins ../clamtk-kde-${MY_PV_KDE}/clamtk-kde.desktop

		doicon ../clamtk-kde-${MY_PV_KDE}/clamtk-kde.png ../clamtk-kde-${MY_PV_KDE}/clamtk-kde.xpm

		doman ../clamtk-kde.1

		docinto dolphin
		dodoc ../clamtk-kde-${MY_PV_KDE}/CHANGES ../clamtk-kde-${MY_PV_KDE}/README.md
	fi

	if use nautilus; then
		insinto /usr/share/nautilus-python/extensions
		doins ../clamtk-gnome-${MY_PV_NAUTILUS}/clamtk-gnome.py

		doicon ../clamtk-gnome-${MY_PV_NAUTILUS}/images/clamtk-gnome.png

		doman ../clamtk-gnome.1

		docinto nautilus
		dodoc ../clamtk-gnome-${MY_PV_NAUTILUS}/CHANGES ../clamtk-gnome-${MY_PV_NAUTILUS}/DISCLAIMER ../clamtk-gnome-${MY_PV_NAUTILUS}/README.md
	fi

	if use nemo; then
		insinto /usr/share/nemo/actions/
		doins ../nemo-sendto-clamtk-${MY_PV_NEMO}/nemo-sendto-clamtk.nemo_action

		doman ../nemo-sendto-clamtk.1

		docinto nemo
		dodoc ../nemo-sendto-clamtk-${MY_PV_NEMO}/CHANGES ../nemo-sendto-clamtk-${MY_PV_NEMO}/DISCLAIMER ../nemo-sendto-clamtk-${MY_PV_NEMO}/README.md
	fi

	if use thunar; then
		insinto /usr/share/Thunar/sendto
		doins ../thunar-sendto-clamtk-${MY_PV_THUNAR}/thunar-sendto-clamtk.desktop

		doman ../thunar-sendto-clamtk.1

		docinto thunar
		dodoc ../thunar-sendto-clamtk-${MY_PV_THUNAR}/CHANGES ../thunar-sendto-clamtk-${MY_PV_THUNAR}/DISCLAIMER ../thunar-sendto-clamtk-${MY_PV_THUNAR}/README
	fi

	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
