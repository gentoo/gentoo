# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="DVD utilities to print information, copy tracks, etc."
HOMEPAGE="https://github.com/beandog/dvd_info"
SRC_URI="https://github.com/beandog/dvd_info/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+libmpv"

DEPEND="media-libs/libdvdread[css]
	libmpv? ( media-video/mpv[libmpv,dvd] )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_with libmpv)
}
