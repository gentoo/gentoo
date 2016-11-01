# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1

DESCRIPTION="File plugin for django CMS"
HOMEPAGE="https://github.com/divio/djangocms-attributes-field"
SRC_URI="https://github.com/divio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	dev-python/setuptools
"

src_prepare() {
	sed -i 's/find_packages()/find_packages(exclude=["tests"])/g' "${S}/setup.py"
	eapply_user
}
