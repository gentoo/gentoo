# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1 git-r3 readme.gentoo-r1

DESCRIPTION="A Python interactive packet manipulation program for mastering the network"
HOMEPAGE="https://scapy.net/ https://github.com/secdev/scapy"
EGIT_REPO_URI="https://github.com/secdev/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
S=${WORKDIR}/${P/_/}
DOC_CONTENTS="
Scapy has optional support for the following packages:

	dev-python/cryptography
	dev-python/ipython
	dev-python/matplotlib
	dev-python/pyx
	media-gfx/graphviz
	net-analyzer/tcpdump
	net-analyzer/tcpreplay
	net-libs/libpcap
	virtual/imagemagick-tools

	See also ""${EPREFIX}/usr/share/doc/${PF}/installation.rst""
"

src_prepare() {
	echo ${PV/_/} > ${PN}/VERSION || die

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	dodoc -r doc/${PN}/*
	DISABLE_AUTOFORMATTING=plz readme.gentoo_create_doc
}
