# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Server's configuration management and monitoring tool"
HOMEPAGE="http://sourceforge.net/projects/pmsvn/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="net-analyzer/nrpe
	>=app-shells/bash-4.0_p37
	>=sys-apps/sed-4.2
	>=dev-vcs/subversion-1.6.9"

S="${WORKDIR}"

src_prepare() {
	# move configuration file from /etc/${PN}.conf to /etc/${PN}/${PN}.conf
	sed -i "/etc\/${PN}.conf/s:etc/${PN}.conf:etc/${PN}/${PN}.conf:" ${PN} \
		|| die "failed to fix path for configuration file"
}

src_install() {
	dosbin "${PN}"
	dodoc README
	insinto /etc/${PN}/
	doins pmsvn.conf.sample
}

pkg_postinst(){
	elog
	elog "A configuration file sample is located at /etc/pmsvn/pmsvn.conf.sample."
	elog
}
