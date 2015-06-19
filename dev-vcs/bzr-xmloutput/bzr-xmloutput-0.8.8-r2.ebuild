# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/bzr-xmloutput/bzr-xmloutput-0.8.8-r2.ebuild,v 1.1 2015/03/10 14:40:42 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A Bazaar plugin that provides a option to generate XML output forbuiltin commands."
HOMEPAGE="http://bazaar-vcs.org/XMLOutput"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-vcs/bzr[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${P}_remove-relative-imports.patch )

pkg_setup() {
	python-single-r1_pkg_setup
}
