# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

LANGS="be bg ca cs de en eo es et fi fr hu it ja mk nl pl pt pt_BR ru sk sl sr@latin sv sw uk ur_PK vi zh_CN zh_TW"

EGIT_REPO_URI="git://github.com/psi-im/psi.git"
EGIT_HAS_SUBMODULES=1
LANGS_REPO_URI="git://github.com/psi-plus/psi-plus-l10n.git"

PSI_PLUS_URI="git://github.com/psi-plus/main.git"
PSI_PLUS_RESOURCES_URI="git://github.com/psi-plus/resources.git"

inherit eutils gnome2-utils qt4-r2 multilib git-2 subversion

DESCRIPTION="Qt4 Jabber client, with Licq-like interface"
HOMEPAGE="http://psi-im.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="crypt dbus debug doc enchant extras jingle iconsets spell ssl xscreensaver powersave
plugins whiteboarding webkit"

REQUIRED_USE="
	iconsets? ( extras )
	plugins? ( extras )
	powersave? ( extras )
	webkit? ( extras )
"

RDEPEND="
	app-arch/unzip
	>=app-crypt/qca-2.0.2:2[qt4(+)]
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	>=sys-libs/zlib-1.2.5.1-r2[minizip]
	x11-libs/libX11
	dbus? ( dev-qt/qtdbus:4 )
	extras? ( webkit? ( dev-qt/qtwebkit:4 ) )
	spell? (
		enchant? ( >=app-text/enchant-1.3.0 )
		!enchant? ( app-text/aspell )
	)
	whiteboarding? ( dev-qt/qtsvg:4 )
	xscreensaver? ( x11-libs/libXScrnSaver )
"
DEPEND="${RDEPEND}
	extras? (
		${SUBVERSION_DEPEND}
		sys-devel/qconf
	)
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"
PDEPEND="
	crypt? ( app-crypt/qca:2[gpg] )
	jingle? (
		net-im/psimedia
		app-crypt/qca:2[openssl]
	)
	ssl? ( app-crypt/qca:2[openssl] )
"
RESTRICT="test"

pkg_setup() {
	MY_PN=psi
	if use extras; then
		MY_PN=psi-plus
		echo
		ewarn "You're about to build heavily patched version of Psi called Psi+."
		ewarn "It has really nice features but still is under heavy development."
		ewarn "Take a look at homepage for more info: https://code.google.com/p/psi-dev"
		ewarn "If you wish to disable some patches just put"
		ewarn "MY_EPATCH_EXCLUDE=\"list of patches\""
		ewarn "into /etc/portage/env/${CATEGORY}/${PN} file."
		echo
		ewarn "Note: some patches depend on other. So if you disabled some patch"
		ewarn "and other started to fail to apply, you'll have to disable patches"
		ewarn "that fail too."
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
	git-2_src_unpack
	unset EGIT_HAS_SUBMODULES EGIT_NONBARE

	# fetch translations
	mkdir "${WORKDIR}/psi-l10n"
	unset EGIT_MASTER EGIT_BRANCH EGIT_COMMIT
	EGIT_REPO_URI="${LANGS_REPO_URI}" \
	EGIT_SOURCEDIR="${WORKDIR}/psi-l10n" git-2_src_unpack

	if use extras; then
		EGIT_DIR="${EGIT_STORE_DIR}/psi-plus/main" \
		EGIT_SOURCEDIR="${WORKDIR}/psi-plus" \
		EGIT_REPO_URI="${PSI_PLUS_URI}" git-2_src_unpack
		if use iconsets; then
			EGIT_DIR="${EGIT_STORE_DIR}/psi-plus/resources" \
			EGIT_SOURCEDIR="${WORKDIR}/resources" \
			EGIT_REPO_URI="${PSI_PLUS_RESOURCES_URI}" git-2_src_unpack
		fi
	fi
}

src_prepare() {
	if use extras; then
		cp -a "${WORKDIR}/psi-plus/iconsets" "${S}" || die "failed to copy iconsets"
		use iconsets && { cp -a "${WORKDIR}/resources/iconsets" "${S}" || \
			die	"failed to copy additional iconsets"; }
		EPATCH_EXCLUDE="${MY_EPATCH_EXCLUDE} " \
		EPATCH_SOURCE="${WORKDIR}/psi-plus/patches/" EPATCH_SUFFIX="diff" EPATCH_FORCE="yes" epatch

		use powersave && epatch "${WORKDIR}/psi-plus/patches/dev/psi-reduce-power-consumption.patch"

		sed -e "s/.xxx/.$(cd "${WORKDIR}/psi-plus"; echo $((`git describe --tags | \
			cut -d - -f 2`+5000)))/" -i src/applicationinfo.cpp || die "sed failed"

		qconf || die "Failed to create ./configure."
	fi
}

src_configure() {
	# unable to use econf because of non-standard configure script
	# disable growl as it is a MacOS X extension only
	local myconf="
		--prefix="${EPREFIX}"/usr
		--qtdir="${EPREFIX}"/usr
		--disable-growl
		--no-separate-debug-info
	"
	use dbus || myconf+=" --disable-qdbus"
	use debug && myconf+=" --debug"
	if use spell; then
		use enchant && myconf+=" --disable-aspell" || myconf+=" --disable-enchant"
	else
		myconf+=" --disable-aspell --disable-enchant"
	fi
	use whiteboarding && myconf+=" --enable-whiteboarding"
	use xscreensaver || myconf+=" --disable-xss"
	if use extras; then
		use plugins && myconf+=" --enable-plugins"
		use webkit && myconf+=" --enable-webkit"
	fi

	einfo "./configure ${myconf}"
	./configure ${myconf} || die

	eqmake4
}

src_compile() {
	emake

	if use doc; then
		cd doc
		mkdir -p api # 259632
		make api_public || die "make api_public failed"
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	# this way the docs will be installed in the standard gentoo dir
	rm -f "${ED}"/usr/share/${MY_PN}/{COPYING,README}
	newdoc iconsets/roster/README README.roster
	newdoc iconsets/system/README README.system
	newdoc certs/README README.certs
	dodoc README

	if use extras && use plugins; then
		insinto /usr/share/${MY_PN}/plugins
		doins src/plugins/plugins.pri
		doins src/plugins/psiplugin.pri
		doins -r src/plugins/include
		sed -i -e "s:target.path.*:target.path = /usr/$(get_libdir)/${MY_PN}/plugins:" \
			"${ED}"/usr/share/${MY_PN}/plugins/psiplugin.pri \
			|| die "sed failed"
	fi

	use doc && dohtml -r doc/api

	# install translations
	cd "${WORKDIR}/psi-l10n/translations"
	insinto /usr/share/${MY_PN}
	for x in ${LANGS}; do
		if use linguas_${x}; then
			lrelease "${PN}_${x}.ts" || die "lrelease ${x} failed"
			doins "${PN}_${x}.qm"
		fi
	done
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	readme.gentoo_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
