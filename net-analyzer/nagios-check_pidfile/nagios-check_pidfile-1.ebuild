# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="A nagios plugin for checking daemons via pidfiles"
HOMEPAGE="https://github.com/hollow/check_pidfile"
SRC_URI="https://github.com/hollow/check_pidfile/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-analyzer/nagios-plugins-1.4.13-r1"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/check_pidfile-${PV}

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
}
