# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A library for reading media metadata"
HOMEPAGE="https://bitbucket.org/shuerhaaken/libtaginfo"
SRC_URI="https://bitbucket.org/shuerhaaken/${PN}/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="virtual/pkgconfig"
RDEPEND="media-libs/taglib
	!<media-sound/xnoise-0.2.16"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README TODO )
