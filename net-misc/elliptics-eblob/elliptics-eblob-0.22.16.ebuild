# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 flag-o-matic cmake-utils

DESCRIPTION="The elliptics network - eblob backend"
HOMEPAGE="http://www.ioremap.net/projects/elliptics"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="python"
RDEPEND="
	app-arch/snappy
	dev-libs/openssl
	dev-libs/boost[python]
	dev-libs/handystats"
DEPEND="${RDEPEND}"

MY_PN="eblob"
SRC_URI="https://github.com/reverbrain/eblob/archive/v${PV}.zip -> ${P}.zip"

S=${WORKDIR}/${MY_PN}-${PV}

src_configure(){
	# 'checking trying to link with boost::python... no' due '-Wl,--as-needed'
	use python && filter-ldflags -Wl,--as-needed
	cmake-utils_src_configure
}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_install() {
	cd "${BUILD_DIR}" && emake DESTDIR="${D}" install
	cd "${S}"
}
