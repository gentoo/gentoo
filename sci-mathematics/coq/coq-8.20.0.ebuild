# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs desktop dune edo

DESCRIPTION="Proof assistant written in O'Caml"
HOMEPAGE="https://coq.inria.fr/
	https://github.com/coq/coq/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/coq/coq.git"
else
	SRC_URI="https://github.com/coq/coq/archive/V${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
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
DUNE_PACKAGES=()

src_prepare() {
	# Remove bad tests (recursive).
	local -a bad_tests=(
		coq-makefile/timing-aggregate
		coq-makefile/timing-error
		coq-makefile/timing-per-file
		coq-makefile/timing-per-line
		coq-makefile/timing-template
	)
	local bad_test=""
	for bad_test in "${bad_tests[@]}" ; do
		if [[ -e "test-suite/${bad_test}" ]] ; then
			rm -r "test-suite/${bad_test}" || die "failed to remove test ${bad_test}"
		else
			ewarn "Test file ${bad_test} does not exist"
		fi
	done

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
	edo sh ./configure "${myconf[@]}"
}

src_compile() {
	emake DUNEOPT="--display=short --profile release" VERBOSE="1" dunestrap

	dune-compile "${DUNE_PACKAGES[@]}"

	use doc && emake refman-html
}

src_install() {
	dune-install "${DUNE_PACKAGES[@]}"

	if use gui ; then
		make_desktop_entry coqide "Coq IDE" "${EPREFIX}/usr/share/coq/coq.png"
	fi

	local ocamlc_where="$(ocamlc -where)"

	# Dune installs into /usr/<libdir>/ocaml/<coq> but
	# Coq wants /usr/<libdir>/<coq> ; symlink those directories
	local sym=""
	for sym in "${DUNE_PACKAGES[@]}" ; do
		dosym "${ocamlc_where}/${sym}" "/usr/$(get_libdir)/${sym}"
	done

	einstalldocs
}
