# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs desktop dune edo

DESCRIPTION="Coq/Rocq is a proof assistant written in O'Caml"
HOMEPAGE="https://rocq-prover.org
	https://github.com/rocq-prover/rocq/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/coq/coq"
else
	SRC_URI="https://github.com/coq/coq/archive/V${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/rocq-${PV}"

	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
IUSE="debug gui native-compiler +ocamlopt test"

# TODO: Lots of failing tests.
# RESTRICT="!test? ( test )"
RESTRICT="test"

RDEPEND="
	dev-ml/camlzip:=
	dev-ml/num:=
	dev-ml/yojson:=
	dev-ml/zarith:=
	gui? (
		>=dev-ml/lablgtk-3.1.2:3=[sourceview,ocamlopt?]
		>=dev-ml/lablgtk-sourceview-3.1.2:3=[ocamlopt?]
	)
	native-compiler? (
		<dev-lang/ocaml-5:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-ml/findlib
	test? (
		dev-ml/ounit2
	)
"
PDEPEND="
	sci-mathematics/coq-stdlib
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
	local -x CAML_LD_LIBRARY_PATH="${S}/kernel/byterun/"

	DUNE_PACKAGES=(
		coq-core
		rocq-core
		rocq-devtools
		rocq-runtime
	)

	if use gui ; then
		DUNE_PACKAGES+=(
			coqide-server
			rocqide
		)
	fi

	local -a myconf=(
		-prefix /usr
		-libdir "/usr/$(get_libdir)/ocaml/coq"
		-mandir /usr/share/man
		-docdir "/usr/share/doc/${PF}"
		-datadir /usr/share/coq
		-configdir "/etc/xdg/${PN}"
		-native-compiler "$(usex native-compiler yes no)"
	)

	if use debug ; then
		myconf+=(
			-debug
		)
	fi

	emake clean
	edo sh ./configure "${myconf[@]}"
}

src_compile() {
	emake DUNEOPT="--display=short --profile release" VERBOSE="1" dunestrap

	dune-compile "${DUNE_PACKAGES[@]}"
}

src_install() {
	dune-install "${DUNE_PACKAGES[@]}"

	if use gui ; then
		make_desktop_entry rocqide "Coq IDE" "${EPREFIX}/usr/share/coq/coq.png"
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
