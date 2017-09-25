# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-opt-2

E_V="-neon-212-20170609"
S_V="2.12'"

S_PACK="${PN/-/}-pack"
S_SDK="${PN%-*}-SDK-${PV}-vfinal"

DESCRIPTION="The Scala IDE"
HOMEPAGE="http://www.scala-ide.org"
KEYWORDS="~amd64"
SRC_URI="
	https://downloads.typesafe.com/${S_PACK}/${PV}-vfinal${E_V}/${S_SDK}-${S_V}-linux.gtk.x86_64.tar.gz"

SLOT="0"
LICENSE="BSD"

RDEPEND="
	>=virtual/jdk-1.8
	>=dev-lang/scala-${S_V}"

MY_D="/opt"
S="${WORKDIR}/eclipse"

src_install() {
	mv eclipse "${PN}" || die

	dodir "${MY_D}"
	mv "${S}" "${D}/${MY_D}/${P}" || die

	insinto "${MY_D}/${P}"
	dosym "${MY_D}/${P}/${PN}" "/usr/bin/${PN}"
}
