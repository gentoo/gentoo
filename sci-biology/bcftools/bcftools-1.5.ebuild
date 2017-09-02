# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Utilities for variant calling and manipulating VCF and BCF files"
HOMEPAGE="http://www.htslib.org"
SRC_URI="https://github.com/samtools/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-lang/perl
	=sci-libs/htslib-${PV}*:=
	sys-libs/zlib
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5-buildsystem.patch
	"${FILESDIR}"/${PN}-1.5-fix-shebangs.patch
)

src_prepare() {
	default

	# remove bundled htslib
	rm -r htslib-* || die
}

src_configure() {
	econf \
		--disable-bcftools-plugins \
		--disable-libgsl \
		--disable-configure-htslib \
		--with-htslib=system
}
