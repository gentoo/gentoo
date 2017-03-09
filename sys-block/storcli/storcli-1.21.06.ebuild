# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit pax-utils

# Upstream messed up packaging:
# This is v1.21.06 according to "storcli -v" but ZIP is named v1.21.16..
# Also, README is isn't included in archive.
MY_PV="1.21.16"

DESCRIPTION="MegaRAID StorCLI (successor of the MegaCLI)"
HOMEPAGE="https://www.broadcom.com/support/download-search?dk=storcli"
SRC_URI="https://docs.broadcom.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/${MY_PV}_StorCLI.zip -> ${P}.zip
	https://docs.broadcom.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/${PV}_StorCLI.txt -> ${P}_readme.txt"

LICENSE="Avago LSI BSD"
SLOT="0/6.13"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

DOCS=( readme.txt license.txt )

MY_STORCLI_BASEDIR="/opt/lsi/storcli"

QA_PRESTRIPPED="${MY_STORCLI_BASEDIR:1}/storcli"

src_unpack() {
	local _src_file

	for _src_file in ${A}; do
		if [[ ${_src_file} == *.txt ]]; then
			cp "${DISTDIR}/${_src_file}" "${WORKDIR}" || die "Failed to copy '${_src_file}' to '${WORKDIR}'!"
		else
			unpack ${_src_file}
		fi
	done

	mv versionChangeSet/univ_viva_cli_rel/storcli_All_OS.zip "${WORKDIR}" || die "Failed to move storcli_All_OS.zip"
	rm -rf versionChangeSet || die "Failed to cleanup upstream's archive mess (versionChangeSet)"
	rm -rf cqAttachments || die "Failed to cleanup upstream's archive mess (cqAttachments)"
	unpack "${WORKDIR}"/storcli_All_OS.zip

	mv storcli_All_OS/Ubuntu/storcli_*.deb "${WORKDIR}" || die "Failed to move storclli_*.deb"

	# Unpack Ubuntu package which will be our $S content
	unpack "${WORKDIR}"/storcli_*.deb
	rm -f storcli_*.deb || die "Failed to cleanup storcli_*.deb package"
	unpack "${WORKDIR}"/data.tar.gz

	mkdir "${S}" || die "Failed to create '${S}'"
}

src_prepare() {
	default

	# Create clean $S
	mv "${WORKDIR}"/*_readme.txt "${S}"/readme.txt || die "Failed to move *CLI.txt to readme.txt"
	mv "${WORKDIR}"/storcli_All_OS/Linux/license.txt "${S}"/license.txt || die "Failed to move Linux/license.txt"
	rm -rf "${WORKDIR}"/storcli_All* || die "Failed to cleanup storcli_all* dirs/files"
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
