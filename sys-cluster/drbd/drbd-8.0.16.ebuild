# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils versionator

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

MY_PV="${PV/_/}"
MY_MAJ_PV="$(get_version_component_range 1-2 ${PV})"
DESCRIPTION="mirror/replicate block-devices across a network-connection"
SRC_URI="http://oss.linbit.com/drbd/${MY_MAJ_PV}/${PN}-${MY_PV}.tar.gz"
HOMEPAGE="http://www.drbd.org"

IUSE=""

DEPEND=""
RDEPEND=""
PDEPEND="~sys-cluster/drbd-kernel-${PV}"

SLOT="0"

S="${WORKDIR}/${PN}-${MY_PV}"

src_compile() {
	emake -j1 tools || die "compile problem"
}

src_install() {
	emake PREFIX="${D}" install-tools || die "install problem"

	# gentoo-ish init-script
	newinitd "${FILESDIR}"/${PN}-8.0.rc ${PN} || die

	# docs
	dodoc README ChangeLog ROADMAP

	# we put drbd.conf into docs
	# it doesnt make sense to install a default conf in /etc
	# put it to the docs
	rm -f "${D}"/etc/drbd.conf
	dodoc scripts/drbd.conf || die
}

pkg_postinst() {
	einfo ""
	einfo "Please copy and gunzip the configuration file"
	einfo "drbd.conf from /usr/share/doc/${PF} to /etc"
	einfo "and edit it to your needs. Helpful commands:"
	einfo "man 5 drbd.conf"
	einfo "man 8 drbdsetup"
	einfo "man 8 drbdadm"
	einfo "man 8 drbddisk"
	einfo "man 8 drbdmeta"
	einfo ""
}
