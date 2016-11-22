# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils autotools

DESCRIPTION="Audio file volume normalizer"
HOMEPAGE="http://normalize.nongnu.org/"
SRC_URI="https://savannah.nongnu.org/download/${PN}/${P}.tar.bz2
	https://dev.gentoo.org/~radhermit/distfiles/${P}-m4.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="audiofile mad nls userland_BSD"

RDEPEND="mad? ( media-libs/libmad )
	audiofile? ( >=media-libs/audiofile-0.3.1 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( dev-util/intltool )"

src_prepare() {
	use userland_BSD && sed -i -e 's/md5sum/md5/' "${S}"/test/*.sh

	epatch "${FILESDIR}"/${P}-audiofile-pkgconfig.patch
	epatch "${WORKDIR}"/${P}-m4.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_with audiofile) \
		$(use_with mad) \
		$(use_enable nls) \
		--disable-xmms
}
