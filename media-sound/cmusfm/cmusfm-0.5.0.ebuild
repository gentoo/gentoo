# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools readme.gentoo-r1

DESCRIPTION="Last.fm scrobbler for cmus music player"
HOMEPAGE="https://github.com/Arkq/cmusfm"
SRC_URI="https://github.com/Arkq/cmusfm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="libnotify"

DEPEND="
	net-misc/curl
	dev-libs/openssl:0=
	libnotify? ( x11-libs/libnotify )
"
RDEPEND="
	${DEPEND}
	media-sound/cmus
"
BDEPEND="virtual/pkgconfig"

DOC_CONTENTS="Please refer to the README.md file before running cmusfm the first time."

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable libnotify)
}

src_install() {
	default
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_pkg_postinst
}
