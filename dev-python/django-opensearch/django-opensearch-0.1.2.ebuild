# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-opensearch/django-opensearch-0.1.2.ebuild,v 1.3 2015/07/20 04:51:46 ercpe Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A django reusable application to handle opensearch.xml"
HOMEPAGE="https://github.com/vint21h/django-opensearch"
SRC_URI="https://github.com/vint21h/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="<dev-python/django-1.7[${PYTHON_USEDEP}]"
