# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pylibpcap/pylibpcap-0.6.4-r1.ebuild,v 1.1 2015/01/03 09:45:43 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python interface to libpcap"
HOMEPAGE="http://sourceforge.net/projects/pylibpcap/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~x86"
IUSE="examples"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
