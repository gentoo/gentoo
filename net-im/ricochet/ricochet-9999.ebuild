# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg-utils

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ricochet-im/ricochet"
else
	SRC_URI="https://github.com/ricochet-im/ricochet/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Privacy-focused instant messaging through Tor hidden services"
HOMEPAGE="https://ricochet.im"

LICENSE="BSD"
SLOT="0"
IUSE="debug hardened"

RDEPEND="
	dev-libs/openssl:0=
	dev-libs/protobuf:0=
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtwidgets:5
	net-vpn/tor"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig"

src_prepare() {
	default

	# workaround bug https://github.com/ricochet-im/ricochet/issues/582
	cp contrib/usr.bin.ricochet-apparmor contrib/usr.bin.ricochet
}

src_configure() {
	local qmakeargs=( 'DEFINES+=RICOCHET_NO_PORTABLE' )
	qmakeargs+=( 'DEFINES+=APPARMOR' )
	qmakeargs+=( $(usex debug 'CONFIG+=debug' 'CONFIG+=release') )
	qmakeargs+=( $(usex hardened 'CONFIG+=hardened' 'CONFIG+=no-hardened') )

	eqmake5 "${qmakeargs[@]}"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
