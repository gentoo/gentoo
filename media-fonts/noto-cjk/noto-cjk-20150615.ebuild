# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit font

DESCRIPTION="Google's font family that aims to support all the world's languages"
HOMEPAGE="https://www.google.com/get/noto/"

# https://noto-website.storage.googleapis.com/pkgs/Noto-hinted.zip
# Version number based on the timestamp of most recently updated font in the zip.
# When bumping, remove all but *CJK* and create a tarball.
SRC_URI="https://dev.gentoo.org/~floppym/dist/${P}.tar.xz"

LICENSE="OFL-1.1" # https://github.com/googlei18n/noto-fonts/blob/master/NEWS
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RESTRICT="binchecks strip"

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="otf"
