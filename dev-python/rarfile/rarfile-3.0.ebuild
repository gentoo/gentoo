# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit distutils-r1

DESCRIPTION="Module for RAR archive reading"
HOMEPAGE="https://github.com/markokr/rarfile"
SRC_URI="mirror://pypi/r/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+compressed"

RDEPEND="${DEPEND}
	compressed? ( || ( app-arch/unrar app-arch/rar ) )"
