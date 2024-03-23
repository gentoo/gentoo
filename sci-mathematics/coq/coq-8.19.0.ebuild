# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/_p/pl}"
MY_P="${PN}-${MY_PV}"

inherit check-reqs desktop dune edo

DESCRIPTION="Proof assistant written in O'Caml"
HOMEPAGE="http://coq.inria.fr/
	https://github.com/coq/coq/"
SRC_URI="https://github.com/coq/coq/archive/V${MY_PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 ~x86"
IUSE="debug doc gui +ocamlopt test"

# TODO: Lots of failing tests. Maybe investigate later.
# RESTRICT="!test? ( test )"
RESTRICT="test"

RDEPEND="
	dev-ml/num:=
	dev-ml/zarith:=
	gui? (
		>=dev-ml/lablgtk-3.1.2:3=[sourceview,ocamlopt?]
		>=dev-ml/lablgtk-sourceview-3.1.2:3=[ocamlopt?]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-ml/findlib
	doc? (
		>=dev-java/antlr-4.7:4
		dev-python/antlr4-python3-runtime
		dev-python/beautifulsoup4
		dev-python/pexpect
		dev-python/sphinx-rtd-theme
		dev-python/sphinxcontrib-bibtex
		dev-tex/latexmk
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-xetex
		media-fonts/freefont
	)
	test? (
		dev-ml/ounit2
	)
"

CHECKREQS_DISK_BUILD="2G"

DOCS=( CODE_OF_CONDUCT.md CONTRIBUTING.md CREDITS INSTALL.md README.md )
declare -a DUNE_PACKAGES

src_prepare() {
	# Remove failing tests. bug #904186
	rm -r test-suite/coq-makefile/timing || die

	default
}

src_configure() {
	export CAML_LD_LIBRARY_PATH="${S}/kernel/byterun/"

	DUNE_PACKAGES=(
		coq-core
		coq-stdlib
		coqide-server
		coq
	)
	use gui && DUNE_PACKAGES+=( coqide )

	emake clean

	local -a myconf=(
		-prefix /usr
		-libdir "/usr/$(get_libdir)/coq"
		-mandir /usr/share/man
		-docdir "/usr/share/doc/${PF}"
		-datadir /usr/share/coq
		-configdir "/etc/xdg/${PN}"
		-native-compiler "$(usex ocamlopt yes no)"
	)
	use debug && myconf+=( -debug )
	edob sh ./configure "${myconf[@]}"
}

src_compile() {
	emake DUNEOPT="--display=short --profile release" VERBOSE=1 dunestrap

	dune-compile "${DUNE_PACKAGES[@]}"

	use doc && emake refman-html
}

src_install() {
	dune-install "${DUNE_PACKAGES[@]}"

	if use gui ; then
		make_desktop_entry coqide "Coq IDE" "${EPREFIX}/usr/share/coq/coq.png"
	fi

	local ocamlc_where
	ocamlc_where="$(ocamlc -where)"

	# Dune installs into /usr/<libdir>/ocaml/<coq> but
	# Coq wants /usr/<libdir>/<coq> ; symlink those directories
	local sym
	for sym in "${DUNE_PACKAGES[@]}" ; do
		dosym "${ocamlc_where}/${sym}" "/usr/$(get_libdir)/${sym}"
	done

	einstalldocs
}
