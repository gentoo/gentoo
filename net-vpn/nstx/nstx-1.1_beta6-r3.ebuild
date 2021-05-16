# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs linux-info

MY_P="${PN}-${PV/_/-}"
DEBIAN_PV="5"
DEBIAN_A="${MY_P/-/_}-${DEBIAN_PV}.diff.gz"

DESCRIPTION="IP over DNS tunnel"
HOMEPAGE="http://dereference.de/nstx/"
SRC_URI="http://dereference.de/nstx/${MY_P}.tgz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${DEBIAN_A}"
S="${WORKDIR}/${MY_P}"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2+"
IUSE=""

DEPEND="virtual/os-headers"

CONFIG_CHECK="~TUN"

PATCHES=(
	"${WORKDIR}"/${DEBIAN_A%.gz}
	"${FILESDIR}"/${PN}-1.1_beta6_00-linux-tuntap.patch
	"${FILESDIR}"/${PN}-1.1_beta6_01-bind-interface-name.patch
	"${FILESDIR}"/${PN}-1.1_beta6_02-warn-on-frag.patch
	"${FILESDIR}"/${PN}-1.1_beta6_03-delete-dwrite.patch
	"${FILESDIR}"/${PN}-1.1_beta6_04-delete-werror.patch
	"${FILESDIR}"/${PN}-1.1_beta6_05-respect-ldflags.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dosbin nstxcd nstxd
	dodoc README Changelog
	doman *.8

	newinitd "${FILESDIR}"/nstxd.init nstxd
	newconfd "${FILESDIR}"/nstxd.conf nstxd
	newinitd "${FILESDIR}"/nstxcd.init nstxcd
	newconfd "${FILESDIR}"/nstxcd.conf nstxcd
}
