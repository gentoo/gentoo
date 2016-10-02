# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PLOCALES="ar ar_SY bg ca cs da de el_GR en_GB en_US es et eu fi fr gl he_IL hr
hu id it ja ka ko ku lt mk ms_MY nl nn_NO pl pt pt_BR ro_RO ru_RU sk sl_SI sq_AL
sr sv th tr uk_UA uz vi_VN zh_CN zh_TW"
PLOCALE_BACKUP="en_US"
inherit l10n qmake-utils

DESCRIPTION="Great Qt GUI front-end for mplayer/mpv"
HOMEPAGE="http://www.smplayer.eu/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+ BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux"
IUSE="autoshutdown bidi debug mpris +qt4 qt5 streaming"

REQUIRED_USE="^^ ( qt4 qt5 )"

COMMON_DEPEND="
	sys-libs/zlib
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtsingleapplication[X,qt4]
		autoshutdown? ( dev-qt/qtdbus:4 )
		mpris? ( dev-qt/qtdbus:4 )
		streaming? ( dev-qt/qtcore:4[ssl] )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		>=dev-qt/qtsingleapplication-2.6.1_p20150629[X,qt5]
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		autoshutdown? ( dev-qt/qtdbus:5 )
		mpris? ( dev-qt/qtdbus:5 )
		streaming? (
			dev-qt/qtnetwork:5[ssl]
			dev-qt/qtscript:5
		)
	)
"
DEPEND="${COMMON_DEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
"
RDEPEND="${COMMON_DEPEND}
	|| (
		media-video/mplayer[bidi?,libass,png,X]
		(
			>=media-video/mpv-0.6.2[libass,X]
			streaming? ( >=net-misc/youtube-dl-2014.11.26 )
		)
	)
"

src_prepare() {
	default

	eapply "${FILESDIR}"/${PN}-14.9.0.6966-unbundle-qtsingleapplication.patch # bug 487544
	use bidi || eapply "${FILESDIR}"/${PN}-14.9.0.6690-zero-bidi.patch

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

	# MPRIS2 pulls in dbus, bug #553710
	if ! use mpris ; then
		sed -e 's:DEFINES += MPRIS2:#DEFINES += MPRIS2:' \
			-i "${S}"/src/smplayer.pro || die "sed failed"
	fi

	# Turn off online update checker, bug #479902
	sed -e 's:DEFINES += UPDATE_CHECKER:#DEFINES += UPDATE_CHECKER:' \
		-e 's:DEFINES += CHECK_UPGRADED:#DEFINES += CHECK_UPGRADED:' \
		-i "${S}"/src/smplayer.pro || die "sed failed"

	# Turn off nasty share widget
	sed -e 's:DEFINES += SHAREWIDGET:#DEFINES += SHAREWIDGET:' \
		-i "${S}"/src/smplayer.pro || die "sed failed"

	# Turn off youtube support (which pulls in extra dependencies) if unwanted
	if ! use streaming ; then
		sed -e 's:DEFINES += YOUTUBE_SUPPORT:#DEFINES += YOUTUBE_SUPPORT:' \
		-i "${S}"/src/smplayer.pro || die "sed failed"
	fi

	l10n_find_plocales_changes "${S}/src/translations" "${PN}_" '.ts'
}

src_configure() {
	pushd src > /dev/null || die
	use qt4 && eqmake4
	use qt5 && eqmake5
	popd > /dev/null || die
}

gen_translation() {
	local mydir
	if use qt4; then
		mydir="$(qt4_get_bindir)"
	elif use qt5; then
		mydir="$(qt5_get_bindir)"
	fi
	ebegin "Generating $1 translation"
	"${mydir}"/lrelease ${PN}_${1}.ts
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
