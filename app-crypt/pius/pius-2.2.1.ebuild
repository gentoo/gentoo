# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A tool for signing and email all UIDs on a set of PGP keys"
HOMEPAGE="https://www.phildev.net/pius/"
SRC_URI="https://github.com/jaymzh/pius/releases/download/v${PV}/pius-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-crypt/gnupg-2.0.0"
RDEPEND="${DEPEND}
	dev-lang/perl"
