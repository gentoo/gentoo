# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="A Prometheus metrics exporter for Buildbot"
HOMEPAGE="https://github.com/claws/buildbot-prometheus"
SRC_URI="https://github.com/claws/buildbot-prometheus/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/prometheus_client[${PYTHON_USEDEP}]
	>=dev-util/buildbot-0.9.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${RDEPEND}"

PATCHES=(
	"${FILESDIR}/buildbot-prometheus-17.7.2-Migrate-duration-calculations-to-buildbot-09.patch"
)

python_prepare_all() {
	sed -i -e "/^install_reqs.*$/d" -e "/^from pip.*$/d" -e "s/requires = .*/requires = ['buildbot', 'prometheus_client']/" setup.py || die
	distutils-r1_python_prepare_all
}

pkg_postinst() {
	einfo "This version has been patched to be compatible with the current buildbot releases >=0.9.0"
	einfo "For older buildbot-0.8* releases, please use dev-python/buildbot-prometheus-17.7.2-r1 version"
}
