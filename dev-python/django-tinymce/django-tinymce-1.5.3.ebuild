# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-tinymce/django-tinymce-1.5.3.ebuild,v 1.1 2015/05/30 13:05:21 maksbotan Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

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
