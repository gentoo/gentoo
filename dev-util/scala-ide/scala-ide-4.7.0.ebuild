# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-opt-2

# scala-ide -> scalaide
S_PACK="${PN/-/}-pack"

# scala-ide -> scala-SDK-${PV}
S_SDK="${PN%-*}-SDK-${PV}"

SRC_URI_AMD64="http://downloads.typesafe.com/${S_PACK}/${PV}-vfinal-oxygen-212-20170929/${S_SDK}-vfinal-2.12-linux.gtk.x86_64.tar.gz"
SRC_URI_X86="http://downloads.typesafe.com/${S_PACK}/${PV}-vfinal-oxygen-212-20170929/${S_SDK}-vfinal-2.12-linux.gtk.x86_64.tar.gz"

DESCRIPTION="The Scala IDE"
HOMEPAGE="http://www.scala-ide.org"
KEYWORDS="amd64 x86"
SRC_URI="
	amd64? ( ${SRC_URI_AMD64} )
	x86? ( ${SRC_URI_X86} )"

SLOT="0"
LICENSE="BSD"

RDEPEND=">=virtual/jdk-1.6
	|| (
		dev-lang/scala
		dev-lang/scala-bin
	)"

MY_D="/opt"

src_unpack() {
	default
	unpack ${A}
	mv "${WORKDIR}"/eclipse "${WORKDIR}/${P}" || die
}

src_prepare() {
	default
	mv "${WORKDIR}/${P}"/eclipse "${WORKDIR}/${P}/${PN}" || die
}

src_install() {
	cd "${D}" || die
	dodir "${MY_D}"
	insinto "${MY_D}"
	doins -r "${WORKDIR}/${P}"
	insopts -m 0755
	insinto "${MY_D}/${P}"
	doins "${WORKDIR}/${P}/${PN}"
	dosym "${MY_D}/${P}/${PN}" "/usr/bin/${PN}"
}
