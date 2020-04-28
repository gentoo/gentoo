# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit pax-utils

# Upstream is still using strange version numbers
MY_PV="007.1316.0000.0000"

DESCRIPTION="MegaRAID StorCLI (successor of the MegaCLI)"
HOMEPAGE="https://www.broadcom.com/support/download-search?dk=storcli"
SRC_URI="https://docs.broadcom.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/${MY_PV}_Unified_StorCLI.zip -> ${P}.zip"

LICENSE="Avago LSI BSD"
SLOT="0/7.13"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

MY_STORCLI_BASEDIR="/opt/lsi/storcli"

QA_PRESTRIPPED="${MY_STORCLI_BASEDIR:1}/storcli
	${MY_STORCLI_BASEDIR:1}/storcli32"
QA_PREBUILT=${QA_PRESTRIPPED}

src_unpack() {
	mkdir srcfiles || die
	pushd srcfiles &>/dev/null || die
	default
	mv Unified_storcli_all_os/Ubuntu/storcli_*.deb "${WORKDIR}" || die "Failed to move storcli_*.deb"
	popd &>/dev/null || die

	rm -rf srcfiles || die

	# Unpack Ubuntu package which will be our $S content
	unpack "${WORKDIR}"/storcli_*.deb
	rm -f storcli_*.deb || die "Failed to cleanup storcli_*.deb package"
	unpack "${WORKDIR}"/data.tar.xz

	mkdir "${S}" || die "Failed to create '${S}'"
}

src_prepare() {
	default

	# Create clean $S
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

	pax-mark m "${D}${MY_STORCLI_BASEDIR}"/storcli
}
