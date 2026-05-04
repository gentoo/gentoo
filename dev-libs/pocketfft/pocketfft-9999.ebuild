# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson toolchain-funcs

DESCRIPTION="PocketFFT for C++"
HOMEPAGE="https://github.com/mreineck/pocketfft https://gitlab.mpcdf.mpg.de/mtr/pocketfft"

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mreineck/pocketfft.git"
else
	CommitId="32424d2067c2e8043dc646a4e49754b2b40cc549"
	SRC_URI="
		https://github.com/mreineck/${PN}/archive/${CommitId}.tar.gz -> ${P}.tar.gz
	"
	S="${WORKDIR}/${PN}-${CommitId}"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

IUSE="test"
RESTRICT="!test? ( test )"

src_compile() {
	meson_src_compile

	if use test; then
		"$(tc-getCXX)" pocketfft_demo.cc -o pocketfft_demo || die
	fi
}

src_test() {
	einfo "running pocketfft_demo"
	./pocketfft_demo > "${T}/pocketfft_demo.log" || die "test failed. Check ${T}/pocketfft_demo.log"
}

src_install() {
	meson_src_install

	doheader pocketfft_hdronly.h
}
