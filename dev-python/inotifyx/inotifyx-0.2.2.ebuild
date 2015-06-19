# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/inotifyx/inotifyx-0.2.2.ebuild,v 1.1 2015/06/01 04:43:16 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Python bindings to the Linux inotify file system event monitoring API"
HOMEPAGE="http://www.alittletooquiet.net/software/inotifyx/"
SRC_URI="http://launchpad.net/inotifyx/dev/v${PV}/+download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND=""
RDEPEND=""

python_prepare_all() {
	use test && DISTUTILS_NO_PARALLEL_BUILD=1
}

python_test() {
	"${PYTHON}" setup.py build -b "build-${EPYTHON}" test || die "Tests failed under ${EPYTHON}"
}
