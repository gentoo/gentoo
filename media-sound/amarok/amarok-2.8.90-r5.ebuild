# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_REQUIRED="never"
KDE_HANDBOOK="optional"
SQL_REQUIRED="always"
VIRTUALX_REQUIRED="test"
VIRTUALDBUS_TEST="true"
inherit flag-o-matic kde4-base pax-utils

DESCRIPTION="Advanced audio player based on KDE framework"
HOMEPAGE="https://amarok.kde.org/"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="4"
IUSE="debug +embedded ipod lastfm mp3tunes mtp ofa test +utils"

if [[ ${KDE_BUILD_TYPE} == live ]]; then
	RESTRICT+=" test"
fi

# ipod requires gdk enabled and also gtk compiled in libgpod
COMMONDEPEND="
	$(add_kdeapps_dep kdebase-kioslaves)
	app-crypt/qca:2[qt4]
	>=dev-qt/qtcore-4.8:4
	>=dev-qt/qtdbus-4.8:4
	>=dev-qt/qtscript-4.8:4
	>=kde-frameworks/kdelibs-4.14.37:4[plasma]
	>=media-libs/taglib-1.7[asf(+),mp4(+)]
	>=media-libs/taglib-extras-1.0.1
	sys-libs/zlib
	>=virtual/mysql-5.1[embedded?]
	>=x11-libs/qtscriptgenerator-0.1.0
	ipod? ( >=media-libs/libgpod-0.7.0[gtk] )
	lastfm? ( >=media-libs/liblastfm-1.0.3[qt4] )
	mp3tunes? (
		dev-libs/glib:2
		dev-libs/libxml2
		dev-libs/openssl:0
		>=dev-qt/qtcore-4.8.4:4[glib]
		net-libs/loudmouth
		net-misc/curl
	)
	mtp? ( >=media-libs/libmtp-1.0.0 )
	ofa? ( >=media-libs/libofa-0.9.0 )
"
DEPEND="${COMMONDEPEND}
	dev-util/automoc
	virtual/pkgconfig
	test? ( dev-cpp/gmock )
"
RDEPEND="${COMMONDEPEND}
	!media-sound/amarok-utils
	$(add_kdeapps_dep phonon-kde)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.8.0-taglib110.patch"
	"${FILESDIR}/${P}-mysql-embedded.patch"
	"${FILESDIR}/${P}-mysqld-rpath.patch"
	"${FILESDIR}/${P}-scriptconsole.patch"
	"${FILESDIR}/${P}-gcc6.patch"
	"${FILESDIR}/${P}-ffmpeg3.patch"
	"${FILESDIR}/${P}-no-webkit.patch"
)

src_prepare() {
	kde4-base_src_prepare

	# requires qtwebkit
	sed -i -e "s/wikipedia,//" data/amarok_homerc || die

	sed -i -e "/macro_log_feature.*QT_QTOPENGL_FOUND/d" \
		CMakeLists.txt \
		|| die "failed to remove QT_QTOPENGL detection"

	sed -i -e "/if/ s/QT_QTOPENGL_FOUND/FALSE/" \
		src/context/applets/CMakeLists.txt \
		|| die "failed to sed out QT_QTOPENGL_FOUND"
}

src_configure() {
	# Append minimal-toc cflag for ppc64, see bug 280552 and 292707
	use ppc64 && append-flags -mminimal-toc

	local mycmakeargs=(
		-DWITH_PLAYER=ON
		-DWITH_NepomukCore=OFF
		-DWITH_Soprano=OFF
		-DWITH_MYSQL_EMBEDDED=$(usex embedded)
		-DWITH_IPOD=$(usex ipod)
		-DWITH_LibLastFm=$(usex lastfm)
		-DWITH_MP3Tunes=$(usex mp3tunes)
		-DWITH_Mtp=$(usex mtp)
		-DWITH_LibOFA=$(usex ofa)
		-DWITH_UTILITIES=$(usex utils)
	)

	use ipod && mycmakeargs+=( DWITH_GDKPixBuf=ON )
	use mp3tunes && mycmakeargs+=( -DWITH_Libgcrypt=OFF )

	# bug 581554: add libmysqld location for rpath patch
	use embedded && mycmakeargs+=( -DMYSQLD_DIR="${EPREFIX}/usr/$(get_libdir)/mysql" )

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
		elog "You've disabled the amarok support for embedded mysql DBs."
		elog "You'll have to configure amarok to use an external db server."
		elog "Please read https://community.kde.org/Amarok/Community/MySQL for details on how"
		elog "to configure the external db and migrate your data from the embedded database."

		if has_version "virtual/mysql[minimal]"; then
			elog
			elog "You built mysql with the minimal use flag, so it doesn't include the server."
			elog "You won't be able to use the local mysql installation to store your amarok collection."
		fi
	fi
}
