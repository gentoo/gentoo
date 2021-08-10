# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A program to control backlights (and other hardware lights)"
HOMEPAGE="https://github.com/haikarainen/light"
SRC_URI="https://github.com/haikarainen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="udev"

RDEPEND=""
DEPEND="udev? ( virtual/libudev:= )
		${RDEPEND}"

src_prepare() {
	eapply "${FILESDIR}/${P}-fcommon.patch"
	eapply_user
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(usex udev --with-udev="/lib/udev/rules.d" "")
	)
	econf "${myeconfargs[@]}"
}
