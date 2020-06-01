# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES=""

MY_PV="${PV//_rc/-rc}"
PYTHON_COMPAT=( python3_{7,8} ) # https://bugs.gentoo.org/725962

inherit bash-completion-r1 cargo desktop python-any-r1 toolchain-funcs

DESCRIPTION="GPU-accelerated terminal emulator"
HOMEPAGE="https://github.com/alacritty/alacritty"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jwilm/alacritty"
else
	SRC_URI="https://github.com/alacritty/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
	KEYWORDS="~amd64 ~ppc64"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 BSD BSD-2 CC0-1.0 FTL ISC MIT MPL-2.0 Unlicense WTFPL-2 ZLIB"
SLOT="0"
IUSE="wayland +X"

REQUIRED_USE="|| ( wayland X )"

DEPEND="${PYTHON_DEPS}"
BDEPEND="dev-util/cmake"

COMMON_DEPEND="
	media-libs/fontconfig:=
	media-libs/freetype:2
	X? ( x11-libs/libxcb:=[xkb] )
"

RDEPEND="${COMMON_DEPEND}
	media-libs/mesa[X?,wayland?]
	sys-libs/zlib
	sys-libs/ncurses:0
	wayland? ( dev-libs/wayland )
	X? (
		x11-libs/libXcursor
		x11-libs/libXi
		x11-libs/libXrandr
	)
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

src_configure() {
	tc-export AR CC
	myfeatures=(
		$(usex X x11 '')
		$(usev wayland)
	)
}

src_compile() {
	cd alacritty || die
	cargo_src_compile ${myfeatures:+--features "${myfeatures[*]}"} --no-default-features
}

src_install() {
	CARGO_INSTALL_PATH="alacritty" cargo_src_install ${myfeatures:+--features "${myfeatures[*]}"} --no-default-features

	newman extra/alacritty.man alacritty.1

	newbashcomp extra/completions/alacritty.bash alacritty

	insinto /usr/share/fish/vendor_completions.d/
	doins extra/completions/alacritty.fish

	insinto /usr/share/zsh/site-functions
	doins extra/completions/_alacritty

	domenu extra/linux/Alacritty.desktop
	newicon extra/logo/alacritty-term.svg Alacritty.svg

	newman extra/alacritty.man alacritty.1

	insinto /usr/share/metainfo
	doins extra/linux/io.alacritty.Alacritty.appdata.xml

	insinto /usr/share/alacritty/scripts
	doins -r scripts/*

	einstalldocs
}

src_test() {
	cd alacritty || die
	cargo_src_test ${myfeatures:+--features "${myfeatures[*]}"} --no-default-features
}
