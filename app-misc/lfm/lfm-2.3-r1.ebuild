# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1 eutils

DESCRIPTION="Last File Manager is a powerful file manager for the console"
HOMEPAGE="https://inigo.katxi.org/devel/lfm/"
SRC_URI="https://inigo.katxi.org/devel/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-doc.patch
}
