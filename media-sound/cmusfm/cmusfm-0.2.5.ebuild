# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cmusfm/cmusfm-0.2.5.ebuild,v 1.1 2014/12/13 07:24:00 yngwin Exp $

EAPI=5
inherit autotools-utils readme.gentoo

DESCRIPTION="Last.fm scrobbler for cmus music player"
HOMEPAGE="https://github.com/Arkq/cmusfm"
SRC_URI="https://github.com/Arkq/cmusfm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"

DEPEND="net-misc/curl
	dev-libs/openssl
	libnotify? ( x11-libs/libnotify )"
RDEPEND="${DEPEND}
	media-sound/cmus"

src_prepare() {
	epatch_user
	eautoreconf
	DOC_CONTENTS="Please refer to the README.md file before running cmusfm the first time."
}

src_configure() {
	local myeconfargs=(
		$(use_enable libnotify)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_pkg_postinst
}
