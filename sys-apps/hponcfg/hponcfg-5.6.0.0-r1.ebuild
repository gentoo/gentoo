# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils rpm

MY_PV=$(ver_rs 3 '-')

DESCRIPTION="HP Lights-Out Online Configuration Utility (HPONCFG)"
HOMEPAGE="https://support.hpe.com/hpesc/public/docDisplay?docId=emr_na-a00007610en_us"
SRC_URI="https://downloads.linux.hpe.com/SDR/repo/spp/RHEL/7/x86_64/current/${PN}-${MY_PV}.x86_64.rpm"
S="${WORKDIR}"

LICENSE="hpe"
SLOT="0"
KEYWORDS="-* amd64"
RESTRICT="mirror bindist"

RDEPEND="elibc_glibc? ( >sys-libs/glibc-2.14 )"

QA_PRESTRIPPED="usr/sbin/hponcfg usr/lib*/libcp*"
QA_PREBUILT="${QA_PRESTRIPPED}"

src_install() {
	dosbin sbin/hponcfg

	# When bumping, verify SONAME (scanelf -S libhponcfg64.so)!
	newlib.so "${S}"/usr/lib64/libhponcfg64.so libcpqci64.so.3
	dosym libcpqci64.so.3 /usr/$(get_libdir)/libhponcfg64.so

	dodoc "${S}"/usr/share/doc/hponcfg/*

	pax-mark m "${D}"/usr/sbin/hponcfg
}
