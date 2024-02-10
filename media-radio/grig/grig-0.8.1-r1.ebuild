# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="A tool for controlling amateur radios"
HOMEPAGE="http://groundstation.sourceforge.net/grig/"
SRC_URI="mirror://sourceforge/groundstation/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	>=media-libs/hamlib-4:="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/grig-0.8.1-hamlib4.patch
		  "${FILESDIR}"/grig-0.8.1-hamlib45.patch )

src_configure() {
	econf --enable-hardware
}

src_prepare() {
	# prepare for media-radio/hamlib-4.2 change of API
	if has_version '>=media-libs/hamlib-4.2' ; then
		eapply -p1 "${FILESDIR}"/${P}-hamlib42.patch
	fi

	eapply ${PATCHES[@]}

	eapply_user
}

src_install() {
	default
	make_desktop_entry ${PN} "GRig" "/usr/share/pixmaps/grig/grig-logo.png" "HamRadio"
	rm -rf "${ED}/usr/share/grig" || die "cleanup docs failed"
}
