# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/dbmeasure/dbmeasure-0.0.20100217.ebuild,v 1.3 2013/05/06 14:04:22 ssuominen Exp $

EAPI=5
GIT_COMMITID="ed8105083ab72f9afac9d18b7563fbc3d6c1c925"
MY_PV="${PV}-${GIT_COMMITID}"
MY_P="${PN}-${MY_PV}"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="ALSA Volume Control Attenuation Measurement Tool"
HOMEPAGE="http://pulseaudio.org/wiki/BadDecibel"
SRC_URI="http://git.0pointer.de/?p=${PN}.git;a=snapshot;h=${GIT_COMMITID};sf=tgz -> ${MY_P}.tar.gz"

LICENSE="BSD" # need to confirm w/ upstream
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/alsa-lib-1.0.26"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

src_prepare() {
	tc-export CC
	# We drop the -g for debug output but we keep the -O0, as we don't want GCC
	# to optimize out some critical math.
	strip-flags
	sed -i \
		-e 's:$(CC):& $(LDFLAGS):' \
		-e '/^CFLAGS/s:=:+=:' \
		-e '/^CFLAGS/s:-g -pipe::' \
		Makefile || die
}

src_install() {
	dobin db{measure,verify}
	dodoc README
}
