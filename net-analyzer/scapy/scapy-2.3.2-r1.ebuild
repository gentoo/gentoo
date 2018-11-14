# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1

DESCRIPTION="A Python interactive packet manipulation program for mastering the network"
HOMEPAGE="http://www.secdev.org/projects/scapy/"
SRC_URI="https://github.com/secdev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnuplot pyx crypt graphviz imagemagick tcpreplay"

RDEPEND="
	net-analyzer/tcpdump
	gnuplot? ( dev-python/gnuplot-py[${PYTHON_USEDEP}] )
	pyx? ( dev-python/pyx[${PYTHON_USEDEP}] )
	crypt? ( || ( dev-python/pycryptodome[${PYTHON_USEDEP}]
	              dev-python/pycrypto[${PYTHON_USEDEP}] ) )
	graphviz? ( media-gfx/graphviz )
	imagemagick? ( virtual/imagemagick-tools )
	tcpreplay? ( net-analyzer/tcpreplay )
"
