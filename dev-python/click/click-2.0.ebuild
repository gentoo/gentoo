# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/click/click-2.0.ebuild,v 1.3 2014/08/06 05:48:12 idella4 Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="A Python package for creating beautiful command line interfaces"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
HOMEPAGE="http://click.pocoo.org/ http://pypi.python.org/pypi/click"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# FIXME: tests docs and examples aren't being shipped with releases.
#        Asked upstream to fix this. Avoided using github snapshots for now. (rafaelmartins)
IUSE=""

RDEPEND="dev-python/colorama"
DEPEND="${RDEPEND}"
