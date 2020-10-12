# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils

DESCRIPTION="A cross-platform C library for decoding .smk Smacker Video files."
HOMEPAGE="https://libsmacker.sourceforge.net"

SRC_URI="https://sourceforge.net/projects/libsmacker/files/libsmacker-1.1/libsmacker-1.1.1r35.tar.gz/download -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

src_prepare(){
	default
	eautoreconf
}
