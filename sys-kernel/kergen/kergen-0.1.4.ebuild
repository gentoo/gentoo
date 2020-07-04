# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Kernel config generator"
HOMEPAGE="https://github.com/nichoski/kergen"
SRC_URI="http://whatishacking.org/${PN}/downloads/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
