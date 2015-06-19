# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/haveged/haveged-1.7a-r1.ebuild,v 1.3 2013/09/22 06:50:34 ago Exp $

EAPI=5

inherit autotools-utils systemd

DESCRIPTION="A simple entropy daemon using the HAVEGE algorithm"
HOMEPAGE="http://www.issihosts.com/haveged/"
SRC_URI="http://www.issihosts.com/haveged/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="!<sys-apps/openrc-0.11.8"

src_configure() {
	local myeconfargs=(
		--bindir=/usr/sbin
		--enable-nistest
		--disable-static
	)

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	# Install gentoo ones instead
	newinitd "${FILESDIR}"/haveged-init.d.3 haveged
	newconfd "${FILESDIR}"/haveged-conf.d haveged

	systemd_newunit "${FILESDIR}"/service.gentoo ${PN}.service
	insinto /etc
	doins "${FILESDIR}"/haveged.conf
}
