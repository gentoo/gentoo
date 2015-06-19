# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/obfsproxy/obfsproxy-0.2.11.ebuild,v 1.1 2014/07/17 11:19:16 blueness Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="An obfuscating proxy using Tor's pluggable transport protocol"
HOMEPAGE="https://www.torproject.org/projects/obfsproxy.html"
SRC_URI="mirror://pypi/o/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( ChangeLog INSTALL README TODO doc/HOWTO.txt )

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND=">=dev-python/pyptlib-0.0.6[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.6-r2[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PN}-0.2.9-remove-argparse.patch )
