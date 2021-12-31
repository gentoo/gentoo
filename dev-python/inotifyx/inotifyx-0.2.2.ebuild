# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Python bindings to the Linux inotify file system event monitoring API"
HOMEPAGE="http://www.alittletooquiet.net/software/inotifyx/"
SRC_URI="https://launchpad.net/inotifyx/dev/v${PV}/+download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

python_test() {
	esetup.py test
}
