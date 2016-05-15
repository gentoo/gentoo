# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

HASH="a8f548c2700dbe3dadfe048fa2491c7b77cf7846"

DESCRIPTION="Python bindings for libiscsi"
HOMEPAGE="https://github.com/sahlberg/libiscsi-python"
SRC_URI="https://github.com/sahlberg/libiscsi-python/archive/${HASH}.zip -> ${P}.zip"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="net-libs/libiscsi"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}"/${PN}-${HASH}
