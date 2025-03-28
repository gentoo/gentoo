# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 readme.gentoo-r1

DESCRIPTION="A Python interactive packet manipulation program for mastering the network"
HOMEPAGE="https://scapy.net/ https://github.com/secdev/scapy"
SRC_URI="https://github.com/secdev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/zstandard[${PYTHON_USEDEP}]
	)
"

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

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.1-skip-test.patch
	"${FILESDIR}"/${PN}-2.6.1-missing-autorun-test-marker.patch
)

src_prepare() {
	export SCAPY_VERSION=${PV}

	# Timed out
	rm test/tftp.uts || die
	# Needs ipython
	rm test/scapy/layers/dhcp.uts || die
	# Import failures
	rm test/contrib/isotp_native_socket.uts \
		test/contrib/isotpscan.uts \
		test/contrib/isotp_soft_socket.uts || die

	distutils-r1_src_prepare
}

python_test() {
	# https://scapy.readthedocs.io/en/latest/development.html#testing-with-utscapy
	# https://github.com/secdev/scapy/blob/master/tox.ini
	#
	# netaccess: network access, obviously
	# tshark, tcpdump: hangs
	# samba: needs rpcdump (and too heavy of a test dep)
	# interact, autorun: tests fail
	"${EPYTHON}" -m scapy.tools.UTscapy -c ./test/configs/linux.utsc -N \
		-K netaccess \
		-K tshark \
		-K tcpdump \
		-K samba \
		-K interact \
		-K autorun \
		-K ci_only || die "Tests failed with ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install

	dodoc -r doc/${PN}/*
	DISABLE_AUTOFORMATTING=1 readme.gentoo_create_doc
}
