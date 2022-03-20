# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="C libary for Netflix's Perceptual video quality assessment based on multi-method fusion."
HOMEPAGE="https://github.com/Netflix/vmaf"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Netflix/vmaf.git"
else
	SRC_URI="
		https://github.com/Netflix/vmaf/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2-with-patent"
SLOT="0"

# upstream issue, see bug #835471
RESTRICT="test"

BDEPEND="
	dev-lang/nasm
"

RDEPEND="${BDEPEND}"

S="${WORKDIR}/vmaf-${PV}"

multilib_src_configure() {
	EMESON_SOURCE="${S}/libvmaf"
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
