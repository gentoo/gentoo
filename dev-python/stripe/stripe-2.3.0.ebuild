# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
inherit distutils-r1

DESCRIPTION="Stripe python bindings"
HOMEPAGE="https://github.com/stripe/stripe-python"
SRC_URI="mirror://pypi/s/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/requests-0.8.8"
DEPEND="${RDEPEND}"

DOCS="LONG_DESCRIPTION.rst CHANGELOG.md README.md"
