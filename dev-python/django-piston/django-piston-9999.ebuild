# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 mercurial

DESCRIPTION="A mini-framework for Django for creating RESTful APIs"
HOMEPAGE="https://bitbucket.org/jespern/django-piston/wiki/Home"
EHG_REPO_URI="https://bitbucket.org/jespern/django-piston/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-python/django[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}"
