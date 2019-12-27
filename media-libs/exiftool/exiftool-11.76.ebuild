# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_NAME=Image-ExifTool
inherit perl-module

DESCRIPTION="Read and write meta information in image, audio and video files"
HOMEPAGE="https://www.sno.phy.queensu.ca/~phil/exiftool/"
SRC_URI="https://www.sno.phy.queensu.ca/~phil/exiftool/${DIST_P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 arm64 ppc ppc64 x86 ~x64-macos"
IUSE="doc"

SRC_TEST="do"

src_install() {
	perl-module_src_install
	use doc && dodoc -r html/

	insinto /usr/share/${PN}
	doins -r fmt_files config_files arg_files
}
