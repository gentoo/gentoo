# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

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

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="
	dev-libs/gobject-introspection
	net-libs/libsoup:2.4[introspection]
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/precis-i18n[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
