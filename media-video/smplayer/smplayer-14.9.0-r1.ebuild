# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PLOCALES="ar_SY bg ca cs da de el_GR en_US es et eu fi fr gl he_IL hr hu it ja
ka ko ku lt mk ms_MY nl pl pt pt_BR ro_RO ru_RU sk sl_SI sr sv th tr uk_UA vi_VN
zh_CN zh_TW"
PLOCALE_BACKUP="en_US"

inherit eutils l10n qt4-r2

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

DESCRIPTION="Great Qt4 GUI front-end for mplayer"
HOMEPAGE="http://www.smplayer.eu/"
LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux"
IUSE="autoshutdown bidi debug"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	autoshutdown? ( dev-qt/qtdbus:4 )"
COMMON_USE="libass,png,X"
RDEPEND="${DEPEND}
	media-video/mplayer[bidi?,${COMMON_USE}]
"

src_prepare() {
	use bidi || epatch "${FILESDIR}"/${P}-zero-bidi.patch

	# Upstream Makefile sucks
	sed -i -e "/^PREFIX=/s:${EPREFIX}/usr/local:${EPREFIX}/usr:" \
		-e "/^DOC_PATH=/s:packages/smplayer:${PF}:" \
		-e '/\.\/get_svn_revision\.sh/,+2c\
	cd src && $(DEFS) $(MAKE)' \
		"${S}"/Makefile || die "sed failed"

	# Toggle autoshutdown option which pulls in dbus, bug #524392
	if ! use autoshutdown ; then
		sed -e 's:DEFINES += AUTO_SHUTDOWN_PC:#DEFINES += AUTO_SHUTDOWN_PC:' \
			-i "${S}"/src/smplayer.pro || die "sed failed"
	fi

	# Turn debug message flooding off
	if ! use debug ; then
		sed -i 's:#\(DEFINES += NO_DEBUG_ON_CONSOLE\):\1:' \
			"${S}"/src/smplayer.pro || die "sed failed"
	fi

	# Turn off online update checker, bug #479902
	sed -e 's:DEFINES += UPDATE_CHECKER:#DEFINES += UPDATE_CHECKER:' \
		-e 's:DEFINES += CHECK_UPGRADED:#DEFINES += CHECK_UPGRADED:' \
		-i "${S}"/src/smplayer.pro || die "sed failed"

	# l10n_find_plocales_changes "${S}/src/translations" "${PN}_" '.ts'
}

src_configure() {
	cd "${S}"/src
	echo "#define SVN_REVISION \"SVN-${MY_PV} (Gentoo)\"" > svn_revision.h
	eqmake4
}

gen_translation() {
	ebegin "Generating $1 translation"
	lrelease ${PN}_${1}.ts
	eend $? || die "failed to generate $1 translation"
}

src_compile() {
	emake

	cd "${S}"/src/translations
	l10n_for_each_locale_do gen_translation
}

src_install() {
	# remove unneeded copies of licenses
	rm Copying* docs/{cs,en,hu,it,ja,pt,ru,zh_CN}/gpl.html || die
	rm -r docs/{de,es,fr,nl,ro} || die

	emake DESTDIR="${D}" install
}
