# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-discover-runner/django-discover-runner-0.4.ebuild,v 1.2 2014/06/06 06:48:16 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="A Django test runner based on unittest2's test discovery"
HOMEPAGE="https://github.com/jezdez/django-discover-runner
	https://pypi.python.org/pypi/django-discover-runner"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/django[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
