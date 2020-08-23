# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="A tool for signing and email all UIDs on a set of PGP keys"
HOMEPAGE="https://www.phildev.net/pius/ https://github.com/jaymzh/pius"
SRC_URI="https://github.com/jaymzh/pius/releases/download/v${PV}/pius-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=">=app-crypt/gnupg-2.0.0"
RDEPEND="${DEPEND}
	dev-lang/perl"

python_test() {
	${EPYTHON} -m unittest discover -s test/* -v || die
}
