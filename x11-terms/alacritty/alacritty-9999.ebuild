# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES=""

MY_PV="${PV//_rc/-rc}"

inherit bash-completion-r1 cargo desktop eutils

DESCRIPTION="GPU-accelerated terminal emulator"
HOMEPAGE="https://github.com/jwilm/alacritty"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jwilm/alacritty"
else
	SRC_URI="https://github.com/jwilm/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
	KEYWORDS="amd64 ~ppc64"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	media-libs/fontconfig:=
	media-libs/freetype:2
	x11-libs/libxcb
"

RDEPEND="${DEPEND}
	sys-libs/zlib
	sys-libs/ncurses:0
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libXrandr
	virtual/opengl
"

BDEPEND="dev-util/cmake
	>=virtual/rust-1.37.0
"

DOCS=( CHANGELOG.md docs/ansicode.txt INSTALL.md README.md alacritty.yml )

QA_FLAGS_IGNORED="usr/bin/alacritty"

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_install() {
	CARGO_INSTALL_PATH="alacritty" cargo_src_install

	newbashcomp extra/completions/alacritty.bash alacritty

	insinto /usr/share/fish/vendor_completions.d/
	doins extra/completions/alacritty.fish

	insinto /usr/share/zsh/site-functions
	doins extra/completions/_alacritty

	domenu extra/linux/alacritty.desktop
	newicon extra/logo/alacritty-term.svg Alacritty.svg

	newman extra/alacritty.man alacritty.1

	insinto /usr/share/alacritty/scripts
	doins -r scripts/*

	einstalldocs
}

src_test() {
	cargo_src_test --offline
}

pkg_postinst() {
	optfeature "wayland support" dev-libs/wayland
	optfeature "apply-tilix-colorscheme script dependency" dev-python/pyyaml
}
