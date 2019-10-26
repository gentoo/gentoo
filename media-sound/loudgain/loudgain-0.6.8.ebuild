# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/Moonbase59/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/Moonbase59/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

inherit cmake-utils

DESCRIPTION="ReplayGain 2.0 loudness normalizer based on the EBU R128/ITU BS.1770 standard"
HOMEPAGE="https://github.com/Moonbase59/loudgain"

LICENSE="BSD-2"
SLOT="0"

DEPEND="media-libs/libebur128
	media-libs/taglib
	virtual/ffmpeg"
RDEPEND="${DEPEND}"
