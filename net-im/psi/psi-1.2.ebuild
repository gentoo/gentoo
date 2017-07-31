# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="be bg ca cs de en eo es et fa fi fr he hu it ja kk mk nl pl pt pt_BR ru sk sl sr@latin sv sw uk ur_PK vi zh_CN zh_TW"
PLOCALE_BACKUP="en"

inherit l10n qmake-utils

DESCRIPTION="Qt XMPP client"
HOMEPAGE="http://psi-im.org/"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz
	https://github.com/psi-im/psi-l10n/archive/1.2.tar.gz -> psi-l10n-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aspell crypt dbus debug doc enchant +hunspell ssl xscreensaver
whiteboarding webengine webkit"

# qconf generates not quite compatible configure scripts
QA_CONFIGURE_OPTIONS=".*"

REQUIRED_USE="
	?? ( aspell enchant hunspell )
	webengine? ( !webkit )
"

RDEPEND="
	app-crypt/qca:2[qt5]
	dev-qt/qtgui:5
	dev-qt/qtxml:5
	dev-qt/qtconcurrent:5
	dev-qt/qtmultimedia:5
	dev-qt/qtx11extras:5
	net-dns/libidn
	sys-libs/zlib[minizip]
	aspell? ( app-text/aspell )
	dbus? ( dev-qt/qtdbus:5 )
	enchant? ( >=app-text/enchant-1.3.0 )
	hunspell? ( app-text/hunspell:= )
	webengine? ( >=dev-qt/qtwebengine-5.7:5[widgets] )
	webkit? ( dev-qt/qtwebkit:5 )
	whiteboarding? ( dev-qt/qtsvg:5 )
	xscreensaver? ( x11-libs/libXScrnSaver )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
PDEPEND="
	crypt? ( app-crypt/qca[gpg] )
	ssl? ( app-crypt/qca:2[ssl] )
"
RESTRICT="test"

src_configure() {
	CONF=(
		--no-separate-debug-info
		--qtdir="$(qt5_get_bindir)/.."
		$(use_enable aspell)
		$(use_enable dbus qdbus)
		$(use_enable enchant)
		$(use_enable hunspell)
		$(use_enable xscreensaver xss)
		$(use_enable whiteboarding)
	)

	use debug && CONF+=("--debug")
	use webengine && CONF+=("--enable-webkit" "--with-webkit=qtwebengine")
	use webkit && CONF+=("--enable-webkit" "--with-webkit=qwebkit")

	econf "${CONF[@]}"

	eqmake5 psi.pro
}

src_compile() {
	emake
	use doc && emake -C doc api_public
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	# this way the docs will be installed in the standard gentoo dir
	rm "${ED}"/usr/share/psi/{COPYING,README} || die "Installed file set seems to be changed by upstream"
	newdoc iconsets/roster/README README.roster
	newdoc iconsets/system/README README.system
	newdoc certs/README README.certs
	dodoc README

	local HTML_DOCS=( doc/api )
	einstalldocs

	# install translations
	local mylrelease="$(qt5_get_bindir)"/lrelease
	cd "${WORKDIR}/psi-l10n-${PV}" || die
	insinto /usr/share/psi
	install_locale() {
		"${mylrelease}" "translations/${PN}_${1}.ts" || die "lrelease ${1} failed"
		doins "translations/${PN}_${1}.qm"
	}
	l10n_for_each_locale_do install_locale
}
