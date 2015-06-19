# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/fatrace/fatrace-0.9.ebuild,v 1.2 2015/04/08 17:54:02 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{3_3,3_4} )

inherit linux-info python-r1 toolchain-funcs

DESCRIPTION="report file access events from all running processes"
HOMEPAGE="https://launchpad.net/fatrace"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="powertop"

RDEPEND="powertop? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
REQUIRED_USE="powertop? ( ${PYTHON_REQUIRED_USE} )"

CONFIG_CHECK="~FANOTIFY"

src_prepare() {
	tc-export CC
}

src_install() {
	dosbin fatrace
	use powertop && dosbin power-usage-report

	doman fatrace.1
	dodoc NEWS
}
