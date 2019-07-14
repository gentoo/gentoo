# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Oracle SQLcl is the new SQL*Plus"
HOMEPAGE="https://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/index.html"
SRC_URI="${MY_P}.zip"
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
	einfo "Please go to"
	einfo
	einfo "	${HOMEPAGE}"
	einfo
	einfo "and download"
	einfo
	einfo "	Command Line - SQLcl"
	einfo "		${SRC_URI}"
	einfo
	einfo "which must be placed in DISTDIR directory."
}

src_prepare() {
	default
	find ./ \( -iname "*.bat" -or -iname "*.exe" \) -delete || die "remove files failed"
}

src_install() {
	exeinto "/opt/${MY_PN}/bin/"
	newexe "${MY_PN}"/bin/sql sqlcl

	insinto "/opt/${MY_PN}/lib/"
	doins -r "${MY_PN}"/lib/.

	dosym "../${MY_PN}/bin/sqlcl" /opt/bin/sqlcl
}
