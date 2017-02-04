# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="A freeware clone of Counter-Strike with some added features in gameplay"
HOMEPAGE="http://www.cs2d.com/"
SRC_URI="https://dev.gentoo.org/~maksbotan/cs2d/cs2d_${PV}_linux.zip
	https://dev.gentoo.org/~maksbotan/cs2d/cs2d_${PV}_win.zip
	https://dev.gentoo.org/~maksbotan/cs2d/cs2d.png"
LICENSE="freedist"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="
	x86? (
		media-libs/freetype:2
		media-libs/openal
		x11-libs/libX11
		x11-libs/libXxf86vm
		virtual/opengl
	)
	amd64? (
		>=media-libs/freetype-2.5.0.1:2[abi_x86_32(-)]
		>=media-libs/openal-1.15.1[abi_x86_32(-)]
		>=virtual/opengl-7.0-r1[abi_x86_32(-)]
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		>=x11-libs/libXxf86vm-1.1.3[abi_x86_32(-)]
	)"

QA_PREBUILT="opt/cs2d/CounterStrike2D"

S=${WORKDIR}

src_prepare() {
	default

	# removing windows files
	rm -f *.exe *.bat || die

	# OpenAL is default sound driver
	sed -i \
		-e 's:^sounddriver.*$:sounddriver OpenAL Default:' \
		sys/config.cfg || die
}

src_install() {
	insinto /opt/${PN}
	doins -r .

	# avoid file collision with untracked file
	rm -f "${ED%/}/opt/${PN}/sys/core/started.cfg"

	make_desktop_entry CounterStrike2D "Counter Strike 2D"
	make_desktop_entry "CounterStrike2D -fullscreen -24bit" "Counter Strike 2D - FULLSCREEN"
	make_wrapper CounterStrike2D ./CounterStrike2D /opt/${PN} /opt/${PN}
	doicon "${DISTDIR}"/${PN}.png

	# fixing permissions
	fperms -R g+w /opt/${PN}/maps
	fperms -R g+w /opt/${PN}/screens
	fperms -R g+w /opt/${PN}/sys
	fperms o+x /opt/${PN}/CounterStrike2D
}
