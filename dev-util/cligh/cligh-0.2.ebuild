# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cligh/cligh-0.2.ebuild,v 1.3 2015/04/08 17:54:02 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Command-line interface to GitHub"
HOMEPAGE="http://the-brannons.com/software/cligh.html"
SRC_URI="http://the-brannons.com/software/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/PyGithub[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
