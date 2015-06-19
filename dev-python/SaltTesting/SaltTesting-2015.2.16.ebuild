# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/SaltTesting/SaltTesting-2015.2.16.ebuild,v 1.1 2015/02/17 19:05:50 chutzpah Exp $

EAPI=5

PYTHON_COMPAT=(python2_7)

inherit eutils distutils-r1

DESCRIPTION="Required testing tools needed in the several Salt Stack projects"
HOMEPAGE="http://saltstack.org/"

if [[ ${PV} == 9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/saltstack/salt-testing.git"
	EGIT_BRANCH="develop"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"

DEPEND=">=dev-python/requests-2.4.2"
RDEPEND="${DEPEND}"
