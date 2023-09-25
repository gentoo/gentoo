# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DESCRIPTION="Quake4 SDK"
HOMEPAGE="https://iddevnet.dhewm3.org/quake4/Quake4SDK.html"
SRC_URI="mirror://idsoftware/quake4/source/linux/quake4-linux-${PV}-sdk.x86.run"
S="${WORKDIR}"

LICENSE="QUAKE4"
SLOT="0"
KEYWORDS="-* amd64 x86"
RESTRICT="bindist mirror strip"

src_unpack() {
	unpack_makeself
	rm -rf setup.{sh,data} || die
}

src_install() {
	insinto /opt/${PN}
	doins -r *
}
