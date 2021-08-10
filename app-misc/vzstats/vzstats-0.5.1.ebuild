# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

DESCRIPTION="OpenVZ stats collection daemon"
HOMEPAGE="http://stats.openvz.org"
SRC_URI="http://download.openvz.org/utils/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-process/cronbase"
RDEPEND="
	${DEPEND}
	app-portage/gentoolkit
	net-misc/curl[ssl]
	sys-cluster/vzctl
"

src_install() {
	emake install install-cronjob DESTDIR="${ED}"
	dodoc README
	newbashcomp bash_completion.sh vzstats
}
