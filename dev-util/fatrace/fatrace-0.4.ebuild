# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/fatrace/fatrace-0.4.ebuild,v 1.3 2012/05/23 20:20:37 xmw Exp $

EAPI=4
PYTHON_DEPEND="powertop? *"

inherit linux-info python toolchain-funcs

DESCRIPTION="report file access events from all running processes"
HOMEPAGE="https://launchpad.net/fatrace"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="powertop"

RDEPEND="powertop? ( =sys-power/powertop-1.13 )"
DEPEND=""

CONFIG_CHECK="~FANOTIFY"

pkg_setup() {
	linux-info_pkg_setup
	python_pkg_setup
}

src_prepare() {
	if use powertop ; then
		sed -e "s/powertop-1.13/powertop/g" \
			-i power-usage-report || die
	fi

	tc-export CC
}

src_install() {
	dosbin fatrace
	use powertop && dosbin power-usage-report

	doman fatrace.1
	dodoc NEWS
}
