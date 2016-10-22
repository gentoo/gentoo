# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python{2_{6,7},3_{3,4,5}} )

inherit distutils-r1

DESCRIPTION="django CMS plugins for bootstrap3 markup"
HOMEPAGE="http://www.django-cms.org/en/addons/aldryn-bootstrap3/"
SRC_URI="https://github.com/aldryn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/django-cms-3.1
	>=dev-python/django-appconf-1.0.0
	>=dev-python/django-filer-0.9.11
	>=dev-python/django-durationfield-0.5.2
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools
"
