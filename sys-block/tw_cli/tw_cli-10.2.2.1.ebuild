# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="3ware SATA/PATA/SAS RAID controller Command Line Interface tool"
HOMEPAGE="http://www.lsi.com/products/raid-controllers/pages/3ware-sas-9750-8i.aspx"

# This is apparently what the upstream stuff was based on when LSI took over?
ThreeDM2_PV="9.5.5.1"

SRC_URI_BASE="http://www.lsi.com/downloads/Public/SATA/SATA%20Common%20Files/"
SRC_URI_A_linux="CLI_linux-from_the_${PV}_${ThreeDM2_PV}_codesets.zip"
SRC_URI_A_fbsd="CLI_freebsd-from_the_${PV}_${ThreeDM2_PV}_codesets.zip"
SRC_URI="kernel_linux? ( ${SRC_URI_BASE}/${SRC_URI_A_linux} )
		 kernel_FreeBSD? ( ${SRC_URI_BASE}/${SRC_URI_A_fbsd} )
		 https://gitweb.gentoo.org/repo/gentoo.git/plain/licenses/LSI-tw_cli"
# The license is not available easily from upstream (embedded in a textbox),
# nor in the upstream tarball, but needs to be installed, and can't be
# referenced via PORTDIR per bug #373349.
# the minor ver on the end changes...
RELNOTES="${SRC_URI_BASE}/${PV}_Release_Notes.pdf"

# Note: 3ware gave permission to redistribute the binaries before:
# Ref: https://bugs.gentoo.org/show_bug.cgi?id=60690#c106
#
# Please note that the LSI-tw_cli license does allow redistribution, despite
# being a EULA:
# 2. Grant of Rights
# 2.1 LSI Binary Code. Subject to the terms of this Agreement, LSI grants
# to Licensee a non-exclusive, world-wide, revocable (for breach in
# accordance with Section 7), non-transferable limited license, without
# the right to sublicense except as expressly provided herein, solely to:
# (c) Distribute the LSI Binary Code as incorporated in Licensee's
# Products or for use with LSI Devices to its Subsequent Users;
# (d) Distribute the Explanatory Materials related to LSI Binary Code only
# for use with LSI Devices;
#
# 3. License Restrictions
# 3.1. LSI Binary Code. The Licenses granted in Section 2.1 for LSI Binary
# Code and related Explanatory Materials are subject to the following
# restrictions:
# (a) Licensee shall not use the LSI Binary Code and related Explanatory
# Materials for any purpose other than as expressly provided in Article 2;
# (b) Licensee shall reproduce all copyright notices and other proprietary
# markings or legends contained within or on the LSI Binary Code and
# related Explanatory Materials on any copies it makes; and
LICENSE="LSI-tw_cli"
SLOT="0"

# This package can never enter stable, it can't be mirrored and upstream
# can remove the distfiles from their mirror anytime.
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RESTRICT="strip"
QA_PREBUILT="/opt/tw_cli/tw_cli"

# binary packages
DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

# If you want to fetch it yourself (not from the mirrors), there is an IP-based
# clickthrough to accept the EULA.
pkg_nofetch() {
	einfo "Upstream has implemented a mandatory clickthrough EULA for distfile download"
	einfo "Please visit ${SRC_URI}"
	einfo "And place ${A} into your DISTDIR directory"
}

src_install() {
	case ${ARCH} in
		amd64) CLI_BIN=x86_64/tw_cli;;
		x86) CLI_BIN=x86/tw_cli;;
		*) die "unsupported ARCH";;
	esac
	exeinto /opt/tw_cli
	# The names have varied in the past, sometimes there is a suffix
	newexe ${CLI_BIN} tw_cli
	dosym /opt/tw_cli/tw_cli /usr/sbin/tw_cli

	newman ${PN}.8.nroff ${PN}.8
	dohtml *.html
	dodoc *.txt

	# to comply with license requirement 3.1.b, per upstream request.
	insinto /opt/tw_cli
	newins ${DISTDIR}/${LICENSE} LICENSE
}

pkg_postinst() {
	elog "This binary supports should support ALL cards, including, but not"
	elog "limited to the following series:"
	elog ""
	elog "PATA: 6xxx, 72xx, 74xx, 78xx, 7000, 7500, 7506"
	elog "SATA: 8006, 8500, 8506, 9500S, 9550SX, 9590SE,"
	elog "      9550SXU, 9650SE, 9650SE-{24M8,4LPME},"
	elog "      9690SA, 9750"
	elog ""
	elog "Release notes for this version are available at:"
	elog "${RELNOTES}"
}
