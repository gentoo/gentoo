# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pax-utils rpm versionator

MY_PV=$(replace_version_separator 2 '-')

DESCRIPTION="HPE Smart Storage Administrator (HPE SSA) CLI (HPSSACLI, formerly HPACUCLI)"
HOMEPAGE="https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX_5530b3f5b38b4e0781e6bf9c74"
SRC_URI="https://downloads.linux.hpe.com/SDR/repo/spp/2017.10.1/packages/ssacli-${MY_PV}.x86_64.rpm"

LICENSE="hpe"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

DEPEND=""
RDEPEND="elibc_glibc? ( >sys-libs/glibc-2.14 )
	>=sys-libs/libunwind-0.99
	>=sys-process/procps-3.3.6"

DOCS=( license.txt readme.txt )

MY_HPSSACLI_BASEDIR="/opt/hp/hpssacli"

QA_PREBUILT="${MY_HPSSACLI_BASEDIR:1}/hpssa*.bin"
QA_EXECSTACK="${MY_HPSSACLI_BASEDIR:1}/hpssa*.bin"

src_unpack() {
	rpm_src_unpack

	mkdir "${S}" || die "Failed to create '${S}'"
}

src_prepare() {
	default

	# Create a clean $S
	mv "${WORKDIR}"/opt/smartstorageadmin/ssacli/bin/ssa* "${S}" || die "Failed to to copy 'ssa*' related files"
	mv "${S}"/ssacli "${S}"/hpssacli || die "Renaming ssacli failed!"
	mv "${S}"/ssascripting "${S}"/hpssascripting || die "Renaming ssascripting failed!"
	mv "${S}"/ssacli.license "${S}"/license.txt || die "Renaming ssacli.license failed!"
	mv "${S}"/ssacli*.txt "${S}"/readme.txt || die "Renaming ssacli*.txt failed!"
	rm -rf "${WORKDIR}"/opt || die "Failed to cleanup '${WORKDIR}/opt'"
	rm -rf "${WORKDIR}"/usr || die "Failed to cleanup '${WORKDIR}/usr'"
}

src_install() {
	newsbin "${FILESDIR}"/"${PN}-wrapper" ${PN}
	dosym ${PN} /usr/sbin/hpssascripting

	exeinto "${MY_HPSSACLI_BASEDIR}"
	for bin in "${S}"/hpssa{cli,scripting}; do
		local basename=$(basename "${bin}")
		newexe "${bin}" ${basename}.bin
	done

	dodoc "${DOCS[@]}"

	pax-mark m "${D%/}${HPSSACLI_BASEDIR}"/*.bin
}
