# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/termpkg/termpkg-3.3.9.1-r1.ebuild,v 1.1 2012/07/17 19:50:15 sbriesen Exp $

EAPI=4

inherit base versionator

MY_PV=$(get_version_component_range 1-2)
MY_PF=$(replace_version_separator 2 '-')

DESCRIPTION="Termpkg, the Poor Man's Terminal Server"
HOMEPAGE="http://www.linuxlots.com/~termpkg/"
SRC_URI="mirror://debian/pool/main/t/termpkg/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/t/termpkg/${PN}_${MY_PF}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+uucp"

DEPEND="sys-devel/flex"
RDEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"

DOCS=(
	"README"
	"CHANGES"
	"termpkg.lsm"
)

PATCHES=(
	# debian patches
	"${WORKDIR}/${PN}_${MY_PF}.diff"

	# gentoo patches
	"${FILESDIR}/${P}-gcc43.diff"

	# iaxmodem patches
	"${FILESDIR}/${PN}-${MY_PV}-ttydforfax.diff"
)

src_configure() {
	./configure LINUX $(use uucp && echo UUCP_LOCKING)
}

src_compile() {
	emake -C linux CC=$(tc-getCC) LIBS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	local X
	base_src_install_docs
	dobin linux/bin/termnet
	dosbin linux/bin/{termnetd,ttyd}
	newdoc debian/changelog ChangeLog.debian
	doman doc/*.1
	insinto /etc
	newins debian/termnetd.conf termnetd.conf.dist
	for X in termnetd ttyd; do
		newinitd "${FILESDIR}/${X}.initd" "${X}"
		newconfd "${FILESDIR}/${X}.confd" "${X}"
	done
}
