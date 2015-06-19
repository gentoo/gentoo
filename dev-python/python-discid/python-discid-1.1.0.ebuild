# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-discid/python-discid-1.1.0.ebuild,v 1.1 2015/03/15 10:10:52 yngwin Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit distutils-r1

DESCRIPTION="Python bindings for libdiscid"
HOMEPAGE="https://github.com/JonnyJD/python-discid"
SRC_URI="https://github.com/JonnyJD/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libdiscid-0.2.2
	${PYTHON_DEPS}"
RDEPEND="${DEPEND}"
