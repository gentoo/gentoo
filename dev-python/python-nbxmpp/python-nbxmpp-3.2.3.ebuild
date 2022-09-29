# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="Python library to use Jabber/XMPP networks in a non-blocking way"
HOMEPAGE="
	https://dev.gajim.org/gajim/python-nbxmpp/
	https://pypi.org/project/nbxmpp/
"
SRC_URI="
	https://dev.gajim.org/gajim/python-nbxmpp/-/archive/${PV}/${P}.tar.bz2
"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	dev-libs/gobject-introspection
	net-libs/libsoup[introspection]
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/precis-i18n[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
