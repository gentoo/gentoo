# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check https://exiftool.org/history.html for whether a release is 'production'
# Ideally don't bump to non-production at all, but certainly don't stable.
#
# We fetch from CPAN because it only has production releases and the tarballs
# are kept around for longer (see bug #924106).

DIST_AUTHOR=EXIFTOOL
DIST_NAME=Image-ExifTool
inherit perl-module

DESCRIPTION="Read and write meta information in image, audio and video files"
HOMEPAGE="https://exiftool.org/ https://exiftool.sourceforge.net"

SLOT="0"
KEYWORDS="amd64 arm64 ppc ppc64 x86 ~x64-macos"
IUSE="doc"

src_install() {
	perl-module_src_install
	use doc && dodoc -r html/

	insinto /usr/share/${PN}
	doins -r fmt_files config_files arg_files
}
