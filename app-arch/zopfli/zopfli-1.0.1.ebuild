# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Very good, but slow, deflate or zlib compression"
HOMEPAGE="https://github.com/google/zopfli/"
SRC_URI="https://github.com/google/zopfli/archive/${P}.tar.gz"

S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DOCS=( CONTRIBUTORS README README.zopflipng )

# zopfli statically links libzopfli
# zopflipng statically links libzopflipng
# zopflipng also statically links an exact version of LodePNG (https://github.com/lvandeve/lodepng)
# As of version 1.0.1 neither of the binaries
# use the libraries we install. The libraries
# exist solely for use by external programs.

src_compile() {
	emake libzopfli
	emake zopfli

	emake libzopflipng
	emake zopflipng
}

# The Makefile has no install phase
src_install() {
	dolib.so libzopfli.so.${PV}
	dosym libzopfli.so.${PV} /usr/$(get_libdir)/libzopfli.so.1

	dobin ${PN}

	# This version was erroneously not bumped to match ${PV}
	dolib.so libzopflipng.so.1.0.0
	dosym libzopflipng.so.1.0.0 /usr/$(get_libdir)/libzopflipng.so.1

	dobin zopflipng
}
