# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="TinyMCE integration for Django"
HOMEPAGE="https://github.com/aljosa/django-tinymce"
SRC_URI="https://github.com/aljosa/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-release-${PV}"
