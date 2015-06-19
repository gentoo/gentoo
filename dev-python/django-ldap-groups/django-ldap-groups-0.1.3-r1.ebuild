# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-ldap-groups/django-ldap-groups-0.1.3-r1.ebuild,v 1.4 2015/04/08 08:05:29 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A reusable application for the Django web framework"
HOMEPAGE="http://code.google.com/p/django-ldap-groups"
SRC_URI="http://django-ldap-groups.googlecode.com/files/${P}.tar.gz"

KEYWORDS="amd64 x86"
IUSE=""
LICENSE="BSD"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND} dev-python/django[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( ldap_groups/README )
