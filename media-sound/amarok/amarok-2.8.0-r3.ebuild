# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="bs ca ca@valencia cs da de el en_GB es et eu fi fr ga gl hu it ja
lt lv nb nl pa pl pt pt_BR ro ru sl sr sr@ijekavian sr@ijekavianlatin sr@latin
sv tr uk zh_CN zh_TW"
KDE_REQUIRED="never"
KDE_HANDBOOK="optional"
KDE_MINIMAL="4.13.1"
VIRTUALX_REQUIRED="test"
VIRTUALDBUS_TEST="true"
inherit flag-o-matic kde4-base pax-utils

DESCRIPTION="Advanced audio player based on KDE framework"
HOMEPAGE="https://amarok.kde.org/"
if [[ ${PV} != *9999* ]]; then
	if [[ $PV == *[6-9][0-9]* ]]; then
		SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.bz2"
	else
		SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.bz2"
	fi
	KEYWORDS="amd64 ppc x86"
else
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="4"
IUSE="cdda debug +embedded ipod lastfm mp3tunes mtp ofa opengl test +utils"

if [[ ${KDE_BUILD_TYPE} == live ]]; then
	RESTRICT="test"
fi

# ipod requires gdk enabled and also gtk compiled in libgpod
COMMONDEPEND="
	app-crypt/qca:2[qt4(+)]
	$(add_kdebase_dep kdelibs 'opengl?' 4.8.4)
	$(add_kdeapps_dep kdebase-kioslaves)
	>=media-libs/taglib-1.7[asf,mp4]
	>=media-libs/taglib-extras-1.0.1
	sys-libs/zlib
	>=virtual/mysql-5.1[embedded?]
	>=dev-qt/qtcore-4.8:4
	>=dev-qt/qtdbus-4.8:4
	>=dev-qt/qtscript-4.8:4
	>=x11-libs/qtscriptgenerator-0.1.0
	cdda? (
		$(add_kdeapps_dep libkcddb)
		$(add_kdeapps_dep libkcompactdisc)
		$(add_kdeapps_dep audiocd-kio)
	)
	ipod? ( >=media-libs/libgpod-0.7.0[gtk] )
	lastfm? ( >=media-libs/liblastfm-1.0.3 )
	mp3tunes? (
		dev-libs/glib:2
		dev-libs/libxml2
		dev-libs/openssl:0
		net-libs/loudmouth
		net-misc/curl
		>=dev-qt/qtcore-4.8.4:4[glib]
	)
	mtp? ( >=media-libs/libmtp-1.0.0 )
	ofa? ( >=media-libs/libofa-0.9.0 )
	opengl? ( virtual/opengl )
"
DEPEND="${COMMONDEPEND}
	dev-util/automoc
	virtual/pkgconfig
	test? ( dev-cpp/gmock )
"
RDEPEND="${COMMONDEPEND}
	!media-sound/amarok-utils
	|| ( kde-apps/phonon-kde:4
		$(add_kdeapps_dep phonon-kde) )
"

PATCHES=(
	"${FILESDIR}/${P}-gmock-1.7.patch"
	"${FILESDIR}/${P}-mysqld-rpath.patch"
)

src_configure() {
	# Append minimal-toc cflag for ppc64, see bug 280552 and 292707
	use ppc64 && append-flags -mminimal-toc

	local mycmakeargs=(
		-DWITH_PLAYER=ON
		-DWITH_Libgcrypt=OFF
		-DWITH_SPECTRUM_ANALYZER=OFF
		-DWITH_NepomukCore=OFF
		-DWITH_Soprano=OFF
		$(cmake-utils_use embedded WITH_MYSQL_EMBEDDED)
		$(cmake-utils_use_with ipod)
		$(cmake-utils_use_with ipod Gdk)
		$(cmake-utils_use_with lastfm LibLastFm)
		$(cmake-utils_use_with mtp)
		$(cmake-utils_use_with mp3tunes MP3Tunes)
		$(cmake-utils_use_with ofa LibOFA)
		$(cmake-utils_use_with utils UTILITIES)
	)

	# Add libmysqld location for rpath patch; bug 508824
	use embedded && mycmakeargs+=(-DMYSQLD_DIR="${EPREFIX}/usr/$(get_libdir)/mysql")

	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install

	# bug 481592
	pax-mark m "${ED}"/usr/bin/amarok
}

pkg_postinst() {
	kde4-base_pkg_postinst

	if ! use embedded; then
		echo
		elog "You've disabled the amarok support for embedded mysql DBs."
		elog "You'll have to configure amarok to use an external db server."
		echo
		elog "Please read https://amarok.kde.org/wiki/MySQL_Server for details on how"
		elog "to configure the external db and migrate your data from the embedded database."
		echo

		if has_version "virtual/mysql[minimal]"; then
			elog "You built mysql with the minimal use flag, so it doesn't include the server."
			elog "You won't be able to use the local mysql installation to store your amarok collection."
			echo
		fi
	fi
}
