# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

MY_PN="${PN/evolus/}"

DESCRIPTION="A simple GUI prototyping tool to create mockups"
HOMEPAGE="http://pencil.evolus.vn/"
SRC_URI="http://pencil.evolus.vn/dl/V3.0.4/${MY_PN^}-${PV}-49.x86_64.rpm -> ${P}-49.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="gnome-base/gconf
	media-libs/alsa-lib
	dev-libs/nspr
	dev-libs/nss
	x11-libs/gtk+:2
	x11-libs/libXtst
	x11-libs/libXScrnSaver
"

S="${WORKDIR}"

QA_PREBUILT="
	opt/${MY_PN^}/*.so
	opt/${MY_PN^}/pencil
"

src_install() {
	doins -r usr
	doins -r opt

	exeinto /opt/${MY_PN^}
	doexe opt/${MY_PN^}/{pencil,libffmpeg.so,libnode.so}
	dosym ../${MY_PN^}/pencil /opt/bin/pencil
}
