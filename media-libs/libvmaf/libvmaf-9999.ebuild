# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib flag-o-matic

DESCRIPTION="C libary for Netflix's Perceptual video quality assessment"
HOMEPAGE="https://github.com/Netflix/vmaf"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Netflix/vmaf.git"
else
	SRC_URI="
		https://github.com/Netflix/vmaf/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
fi

LICENSE="BSD-2-with-patent"
SLOT="0"
IUSE="+embed-models test"

RESTRICT="!test? ( test )"

BDEPEND="
	dev-lang/nasm
	embed-models? ( dev-util/xxd )
"

RDEPEND="${BDEPEND}"

if [[ ${PV} == "9999" ]]; then
	S="${WORKDIR}/libvmaf-${PV}"
else
	S="${WORKDIR}/vmaf-${PV}"
fi

multilib_src_configure() {
	local emesonargs=(
		$(meson_use embed-models built_in_models)
		$(meson_use test enable_tests)
	)

	EMESON_SOURCE="${S}/libvmaf"
	filter-lto
	meson_src_configure
}

multilib_src_install() {
	meson_src_install
	find "${D}" -name '*.la' -delete -o -name '*.a' -delete || die
}

multilib_src_install_all() {
	einstalldocs

	insinto "/usr/share/vmaf"
	doins -r "${S}/model"
}
