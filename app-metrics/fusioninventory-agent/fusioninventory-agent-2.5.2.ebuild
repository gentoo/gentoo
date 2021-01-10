# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module systemd

DESCRIPTION="The FusionInventory agent is a generic management agent"
HOMEPAGE="http://fusioninventory.org/"
SRC_URI="https://github.com/fusioninventory/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-perl/libwww-perl
	dev-perl/File-Which
	dev-perl/Net-IP
	dev-perl/Text-Template
	dev-perl/UNIVERSAL-require
	dev-perl/XML-TreePP
	dev-perl/XML-XPath
	virtual/perl-IO-Compress
	virtual/perl-threads
	dev-perl/HTTP-Daemon
	dev-perl/IO-Socket-SSL
	dev-perl/LWP-Protocol-https
	dev-perl/Proc-Daemon
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-perl/Module-Install
	dev-perl/File-Copy-Recursive
	app-portage/gentoolkit
"

PATCHES=( "${FILESDIR}/${P}-dirs.patch" )

src_prepare() {
	# gentoo has ip under /bin/ip and ifconfig under /bin/ifconfig
	sed \
		-e "s:/sbin/ifconfig:/bin/ifconfig:g" \
		-e "s:/sbin/ip:/bin/ip:g" \
		-i lib/FusionInventory/Agent/Task/Inventory/Linux/Networks.pm \
		-i lib/FusionInventory/Agent/Tools/Linux.pm || die
	default
}

src_install() {
	default
	systemd_dounit contrib/unix/fusioninventory-agent.service
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	keepdir /var/lib/fusioninventory
}
