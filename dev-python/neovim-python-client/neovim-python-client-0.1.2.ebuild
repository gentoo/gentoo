# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
inherit distutils-r1

DESCRIPTION="Python client for Neovim"
HOMEPAGE="https://github.com/neovim/python-client"
SRC_URI="https://github.com/neovim/python-client/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"
REQUIRED_USE="gtk? ( python_targets_python2_7 )" # experimental gui only works with py2

DEPEND="
	>=dev-python/msgpack-0.4.0[${PYTHON_USEDEP}]
	virtual/python-greenlet[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/trollius[${PYTHON_USEDEP}]' python{2_7,3_3})
	gtk? (
		>=dev-python/click-3.0[${PYTHON_USEDEP}]
		dev-python/pygobject:2
		dev-python/pygtk:2
		x11-libs/gtk+:2[introspection]
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/python-client-${PV}"
