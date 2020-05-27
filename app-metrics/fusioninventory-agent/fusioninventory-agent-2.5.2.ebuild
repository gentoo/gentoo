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
	virtual/perl-IO-Compress
	dev-perl/HTTP-Daemon
	dev-perl/IO-Socket-SSL
	dev-perl/LWP-Protocol-https
	dev-perl/Proc-Daemon
	"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-perl/Module-Install
	"
PATCHES=( "${FILESDIR}/${P}-dirs.patch" )

src_install() {
	default
	systemd_dounit contrib/unix/fusioninventory-agent.service
	doinitd "${FILESDIR}/${PN}.initd"
	doconfd "${FILESDIR}/${PN}.confd"
	keepdir /var/lib/fusioninventory
}
