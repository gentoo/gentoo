# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyinsane/pyinsane-1.3.8.ebuild,v 1.2 2014/11/27 14:55:37 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python implementation of the Sane API and abstration layer"
HOMEPAGE="https://github.com/jflesch/pyinsane"
SRC_URI="https://github.com/jflesch/pyinsane/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-gfx/sane-backends
	virtual/python-imaging"
DEPEND="${RDEPEND}"
