# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Collectd plugin to gather statistics from RabbitMQ"
HOMEPAGE="https://pypi.python.org/pypi/collectd-rabbitmq"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="amd64"

LICENSE="Apache-2.0"
SLOT="0"

DEPEND="
	net-misc/rabbitmq-server
	app-metrics/collectd[collectd_plugins_python]
	dev-python/setuptools[${PYTHON_USEDEP}]"
