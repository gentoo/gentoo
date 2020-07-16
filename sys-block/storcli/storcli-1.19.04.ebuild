# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pax-utils

DESCRIPTION="MegaRAID StorCLI (successor of the MegaCLI)"
HOMEPAGE="http://www.avagotech.com/support/download-search?dnd-keyword=storcli"
# For new versions check http://www.avagotech.com/cs/Satellite?pagename=AVG2/Utilities/searchResultsJson&page=1&q=storcli&endDate=null&searchType=type-AVG_Document_C~Downloads&isEntitled=null&dynamic-search-relevance=Newest
SRC_URI="http://docs.avagotech.com/docs-and-downloads/docs-and-downloads/raid-controllers/raid-controllers-common-files/${PV}_StorCLI.zip -> ${P}.zip"

LICENSE="Avago LSI BSD"
SLOT="0/6.11"
KEYWORDS="-* amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

DOCS=( readme.txt license.txt )

MY_STORCLI_BASEDIR="/opt/lsi/storcli"

QA_PRESTRIPPED="${MY_STORCLI_BASEDIR:1}/storcli"

src_unpack() {
	unpack ${A}

	mv storcli_all_os/Ubuntu/storcli_*.deb "${WORKDIR}" || die "Failed to move storclli_*.deb"

	# Unpack Ubuntu package which will be our $S content
	unpack "${WORKDIR}"/storcli_*.deb
	rm -f storcli_*.deb || die "Failed to cleanup storcli_*.deb package"
	unpack "${WORKDIR}"/data.tar.gz

	mkdir "${S}" || die "Failed to create '${S}'"
}

src_prepare() {
	default

	# Create clean $S
	mv "${WORKDIR}"/*CLI.txt "${S}"/readme.txt || die "Failed to move *CLI.txt to readme.txt"
	mv "${WORKDIR}"/storcli_all_os/Linux/license.txt "${S}"/license.txt || die "Failed to move Linux/license.txt"
	rm -rf "${WORKDIR}"/storcli_all* || die "Failed to cleanup storcli_all* dirs/files"
	mv "${WORKDIR}"/opt/Mega*/storcli/* "${S}" || die "Failed to move storcli_.deb content to '${S}'"
	rm -rf "${WORKDIR}"/{opt,control.tar.gz,data.tar.gz,debian-binary} || die "Failed to cleanup no longer needed files"
}

src_install() {
	exeinto "${MY_STORCLI_BASEDIR}"

	if use x86; then
		doexe storcli
	elif use amd64; then
		newexe storcli64 storcli
	fi

	dosym "${MY_STORCLI_BASEDIR}"/storcli /usr/sbin/storcli

	dodoc "${DOCS[@]}"

	pax-mark m "${D%/}${MY_STORCLI_BASEDIR}"/storcli
}
