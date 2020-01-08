# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( pypy3 python{2_7,3_{6,7}} )

inherit distutils-r1

DESCRIPTION="Sphinx theme integrates the Bootstrap CSS / JavaScript framework"
HOMEPAGE="https://ryan-roemer.github.io/sphinx-bootstrap-theme/README.html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""
