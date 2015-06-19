# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pretty-yaml/pretty-yaml-14.05.7.ebuild,v 1.2 2014/06/30 04:04:00 floppym Exp $

EAPI=5
PYTHON_COMPAT=(python{2_7,3_{3,4}})

inherit distutils-r1

MY_PN="${PN//retty-}"
DESCRIPTION="PyYAML-based module to produce pretty and readable YAML-serialized data"
HOMEPAGE="https://github.com/mk-fg/pretty-yaml"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_PN}-${PV}"
