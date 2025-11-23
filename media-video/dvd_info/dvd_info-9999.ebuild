# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/beandog/dvd_info.git"
else
	SRC_URI="https://github.com/beandog/dvd_info/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="DVD utilities to print information, copy tracks, backup, etc"
HOMEPAGE="https://github.com/beandog/dvd_info"

LICENSE="GPL-2"
SLOT="0"
IUSE="+libmpv"

DEPEND="
	media-libs/libdvdread
	libmpv? ( media-video/mpv[libmpv,dvd] )
"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_with libmpv)
}
