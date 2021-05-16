# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV#9999} != ${PV} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.linuxtv.org/dtv-scan-tables.git"
else
	COMMIT="c1986d5148d8"
	SRC_URI="https://linuxtv.org/downloads/dtv-scan-tables/dtv-scan-tables-${PV:3:4}-${PV:7:2}-${PV:9:2}-${COMMIT}.tar.bz2"
	KEYWORDS="amd64 ~arm ppc x86"
	S="${WORKDIR}/usr/share/dvb"
fi

DESCRIPTION="Digital TV scan tables in v3 and v5 format"
HOMEPAGE="https://linuxtv.org/"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"

DEPEND=">=media-tv/v4l-utils-1.4[dvb(+)]"

DOCS=( README )

src_compile() {
	emake dvbv3 dvbv5
}

src_install() {
	emake PREFIX="${ED}usr" install install_v3
	einstalldocs
}
