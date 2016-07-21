# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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

pkg_setup() {
	linux-info_pkg_setup
}

python_prepare_all() {
	# Remove duplicate entries of a prebuilt doc build and
	# ensure install of the file glances.conf in /etc/${PN}
	sed -i -r '\|share/doc/glances|,/\),/ {
			s|.*share/doc/glances.*|("etc/glances", ["conf/glances.conf"]),|p
			d
		}' -- 'setup.py' || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	# add an intended file from original data set from setup.py to DOCS
	local DOCS=( README.rst conf/glances.conf )
	# setup for pre-built html docs in setup.py
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "Action script feature"				dev-python/pystache
	optfeature "Autodiscover mode"					dev-python/zeroconf
	optfeature "Battery monitoring support"			dev-python/batinfo
	optfeature "Docker monitoring support"			dev-python/docker-py
	optfeature "Graphical/chart support"			dev-python/matplotlib
	# https://bitbucket.org/gleb_zhulik/py3sensors
	# optfeature "Hardware monitoring support"		dev-python/py3sensors
	optfeature "IP plugin"							dev-python/netifaces
	optfeature "InfluxDB export module"				dev-python/influxdb
	optfeature "Hard drive temperature monitoring"	app-admin/hddtemp
	optfeature "Quicklook CPU info"					dev-python/py-cpuinfo
	optfeature "RAID support"						dev-python/pymdstat
	optfeature "RabbitMQ/ActiveMQ export module"	dev-python/pika
	# https://github.com/banjiewen/bernhard
	# optfeature "Riemann export"					dev-python/bernhard
	optfeature "SNMP support"						dev-python/pysnmp
	optfeature "StatsD export module"				dev-python/statsd
	optfeature "Web server mode"					dev-python/bottle
}
