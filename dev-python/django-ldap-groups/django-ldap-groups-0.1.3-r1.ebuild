# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A reusable application for the Django web framework"
HOMEPAGE="https://code.google.com/p/django-ldap-groups"
SRC_URI="https://django-ldap-groups.googlecode.com/files/${P}.tar.gz"

KEYWORDS="amd64 x86"
IUSE=""
LICENSE="BSD"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND} dev-python/django[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( ldap_groups/README )
