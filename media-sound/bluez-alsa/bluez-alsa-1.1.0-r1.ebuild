# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils

DESCRIPTION="Bluetooth Audio ALSA Backend"
HOMEPAGE="https://github.com/Arkq/bluez-alsa"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Arkq/${PN}"
else
	SRC_URI="https://github.com/Arkq/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.16[dbus]
	>=media-libs/alsa-lib-1.0
	>=media-libs/sbc-1.2
	>=net-wireless/bluez-5"
DEPEND="${RDEPEND}
	net-libs/ortp
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug)
}

src_install() {
	default
	prune_libtool_files --modules

	newinitd "${FILESDIR}"/bluealsa-init.d bluealsa
}

pkg_postinst() {
	elog "Users can use this service when they are members of the \"audio\" group."
}
