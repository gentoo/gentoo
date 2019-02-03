# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3 autotools

DESCRIPTION="A voice inversion descrambler"
HOMEPAGE="https://github.com/windytan/deinvert"
SRC_URI=""
EGIT_REPO_URI="https://github.com/windytan/deinvert.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+liquid +wav"

DEPEND="liquid? ( net-libs/liquid-dsp )
		wav? ( media-libs/libsndfile )
"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_with liquid) \
		$(use_with wav sndfile)
}
