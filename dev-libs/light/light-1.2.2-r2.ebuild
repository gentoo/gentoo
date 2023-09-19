# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools udev

DESCRIPTION="A program to control backlights (and other hardware lights)"
HOMEPAGE="https://github.com/haikarainen/light"
SRC_URI="https://github.com/haikarainen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="udev"

RDEPEND="
	acct-group/video
	!sys-power/acpilight
	udev? ( virtual/libudev:= )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fcommon.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(usex udev --with-udev="$(get_udevdir)/rules.d" "")
	)

	econf "${myeconfargs[@]}"
}

pkg_postinst() {
	use udev && udev_reload

	ewarn "To use light as a regular user you must be a part of the video group"
}
