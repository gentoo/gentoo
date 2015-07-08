# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/micawber/micawber-0.3.2.ebuild,v 1.1 2015/07/08 10:07:31 yngwin Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit distutils-r1

DESCRIPTION="A small library for extracting rich content from urls"
HOMEPAGE="https://github.com/coleifer/micawber/"
SRC_URI="https://github.com/coleifer/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
