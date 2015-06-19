# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sudsds/sudsds-1.0.1-r1.ebuild,v 1.6 2015/04/08 08:05:10 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Lightweight SOAP client - Czech NIC labs fork"
HOMEPAGE="https://labs.nic.cz/page/969/"
SRC_URI="http://www.nic.cz/public_media/datove_schranky/releases/src/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
