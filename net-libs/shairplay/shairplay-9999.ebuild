# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools vcs-snapshot

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/juhovh/shairplay.git"
else
	EGIT_COMMIT="498bc5bcdd305e04721f94a04b9f26a7da72673f"
	SRC_URI="https://github.com/juhovh/shairplay/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Apple airplay and raop protocol server"
HOMEPAGE="https://github.com/juhovh/shairplay"
LICENSE="BSD LGPL-2.1 MIT"

SLOT="0"
IUSE="alac static-libs tools"

DEPEND="
	tools? ( media-libs/libao )
"

RDEPEND="
	alac? (
		media-sound/alac_decoder
		net-libs/shairplay[tools]
	)
	tools? (
		dev-libs/openssl:0=
		net-dns/avahi[mdnsresponder-compat]
	)
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
