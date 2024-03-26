# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="be bg ca cs de en eo es et fa fi fr he hu it ja kk mk nl pl pt pt_BR ru sk sl sr@latin sv sw uk ur_PK vi zh_CN zh_TW"
PLOCALE_BACKUP="en"

inherit plocale qmake-utils xdg

DESCRIPTION="Qt XMPP client"
HOMEPAGE="https://psi-im.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz
	https://github.com/psi-im/psi-l10n/archive/${PV}.tar.gz -> psi-l10n-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="aspell crypt dbus debug doc enchant +hunspell webengine whiteboarding xscreensaver"

REQUIRED_USE="
	?? ( aspell enchant hunspell )
"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )
"
DEPEND="
	app-crypt/qca:2[qt5(+),ssl]
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	net-dns/libidn:0
	sys-libs/zlib[minizip]
	x11-libs/libX11
	x11-libs/libxcb
	aspell? ( app-text/aspell )
	dbus? ( dev-qt/qtdbus:5 )
	enchant? ( app-text/enchant:2 )
	hunspell? ( app-text/hunspell:= )
	webengine? (
		dev-qt/qtwebchannel:5
		dev-qt/qtwebengine:5[widgets]
	)
	whiteboarding? ( dev-qt/qtsvg:5 )
	xscreensaver? ( x11-libs/libXScrnSaver )
"
RDEPEND="${DEPEND}
	dev-qt/qtimageformats
"

RESTRICT="test"

src_configure() {
	CONF=(
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--no-separate-debug-info
		--qtdir="$(qt5_get_bindir)/.."
		$(use_enable aspell)
		$(use_enable dbus qdbus)
		$(use_enable enchant)
		$(use_enable hunspell)
		$(use_enable xscreensaver xss)
		$(use_enable whiteboarding)
		$(use_enable webengine webkit)
		$(use_with webengine webkit qtwebengine)
	)

	use debug && CONF+=("--debug")

	# This may generate warnings if passed option already matches with default.
	# Just ignore them. It's how qconf-based configure works and will be fixed in
	# future qconf versions.
	./configure "${CONF[@]}" || die "configure failed"

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

	use doc && HTML_DOCS=( doc/api/. )
	einstalldocs

	# install translations
	local mylrelease="$(qt5_get_bindir)"/lrelease
	cd "${WORKDIR}/psi-l10n-${PV}" || die
	insinto /usr/share/psi
	install_locale() {
		"${mylrelease}" "translations/${PN}_${1}.ts" || die "lrelease ${1} failed"
		doins "translations/${PN}_${1}.qm"
	}
	plocale_for_each_locale install_locale
}

pkg_postinst() {
	xdg_pkg_postinst
	einfo "For GPG support make sure app-crypt/qca is compiled with gpg USE flag."
}
