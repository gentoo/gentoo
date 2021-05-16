# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit pax-utils

# Upstream is still using strange version numbers
MY_PV="007.0709.0000.0000"

DESCRIPTION="MegaRAID StorCLI (successor of the MegaCLI)"
HOMEPAGE="https://www.broadcom.com/support/download-search?dk=storcli"
SRC_URI="https://docs.broadcom.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/${MY_PV}_Unified_StorCLI.zip -> ${P}.zip"

LICENSE="Avago LSI BSD"
SLOT="0/7.7"
KEYWORDS="-* amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

DOCS=( readme.txt license.txt )

MY_STORCLI_BASEDIR="/opt/lsi/storcli"

QA_PRESTRIPPED="${MY_STORCLI_BASEDIR:1}/storcli
	${MY_STORCLI_BASEDIR:1}/storcli32"
QA_PREBUILT=${QA_PRESTRIPPED}

src_unpack() {
	local _src_file

	for _src_file in ${A}; do
		if [[ ${_src_file} == *.txt ]]; then
			cp "${DISTDIR}/${_src_file}" "${WORKDIR}" || die "Failed to copy '${_src_file}' to '${WORKDIR}'!"
		else
			unpack ${_src_file}
		fi
	done

	unpack "${WORKDIR}"/Unified_storcli_all_os.zip

	mv Unified_storcli_all_os/Ubuntu/storcli_*.deb "${WORKDIR}" || die "Failed to move storcli_*.deb"

	# Unpack Ubuntu package which will be our $S content
	unpack "${WORKDIR}"/storcli_*.deb
	rm -f storcli_*.deb || die "Failed to cleanup storcli_*.deb package"
	unpack "${WORKDIR}"/data.tar.gz

	mkdir "${S}" || die "Failed to create '${S}'"
}

src_prepare() {
	default

	# Create clean $S
	mv "${WORKDIR}"/*_StorCLI.txt "${S}"/readme.txt || die "Failed to move *StorCLI.txt to readme.txt"
	mv "${WORKDIR}"/Unified_storcli_all_os/Linux/license.txt "${S}"/license.txt || die "Failed to move Linux/license.txt"
	rm -rf "${WORKDIR}"/Unified_stor* || die "Failed to cleanup Unified_storcli* dirs/files"
	mv "${WORKDIR}"/opt/Mega*/storcli/* "${S}" || die "Failed to move storcli_.deb content to '${S}'"
	rm -rf "${WORKDIR}"/{opt,control.tar.gz,data.tar.gz,debian-binary} || die "Failed to cleanup no longer needed files"
}

src_install() {
	exeinto "${MY_STORCLI_BASEDIR}"

	if use x86; then
		doexe storcli
	elif use amd64; then
		# 32-bit version is less crashy than the 64bit (bug #656494)
		newexe storcli storcli32
		newexe storcli64 storcli
	fi

	dosym "${MY_STORCLI_BASEDIR}"/storcli /usr/sbin/storcli

	dodoc "${DOCS[@]}"

	pax-mark m "${D%/}${MY_STORCLI_BASEDIR}"/storcli
}
