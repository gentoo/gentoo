# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/shoutcast-search/shoutcast-search-0.3.1.ebuild,v 1.2 2011/03/13 16:02:27 hwoarang Exp $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

PYTHON_MODNAME="shoutcast_search"

inherit distutils

DESCRIPTION="A command-line tool for searching SHOUTcast stations"
HOMEPAGE="http://www.k2h.se/code/shoutcast-search.html"
SRC_URI="http://github.com/halhen/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools"

S=${WORKDIR}/halhen-${PN}-fc6b3aa

src_prepare() {
	python_convert_shebangs 2 ${PN}
	distutils_src_prepare
}

src_install() {
	distutils_src_install
	dobin ${PN} || die
	doman ${PN}.1 || die
	dodoc documentation.md || die
}
