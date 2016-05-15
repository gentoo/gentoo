# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1 eutils linux-info

MYPN=Glances
MYP=${MYPN}-${PV}

DESCRIPTION="CLI curses based monitoring tool"
HOMEPAGE="https://github.com/nicolargo/glances"
SRC_URI="mirror://pypi/${MYPN:0:1}/${MYPN}/${MYP}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
# There is another optional extra batinfo, absent from portage
RDEPEND="${DEPEND}
	>=dev-python/psutil-2.0.0[${PYTHON_USEDEP}]"

CONFIG_CHECK="~TASK_IO_ACCOUNTING ~TASK_DELAY_ACCT ~TASKSTATS"

S="${WORKDIR}/${MYP}"

# Remove duplicate entries of a prebuilt doc build and
# ensure install of the file glances.conf in /etc/${PN}
PATCHES=( "${FILESDIR}"/2.4.2-setup-data.patch )

pkg_setup() {
	linux-info_pkg_setup
}

python_install_all() {
	# add an intended file from original data set from setup.py to DOCS
	local DOCS=( README.rst conf/glances.conf )
	# setup for pre-built html docs in setup.py
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "Web server mode" dev-python/bottle
	# https://bitbucket.org/gleb_zhulik/py3sensors
	#optfeature "Hardware monitoring support" dev-python/py3sensors
	optfeature "Monitor hard drive temperatures" app-admin/hddtemp
	optfeature "Battery monitoring support" dev-python/batinfo
	optfeature "RAID support" dev-python/pymdstat
	optfeature "SNMP support" dev-python/pysnmp
	optfeature "Autodiscover mode" dev-python/zeroconf
	optfeature "IP plugin" dev-python/netifaces
	optfeature "InfluxDB export module" dev-python/influxdb
	optfeature "StatsD export module" dev-python/statsd
	optfeature "Action script feature" dev-python/pystache
	optfeature "Docker monitoring support" dev-python/docker-py
	optfeature "Graphical / chart support" dev-python/matplotlib
	optfeature "RabbitMQ/ActiveMQ export module" dev-python/pika
	optfeature "Quicklook CPU info" dev-python/py-cpuinfo
}
