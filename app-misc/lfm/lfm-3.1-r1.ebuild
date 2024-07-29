# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
PYTHON_REQ_USE="ncurses"
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Last File Manager is a powerful file manager for the console"
HOMEPAGE="https://inigo.katxi.org/devel/lfm/"
SRC_URI="https://inigo.katxi.org/devel/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/lfm-3.1-dont-error-on-wheel.patch )

src_prepare() {
	default
	sed -e '/data_files/d' -i setup.py || die
}

src_install() {
	distutils-r1_src_install
	doman ${PN}.1
}
