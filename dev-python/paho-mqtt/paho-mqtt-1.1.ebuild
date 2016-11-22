# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1

DESCRIPTION="A client class with support for both MQTT v3.1 and v3.1.1 on Python 2.7 or 3.x."
HOMEPAGE="https://www.eclipse.org/paho/clients/python/"
SRC_URI="https://github.com/eclipse/paho.mqtt.python/archive/${PV}.zip -> ${P}.zip"
LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/paho.mqtt.python-${PV}"
