# Copyright 2007-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="am ar_SY ar bg ca cs da de el en_GB en en_US es et eu fa fi fr gl
he_IL hr hu id it ja ka ko ku lt mk ms_MY nl nn_NO pl pt_BR pt ro_RO ru_RU
sk sl_SI sq_AL sr sv th tr uk_UA uz vi_VN zh_CN zh_TW"
PLOCALE_BACKUP="en_US"

inherit l10n qmake-utils toolchain-funcs xdg

DESCRIPTION="Great Qt GUI front-end for mplayer/mpv"
HOMEPAGE="https://www.smplayer.eu/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+ BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE="autoshutdown bidi debug mpris"

BDEPEND="dev-qt/linguist-tools:5"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5=
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtscript:5
	dev-qt/qtsingleapplication[X,qt5(+)]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-libs/zlib
	autoshutdown? ( dev-qt/qtdbus:5 )
	mpris? ( dev-qt/qtdbus:5 )
"
RDEPEND="${DEPEND}
	|| (
		media-video/mpv[libass,X]
		media-video/mplayer[bidi?,libass,png,X]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-14.9.0.6966-unbundle-qtsingleapplication.patch" # bug 487544
	"${FILESDIR}/${PN}-17.1.0-advertisement_crap.patch"
	"${FILESDIR}/${PN}-18.2.0-jobserver.patch"
	"${FILESDIR}/${PN}-18.3.0-disable-werror.patch"
	"${FILESDIR}/${P}-mpv-0.30.0.patch" #698738
)

src_prepare() {
	use bidi || PATCHES+=( "${FILESDIR}"/${PN}-16.4.0-zero-bidi.patch )

	default

	# Upstream Makefile sucks
	sed -i -e "/^PREFIX=/ s:/usr/local:${EPREFIX}/usr:" \
		-e "/^DOC_PATH=/ s:packages/smplayer:${PF}:" \
		-e '/\.\/get_svn_revision\.sh/,+2c\
	cd src && $(DEFS) $(MAKE)' \
		Makefile || die

	# Turn off online update checker, bug #479902
	sed -e 's:DEFINES += UPDATE_CHECKER:#&:' \
		-e 's:DEFINES += CHECK_UPGRADED:#&:' \
		-i src/smplayer.pro || die

	# Turn off intrusive share widget
	sed -e 's:DEFINES += SHARE_WIDGET:#&:' \
		-i src/smplayer.pro || die

	# Toggle autoshutdown option which pulls in dbus, bug #524392
	if ! use autoshutdown ; then
		sed -e 's:DEFINES += AUTO_SHUTDOWN_PC:#&:' \
			-i src/smplayer.pro || die
	fi

	# Turn debug message flooding off
	if ! use debug ; then
		sed -e 's:#\(DEFINES += NO_DEBUG_ON_CONSOLE\):\1:' \
			-i src/smplayer.pro || die
	fi

	# MPRIS2 pulls in dbus, bug #553710
	if ! use mpris ; then
		sed -e 's:DEFINES += MPRIS2:#&:' \
			-i src/smplayer.pro || die
	fi

	# Commented out because it gives false positives
	#l10n_find_plocales_changes "${S}"/src/translations ${PN}_ .ts
}

src_configure() {
	cd src || die
	eqmake5
}

gen_translation() {
	local mydir="$(qt5_get_bindir)"

	ebegin "Generating $1 translation"
	"${mydir}"/lrelease ${PN}_${1}.ts
	eend $? || die "failed to generate $1 translation"
}

src_compile() {
	emake CC="$(tc-getCC)"

	cd src/translations || die
	l10n_for_each_locale_do gen_translation
}

src_install() {
	# remove unneeded copies of the GPL
	rm -f Copying* docs/*/gpl.html || die
	# don't install empty dirs
	rmdir --ignore-fail-on-non-empty docs/* || die

	default
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "If you want URL support with media-video/mpv, please install"
	elog "net-misc/youtube-dl."
}

pkg_postrm() {
	xdg_pkg_postrm
}
