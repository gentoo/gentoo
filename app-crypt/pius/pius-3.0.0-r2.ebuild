# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

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

PATCHES=(
	"${FILESDIR}/${P}-Fix-typos-132.patch"
	"${FILESDIR}/${P}-pius-keyring-mgr-Fix-constants-134.patch"
	"${FILESDIR}/${P}-Fix-typo-in-readme-135.patch"
	"${FILESDIR}/${P}-Minor-fixes-for-pius-report-137.patch"
)

python_test() {
	${EPYTHON} -m unittest discover -s test/* -v || die
}
