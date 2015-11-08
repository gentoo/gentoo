# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils flag-o-matic python-single-r1

DESCRIPTION="C++ Sequence Analysis Library"
HOMEPAGE="http://www.seqan.de/"
SRC_URI="http://ftp.seqan.de/releases/${P}.zip"

SLOT="0"
LICENSE="BSD GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	~sci-biology/samtools-0.1.19"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${P}/cmake

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ $(gcc-major-version) -gt 4 ]] || \
		( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -gt 8 ]] ) \
		&& die "Sorry, but gcc 4.9 or higher is unsupported"
	fi
}

src_prepare() {
	append-cppflags -I"${EPREFIX}/usr/include/bam"
	rm -rf "${S}"/../lib/samtools || die

	sed \
		-e "s:docs:docs/.:g" \
		-e "/DESTINATION/s:seqan:doc/${PF}/html:g" \
		-i CMakeLists.txt || die

	sed \
		-e "/DESTINATION/s:bin):share/${PN}):g" \
		-i apps/CMakeLists.txt || die

	cmake-utils_src_prepare
}
