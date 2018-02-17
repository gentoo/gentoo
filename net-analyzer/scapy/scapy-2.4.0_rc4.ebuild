# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )
inherit eutils distutils-r1 readme.gentoo-r1

DESCRIPTION="A Python interactive packet manipulation program for mastering the network"
HOMEPAGE="http://www.secdev.org/projects/scapy/ https://github.com/secdev/scapy"
SRC_URI="https://github.com/secdev/${PN}/archive/v${PV/_/}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	net-analyzer/tcpdump
"
S=${WORKDIR}/${P/_/}
DOC_CONTENTS="
Scapy has optional support for the following packages:

	dev-python/cryptography
	dev-python/gnuplot-py
	dev-python/ipython
	dev-python/pyx
	dev-python/visual
	media-gfx/graphviz
	net-analyzer/tcpreplay
	virtual/imagemagick-tools

	See also ${EPREFIX}/usr/share/doc/${PF}/installation.rst
"

src_prepare() {
	default
	echo ${PV/_/} > ${PN}/VERSION
}

src_install() {
	default
	dodoc -r doc/${PN}/*
	DISABLE_AUTOFORMATTING=plz readme.gentoo_create_doc
}
