# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

DESCRIPTION="Two-way cross-platform file synchronizer"
HOMEPAGE="https://www.seas.upenn.edu/~bcpierce/unison/
	https://github.com/bcpierce00/unison/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/bcpierce00/${PN}.git"
else
	SRC_URI="https://github.com/bcpierce00/unison/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

LICENSE="GPL-2"
SLOT="$(ver_cut 1-2)"
IUSE="doc gui +ocamlopt"

BDEPEND="
	dev-lang/ocaml:=[ocamlopt?]
	doc? (
		app-text/dvipsk
		app-text/ghostscript-gpl
		dev-texlive/texlive-latex
	)
"
DEPEND="
	gui? (
		dev-ml/lablgtk:3=[ocamlopt?]
	)
"
RDEPEND="
	>=dev-lang/ocaml-4.08:=
	gui? (
		dev-ml/lablgtk:3=[ocamlopt?]
		|| (
			net-misc/ssh-askpass-fullscreen
			net-misc/x11-ssh-askpass
		)
	)
"
IDEPEND="
	>=app-eselect/eselect-unison-0.4
"

DOCS=( CONTRIBUTING.md README.md src/FEATURES.md src/ROADMAP.txt src/TODO.txt )

QA_FLAGS_IGNORED="usr/bin/${PN}-fsmonitor-${SLOT}"

gui_cache_update() {
	if use gui ; then
		xdg_icon_cache_update
		xdg_desktop_database_update
	fi
}

src_compile() {
	local -a myconf=()

	if ! use ocamlopt ; then
		myconf+=( NATIVE=false )
	fi

	# Discard cflags as it will try to pass them to ocamlc...
	emake "${myconf[@]}" CFLAGS="" -j1 tui fsmonitor manpage

	if use gui ; then
		emake "${myconf[@]}" CFLAGS="" -j1 gui
	fi

	if use doc ; then
		VARTEXFONTS="${T}/fonts" emake "${myconf[@]}" CFLAGS="" HEVEA=false docs
	fi
}

src_test() {
	emake test CFLAGS=""
}

src_install() {
	# install manually, since it's just too much
	# work to force the Makefile to do the right thing.
	cd "${S}/src" || die

	local -a bins=(
		unison
		unison-fsmonitor
	)

	if use gui ; then
		bins+=( unison-gui )
	fi

	local binname
	for binname in "${bins[@]}" ; do
		exeinto /usr/bin
		newexe "${binname}" "${binname}-${SLOT}"
	done

	cd "${S}" || die

	doman "man/${PN}.1"

	if use gui ; then
		newicon -s scalable icons/U.svg "${PN}-${SLOT}.svg"
		make_desktop_entry "${PN}-${SLOT}" "${PN^} GUI (${SLOT})" "${PN}-${SLOT}"
	fi

	if use doc ; then
		DOCS+=( doc/unison-manual.pdf )
	fi

	einstalldocs
}

pkg_postinst() {
	elog "Unison now uses SLOTs, so you can specify servercmd=/usr/bin/unison-${SLOT}"
	elog "in your profile files to access exactly this version over ssh."
	elog "Or you can use 'eselect unison' to set the version."

	eselect unison update

	gui_cache_update
}

pkg_postrm() {
	eselect unison update

	gui_cache_update
}
