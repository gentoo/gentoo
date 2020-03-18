# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

DESCRIPTION="Last File Manager is a powerful file manager for the console"
HOMEPAGE="https://inigo.katxi.org/devel/lfm/"
SRC_URI="https://inigo.katxi.org/devel/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
