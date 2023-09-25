# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=tinynotify-send-${PV}
DESCRIPTION="A system-wide variant of tinynotify-send"
HOMEPAGE="https://github.com/projg2/tinynotify-send/"
SRC_URI="https://github.com/projg2/tinynotify-send/releases/download/${MY_P}/${MY_P}.tar.bz2"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	x11-libs/libtinynotify:0=
	~x11-libs/libtinynotify-cli-${PV}
	x11-libs/libtinynotify-systemwide:0=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( README )

src_configure() {
	local myconf=(
		--disable-library
		--disable-regular
		--enable-system-wide
	)

	econf "${myconf[@]}"
}
