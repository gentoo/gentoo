# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Oracle SQLcl is the new SQL*Plus"
HOMEPAGE="http://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/index.html"
SRC_URI="${MY_P}-no-jre.zip"
RESTRICT="bindist fetch mirror"

LICENSE="OTN"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="virtual/jre:1.8
	dev-java/java-config:2
	dev-db/oracle-instantclient"

S="${WORKDIR}"

pkg_nofetch() {
	eerror "Please go to"
	eerror "	${HOMEPAGE}"
	eerror "and download"
	eerror "	Command Line - SQLcl"
	eerror "		${SRC_URI}"
	eerror "and move it to DISTDIR directory."
}

src_prepare() {
	default
	find ./ \( -iname "*.bat" -or -iname "*.exe" \) -exec rm {} + || die "remove files failed"
	mv sqlcl/bin/sql sqlcl/bin/"${MY_PN}" || die "rename executable failed"
}

src_install() {
	exeinto "/opt/${MY_PN}/bin/"
	doexe "${S}/${MY_PN}/bin/${MY_PN}"

	insinto "/opt/${MY_PN}/lib/"
	doins -r "${S}/${MY_PN}/lib/"*

	dosym "${ED%/}/opt/${MY_PN}/bin/${MY_PN}" "/opt/bin/${MY_PN}"
}
