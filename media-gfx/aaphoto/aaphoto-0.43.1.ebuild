# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AM_OPTS="--force-missing" # overwrite old 'missing' script
inherit autotools-utils

DESCRIPTION="Automatic color correction and resizing of photos"
HOMEPAGE="http://log69.com/aaphoto.html https://github.com/log69/aaphoto"
SRC_URI="https://github.com/log69/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="media-libs/jasper[jpeg]
	media-libs/libpng:0=
	sys-libs/zlib
	virtual/jpeg:0"
DEPEND="${RDEPEND}"

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ $(gcc-major-version) -lt 4 ]] || \
		( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 2 ]] ) \
		&& die "Sorry, but gcc 4.2 or higher is required"
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}
