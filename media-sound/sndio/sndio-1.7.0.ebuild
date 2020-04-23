# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="small audio and MIDI framework part of the OpenBSD project"
HOMEPAGE="http://www.sndio.org/"
SRC_URI="http://www.sndio.org/${P}.tar.gz"
LICENSE="ISC"
SLOT="0/7.0"
KEYWORDS="~amd64"
IUSE="alsa"

DEPEND="
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${DEPEND}
	acct-user/sndiod
"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	./configure \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--privsep-user=sndiod \
		--with-libbsd \
		$(use_enable alsa)
}

src_install() {
	multilib-minimal_src_install

	doinitd "${FILESDIR}/sndiod"
}
