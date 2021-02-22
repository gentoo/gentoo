# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

MY_P=python-nbxmpp-nbxmpp-${PV}
DESCRIPTION="Python library to use Jabber/XMPP networks in a non-blocking way"
HOMEPAGE="https://dev.gajim.org/gajim/python-nbxmpp/"
SRC_URI="https://dev.gajim.org/gajim/python-nbxmpp/-/archive/nbxmpp-${PV}/${MY_P}.tar.bz2"
S=${WORKDIR}/${MY_P}

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

RDEPEND="
	dev-libs/gobject-introspection
	net-libs/libsoup[introspection]
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/precis-i18n[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]"

distutils_enable_tests unittest
