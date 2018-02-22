# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="be bg ca cs de en eo es et fa fi fr he hu it ja kk mk nl pl pt pt_BR ru sk sl sr@latin sv sw uk ur_PK vi zh_CN zh_TW"
PLOCALE_BACKUP="en"

inherit l10n git-r3 qmake-utils xdg-utils

DESCRIPTION="Qt XMPP client"
HOMEPAGE="http://psi-im.org/"

PSI_URI="https://github.com/psi-im"
PSI_PLUS_URI="https://github.com/psi-plus"
EGIT_REPO_URI="${PSI_URI}/${PN}.git"
PSI_LANGS_URI="${PSI_URI}/psi-l10n.git"
PSI_PLUS_LANGS_URI="${PSI_PLUS_URI}/psi-plus-l10n.git"
EGIT_MIN_CLONE_TYPE="single"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="aspell crypt dbus debug doc enchant extras +hunspell iconsets sql ssl webengine webkit whiteboarding xscreensaver"

# qconf generates not quite compatible configure scripts
QA_CONFIGURE_OPTIONS=".*"

REQUIRED_USE="
	?? ( aspell enchant hunspell )
	iconsets? ( extras )
	sql? ( extras )
	webengine? ( !webkit )
"

RDEPEND="
	app-crypt/qca:2[qt5(+)]
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	net-dns/libidn
	sys-libs/zlib[minizip]
	x11-libs/libX11
	x11-libs/libxcb
	aspell? ( app-text/aspell )
	dbus? ( dev-qt/qtdbus:5 )
	enchant? ( >=app-text/enchant-1.3.0 )
	extras? (
		sql? ( dev-qt/qtsql:5 )
	)
	hunspell? ( app-text/hunspell:= )
	webengine? (
		dev-qt/qtwebchannel:5
		dev-qt/qtwebengine:5[widgets]
	)
	webkit? ( dev-qt/qtwebkit:5 )
	whiteboarding? ( dev-qt/qtsvg:5 )
	xscreensaver? ( x11-libs/libXScrnSaver )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	extras? ( >=sys-devel/qconf-2.3 )
"
PDEPEND="
	crypt? ( app-crypt/qca[gpg] )
	ssl? ( app-crypt/qca:2[ssl] )
"

RESTRICT="test iconsets? ( bindist )"

pkg_setup() {
	MY_PN=psi
	if use extras; then
		MY_PN=psi-plus
		echo
		ewarn "You're about to build patched version of Psi called Psi+."
		ewarn "It has new nice features not yet included to Psi."
		ewarn "Take a look at homepage for more info: http://psi-plus.com/"
		echo

		if use iconsets; then
			echo
			ewarn "Some artwork is from open source projects, but some is provided 'as-is'"
			ewarn "and has not clear licensing."
			ewarn "Possibly this build is not redistributable in some countries."
		fi
	fi
}

src_unpack() {
	git-r3_src_unpack

	# fetch translations
	unset EGIT_BRANCH EGIT_COMMIT
	EGIT_REPO_URI=$(usex extras "${PSI_PLUS_LANGS_URI}" "${PSI_LANGS_URI}")
	EGIT_CHECKOUT_DIR="${WORKDIR}/psi-l10n"
	git-r3_src_unpack

	if use extras; then
		unset EGIT_BRANCH EGIT_COMMIT
		EGIT_CHECKOUT_DIR="${WORKDIR}/psi-plus" \
		EGIT_REPO_URI="${PSI_PLUS_URI}/main.git" \
		git-r3_src_unpack

		if use iconsets; then
			unset EGIT_BRANCH EGIT_COMMIT
			EGIT_CHECKOUT_DIR="${WORKDIR}/resources" \
			EGIT_REPO_URI="${PSI_PLUS_URI}/resources.git" \
			git-r3_src_unpack
		fi
	fi
}

src_prepare() {
	default
	if use extras; then
		cp -a "${WORKDIR}/psi-plus/iconsets" "${S}" || die "failed to copy iconsets"
		if use iconsets; then
			cp -a "${WORKDIR}/resources/iconsets" "${S}" || die "failed to copy additional iconsets"
		fi

		eapply "${WORKDIR}/psi-plus/patches"/*.diff
		use sql && eapply "${WORKDIR}/psi-plus/patches/dev/psi-new-history.patch"

		vergen="${WORKDIR}/psi-plus/admin/psi-plus-nightly-version"
		features="$(use webkit && echo '--webkit') $(use webengine && echo '--webengine') $(use sql && echo '--sql')"
		NIGHTLY_VER=$("${vergen}" ./ $features)
		elog "Prepared version: ${NIGHTLY_VER}"
		echo "${NIGHTLY_VER}" > version || die "Failed to write version file"

		qconf || die "Failed to create ./configure."
	fi
}

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
	use webkit && CONF+=("--enable-webkit" "--with-webkit=qtwebkit")

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
	rm "${ED}"/usr/share/${MY_PN}/{COPYING,README} || die "Installed file set seems to be changed by upstream"
	newdoc iconsets/roster/README README.roster
	newdoc iconsets/system/README README.system
	newdoc certs/README README.certs
	dodoc README

	use doc && HTML_DOCS=( doc/api/. )
	einstalldocs

	# install translations
	local mylrelease="$(qt5_get_bindir)"/lrelease
	cd "${WORKDIR}/psi-l10n" || die
	insinto /usr/share/${MY_PN}
	install_locale() {
		"${mylrelease}" "translations/${PN}_${1}.ts" || die "lrelease ${1} failed"
		doins "translations/${PN}_${1}.qm"
	}
	l10n_for_each_locale_do install_locale
}

pkg_postinst(){
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
