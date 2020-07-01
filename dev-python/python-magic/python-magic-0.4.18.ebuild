# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python{2_7,3_{6..9}} )

inherit distutils-r1

DESCRIPTION="Access the libmagic file type identification library"
HOMEPAGE="https://github.com/ahupp/python-magic"
# https://github.com/ahupp/python-magic/pull/178
SRC_URI="https://github.com/ahupp/python-magic/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-apps/file[-python]"
BDEPEND="
	test? ( sys-apps/file )
"

python_test() {
	local -x LC_ALL=en_US.UTF-8
	"${EPYTHON}" test/test.py -v || die "Tests fail with ${EPYTHON}"
}
