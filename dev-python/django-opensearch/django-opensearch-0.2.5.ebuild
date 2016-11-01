# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="A django reusable application to handle opensearch.xml"
HOMEPAGE="https://github.com/vint21h/django-opensearch"
SRC_URI="https://github.com/vint21h/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/django-1.7[${PYTHON_USEDEP}]"
