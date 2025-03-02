# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CommitId=9d3ab05a7fffbc71a492bc6a17be034e83e8f0fe

DESCRIPTION="PocketFFT for C++"
HOMEPAGE="https://github.com/mreineck/pocketfft/"
SRC_URI="https://github.com/mreineck/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_install() {
	doheader pocketfft_hdronly.h
	default
}
