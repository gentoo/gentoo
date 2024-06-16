# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_P=python-nbxmpp-${PV}
DESCRIPTION="Python library to use Jabber/XMPP networks in a non-blocking way"
HOMEPAGE="
	https://dev.gajim.org/gajim/python-nbxmpp/
	https://pypi.org/project/nbxmpp/
"
SRC_URI="
	https://dev.gajim.org/gajim/python-nbxmpp/-/archive/${PV}/${MY_P}.tar.bz2
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	dev-libs/gobject-introspection
	net-libs/libsoup:3.0[introspection]
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/precis-i18n-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.42[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
