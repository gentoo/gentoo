# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pax-utils rpm versionator

MY_PV=$(replace_version_separator 3 '-')

DESCRIPTION="HP Lights-Out Online Configuration Utility (HPONCFG)"
HOMEPAGE="http://h20564.www2.hpe.com/hpsc/swd/public/detail?swItemId=MTX_5ab6295f49964f16a699064f29"
SRC_URI="amd64? ( https://downloads.linux.hpe.com/SDR/repo/spp/RHEL/7/x86_64/current/${PN}-${MY_PV}.x86_64.rpm )"

LICENSE="hpe"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

DEPEND=""
RDEPEND="elibc_glibc? ( >sys-libs/glibc-2.14 )"

S="${WORKDIR}"

QA_PRESTRIPPED="/usr/sbin/hponcfg /usr/li.*/libcpqc.*"
QA_PREBUILT="/usr/sbin/hponcfg"

src_install() {
	dosbin sbin/hponcfg

	# When bumping, verify SONAME (scanelf -S libhponcfg64.so)!
	newlib.so "${S}"/usr/lib64/libhponcfg64.so libcpqci64.so.3
	dosym libcpqci64.so.3 /usr/$(get_libdir)/libhponcfg64.so

	dodoc "${S}"/usr/share/doc/hponcfg/*

	pax-mark m "${D}"usr/sbin/hponcfg
}
