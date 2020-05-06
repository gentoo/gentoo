# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://code.videolan.org/videolan/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://code.videolan.org/videolan/libudfread/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Library for reading UDF from raw devices and image files"
HOMEPAGE="https://code.videolan.org/videolan/libudfread/"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}
