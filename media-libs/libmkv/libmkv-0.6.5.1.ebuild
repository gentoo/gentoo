# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools

SRC_URI="https://github.com/saintdev/libmkv/archive/${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Lightweight Matroska muxer written for HandBrake"
HOMEPAGE="https://github.com/saintdev/libmkv"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare()
{
	eautoreconf
}
