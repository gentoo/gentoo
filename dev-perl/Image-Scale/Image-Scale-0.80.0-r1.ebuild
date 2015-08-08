# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=AGRUNDMA
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="Fast, high-quality fixed-point image resizing"

LICENSE="|| ( GPL-2 GPL-3 )" # GPL2+
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gif jpeg +png test"

REQUIRED_USE="|| ( jpeg png )"

RDEPEND="
	png? (
		media-libs/libpng:0
	)
	jpeg? (
		virtual/jpeg
	)
	gif? (
		media-libs/giflib
	)
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-NoWarnings
	)
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST=do
PATCHES=(
	"${FILESDIR}"/libpng-1.5-memcpy.patch
	"${FILESDIR}"/0.80.0-disable_autodetect.patch
)

src_configure() {
	local myconf
	for useflag in png jpeg gif; do
		myconf+=( $(usex $useflag "" --disable-${useflag}) )
	done
	perl-module_src_configure
}
