# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="AWE32 Sound Driver Utility Programs"
HOMEPAGE="http://ftp.suse.com/pub/people/tiwai/awesfx"
SRC_URI="http://ftp.suse.com/pub/people/tiwai/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND="media-libs/alsa-lib"
RDEPEND="${DEPEND}"

BANK_LOC="${EPREFIX}/usr/share/sounds/sf2"

DOCS=( AUTHORS ChangeLog README SBKtoSF2.txt samples/README-bank )

src_configure() {
	econf \
		--with-sfpath=${BANK_LOC}
}

src_install() {
	default

	rm "${ED}"/usr/share/sounds/sf2/README-bank || die
	newinitd "${FILESDIR}"/sfxload.initd sfxload
	newconfd "${FILESDIR}"/sfxload.confd sfxload
}

pkg_postinst() {
	elog "Copy your SoundFont files from the original CDROM"
	elog "shipped with your soundcard to ${BANK_LOC}."
}
