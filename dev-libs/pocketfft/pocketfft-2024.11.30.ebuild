# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CommitId=0fa0ef591e38c2758e3184c6c23e497b9f732ffa

DESCRIPTION="PocketFFT for C++"
HOMEPAGE="https://github.com/mreineck/pocketfft/"
SRC_URI="https://github.com/mreineck/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

src_install() {
	doheader pocketfft_hdronly.h
	default
}
