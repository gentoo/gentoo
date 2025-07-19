# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

RUST_MIN_VER="1.82"

inherit cargo desktop shell-completion xdg

DESCRIPTION="A post-modern text editor"
HOMEPAGE="
	https://helix-editor.com/
	https://github.com/helix-editor/helix
"
SRC_URI="
	https://github.com/helix-editor/helix/releases/download/${PV}/${P}-source.tar.xz -> ${P}.tar.xz
	https://github.com/gentoo-crate-dist/helix/releases/download/${PV}/${P}-crates.tar.xz
"
S="${WORKDIR}"

LICENSE="MPL-2.0"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD Boost-1.0 ISC MIT MPL-2.0 MPL-2.0 Unicode-DFS-2016
	ZLIB
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+grammar"

RDEPEND="dev-vcs/git"

pkg_setup() {
	QA_FLAGS_IGNORED="
		usr/bin/hx
		usr/$(get_libdir)/${PN}/.*\.so
	"
	export HELIX_DEFAULT_RUNTIME="${EPREFIX}/usr/share/${PN}/runtime"
	use grammar || export HELIX_DISABLE_AUTO_GRAMMAR_BUILD=1
	rust_pkg_setup
}

src_install() {
	cargo_src_install --path helix-term

	insinto "/usr/$(get_libdir)/${PN}"
	use grammar && doins runtime/grammars/*.so
	rm -r runtime/grammars || die
	use grammar && dosym -r "/usr/$(get_libdir)/${PN}" "/usr/share/${PN}/runtime/grammars"

	insinto /usr/share/helix
	doins -r runtime

	doicon -s 256x256 contrib/${PN}.png
	domenu contrib/Helix.desktop

	insinto /usr/share/metainfo
	doins contrib/Helix.appdata.xml

	newbashcomp contrib/completion/hx.bash hx
	newzshcomp contrib/completion/hx.zsh _hx
	dofishcomp contrib/completion/hx.fish

	DOCS=(
		README.md
		CHANGELOG.md
		docs/
	)
	HTML_DOCS=(
		book/
	)
	einstalldocs
}

pkg_postinst() {
	if ! use grammar ; then
		einfo "Grammars are not installed yet. To fetch them, run:"
		einfo ""
		einfo "  hx --grammar fetch && hx --grammar build"
	fi

	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
