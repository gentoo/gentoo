# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_NAME=Image-ExifTool
inherit perl-module

DESCRIPTION="Read and write meta information in image, audio and video files"
HOMEPAGE="http://www.sno.phy.queensu.ca/~phil/exiftool/ ${HOMEPAGE}"
SRC_URI="http://www.sno.phy.queensu.ca/~phil/exiftool/${DIST_P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x64-macos"
IUSE="doc"

SRC_TEST="do"

src_install() {
	perl-module_src_install
	use doc && dodoc -r html/
}
