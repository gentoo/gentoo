# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="DRY Django forms"
HOMEPAGE="https://github.com/django-crispy-forms/django-crispy-forms"
SRC_URI="https://github.com/django-crispy-forms/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test" #Not working

RDEPEND="dev-python/django[${PYTHON_USEDEP}]"
