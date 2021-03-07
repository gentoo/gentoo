# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A real-time noise suppression plugin for voice"
HOMEPAGE="https://github.com/werman/noise-suppression-for-voice"

if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/werman/noise-suppression-for-voice.git"
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/werman/noise-suppression-for-voice/archive/453a8af82a31a5361f6a13bf95c97686f0a2acd1.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	dodoc README.md

	cd "${BUILD_DIR}"

	insinto /usr/$(get_libdir)/lv2/
	doins -r bin/rnnoise.lv2

	insinto /usr/$(get_libdir)/ladspa/
	doins bin/ladspa/librnnoise_ladspa.so
}
