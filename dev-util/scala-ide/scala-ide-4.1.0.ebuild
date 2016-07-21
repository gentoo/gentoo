# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5

inherit java-pkg-opt-2

SRC_URI_AMD64="http://downloads.typesafe.com/scalaide-pack/${PV}-vfinal-luna-211-20150525/scala-SDK-${PV}-vfinal-2.11-linux.gtk.x86_64.tar.gz"
SRC_URI_X86="http://downloads.typesafe.com/scalaide-pack/${PV}-vfinal-luna-211-20150525/scala-SDK-${PV}-vfinal-2.11-linux.gtk.x86.tar.gz"

DESCRIPTION="The Scala IDE"
HOMEPAGE="http://www.scala-ide.org"
KEYWORDS="amd64 x86"
SRC_URI="
	amd64? ( ${SRC_URI_AMD64} )
	x86? ( ${SRC_URI_X86} )
"

SLOT="0"
LICENSE="BSD"

DEPEND=">=virtual/jdk-1.6
	|| (
		dev-lang/scala
		dev-lang/scala-bin
	)"
RDEPEND=">=virtual/jre-1.6"

MY_D="/opt"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/eclipse "${WORKDIR}"/"${P}"
}

src_prepare() {
	mv "${WORKDIR}"/"${P}"/eclipse "${WORKDIR}"/"${P}"/"${PN}"
}

src_install() {
	cd "${D}" || die
	dodir "${MY_D}" || die
	insinto "${MY_D}"
	doins -r "${WORKDIR}"/"${P}" || die
	insopts -m 0755
	insinto "${MY_D}"/"${P}"
	doins "${WORKDIR}"/"${P}"/"${PN}" || die
	dosym ${MY_D}/${P}/${PN} /usr/bin/${PN} || die
}
