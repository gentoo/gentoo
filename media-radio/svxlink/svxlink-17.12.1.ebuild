# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils systemd user

CMAKE_USE_DIR="${S}/src"

DESCRIPTION="Multi Purpose Voice Services System, including Qtel for EchoLink"
HOMEPAGE="http://www.svxlink.org"
SRC_URI="https://github.com/sm0svx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="dev-lang/tcl:0
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	media-sound/gsm
	dev-libs/libgcrypt:0
	media-libs/speex
	media-libs/opus
	dev-libs/libsigc++:2
	dev-libs/popt"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig"

pkg_setup() {
	enewgroup svxlink
	enewuser svxlink -1 -1 -1 svxlink
}

src_prepare() {
	cmake-utils_src_prepare
	# drop deprecated desktop category (bug #475730)
	sed -i -e "s:Categories=Application;:Categories=:g" src/qtel/qtel.desktop || die
}

src_configure() {
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR=/etc
		-DLOCAL_STATE_DIR=/var
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	fowners -R svxlink.svxlink /var/spool/svxlink

	rm -R "${D}"/usr/share/doc/svxlink || die
	doman src/doc/man/*.1 src/doc/man/*.5

	insinto /etc/logrotate.d
	doins   distributions/gentoo/etc/logrotate.d/*

	newinitd "${FILESDIR}"/remotetrx.init remotetrx
	newinitd "${FILESDIR}"/svxlink.init svxlink
	newconfd "${FILESDIR}"/remotetrx.rc remotetrx
	newconfd "${FILESDIR}"/svxlink.rc svxlink

	systemd_dounit "${FILESDIR}"/remotetrx.service
	systemd_dounit "${FILESDIR}"/svxlink.service
}
