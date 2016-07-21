# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit bash-completion-r1

DESCRIPTION="OpenVZ stats collection daemon"
HOMEPAGE="http://stats.openvz.org"
SRC_URI="http://download.openvz.org/utils/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	virtual/cron
	sys-process/cronbase
	net-misc/curl[ssl]
	app-portage/gentoolkit
	sys-cluster/vzctl
	"
RDEPEND="${DEPEND}"

src_install() {
	emake install install-cronjob DESTDIR="${D}"
	dodoc README
	newbashcomp bash_completion.sh vzstats
}
