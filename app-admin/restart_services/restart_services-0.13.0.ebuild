# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Tool to manage OpenRC services that need to be restarted"
HOMEPAGE="https://dev.gentoo.org/~mschiff/restart_services/"
SRC_URI="https://dev.gentoo.org/~mschiff/src/${PN}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-admin/lib_users
	sys-apps/openrc
"

src_install() {
	dosbin restart_services
	doman restart_services.1
	keepdir /etc/restart_services.d
	insinto /etc
	doins restart_services.conf
	dodoc README CHANGES
}
