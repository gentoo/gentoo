# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# This is now py3 compatible however is only re'd for Djblets which is py2.7 compat only
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN/-/_}
MY_P=${MY_PN}-${PV}
RELEASE="0.7"

DESCRIPTION="A Django application that will run cron jobs for other django apps"
HOMEPAGE="https://code.google.com/p/django-evolution/ https://pypi.python.org/pypi/django_evolution/"
SRC_URI="http://downloads.reviewboard.org/releases/${PN}/${RELEASE}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/django[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
		dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${MY_P}
DOCS=( NEWS docs/{evolution.txt,faq.txt} )

python_test() {
	# Draws 1 trivial fail under django django-1.4.x
	einfo "The testsuite is not compatible with >=django-1.7"
	"${PYTHON}" tests/runtests.py || die
}
