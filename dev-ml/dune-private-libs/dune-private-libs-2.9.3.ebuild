# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> dune-${PV}.tar.gz"
S="${WORKDIR}/dune-${PV}"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

BDEPEND="
	~dev-ml/dune-${PV}
	test? (
		dev-ml/core_bench
		dev-ml/menhir
		dev-ml/opam
		dev-ml/ppx_expect
	)
"
DEPEND="
	dev-ml/csexp:=[ocamlopt?]
	dev-ml/findlib:=[ocamlopt?]
	>=dev-lang/ocaml-4.09:=
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-test.patch )

# TODO for test deps:
# Add cram?
# Add dev-ml/js_of_ocaml once dev-ml/ocaml-base64 is ported to Dune
# Add coq?

src_prepare() {
	default

	# Keep this list in sync with dev-ml/dune-configurator
	local bad_tests=(
		# List of tests calling git, mercurial, etc
		test/blackbox-tests/test-cases/dune-project-meta/main.t
		test/blackbox-tests/test-cases/meta-template-version-bug.t
		test/blackbox-tests/test-cases/subst/project-name-restriction.t
		test/blackbox-tests/test-cases/subst/with-opam-file.t
		test/blackbox-tests/test-cases/subst.t
		test/blackbox-tests/test-cases/subst/unicode.t
		test/blackbox-tests/test-cases/subst/from-project-file.t
		test/blackbox-tests/test-cases/trace-file.t
		otherlibs/build-info/test/run.t
		test/expect-tests/vcs_tests.ml

		# Strange failures, seemingly from newer versions of deps
		test/blackbox-tests/test-cases/merlin/allow_approximate_merlin_warn.t
		test/blackbox-tests/test-cases/merlin/merlin-tests.t
		test/blackbox-tests/test-cases/merlin/github4125.t
		test/blackbox-tests/test-cases/install-dry-run.t
		test/blackbox-tests/test-cases/c-flags.t
		test/blackbox-tests/test-cases/install-libdir.t
		test/blackbox-tests/test-cases/dune-cache/trim.t

		# Strange failures about opam not being initialised
		test/blackbox-tests/test-cases/merlin/merlin-from-subdir.t
		test/blackbox-tests/test-cases/merlin/symlinks.t
		test/blackbox-tests/test-cases/merlin/src-dirs-of-deps.t
		test/blackbox-tests/test-cases/merlin/per-module-pp.t
		test/blackbox-tests/test-cases/merlin/server.t
		test/blackbox-tests/test-cases/github1946.t
		test/blackbox-tests/test-cases/github759.t
		test/blackbox-tests/test-cases/merlin/default-based-context.t
		otherlibs/site/test/run.t

		# Deprecated warnings
		test/blackbox-tests/test-cases/toplevel-integration.t

		# Wants nodejs!
		test/blackbox-tests/test-cases/jsoo/simple.t
		test/blackbox-tests/test-cases/jsoo/inline-tests.t
		test/blackbox-tests/test-cases/jsoo/github3622.t
		# Wants js_of_ocaml (can't include yet b/c of ocaml-base64 porting)
		test/blackbox-tests/test-cases/jsoo/explicit-js-mode-specified.t

		# Wants coq which doesn't build for me right now
		test/blackbox-tests/test-cases/coq/rec-module.t
		test/blackbox-tests/test-cases/coq/compose-sub-theory.t
		test/blackbox-tests/test-cases/coq/native-compose.t
		test/blackbox-tests/test-cases/coq/base-unsound.t
		test/blackbox-tests/test-cases/coq/base.t
		test/blackbox-tests/test-cases/coq/native-single.t
		test/blackbox-tests/test-cases/coq/compose-simple.t
		test/blackbox-tests/test-cases/coq/ml-lib.t
		test/blackbox-tests/test-cases/coq/extract.t
		test/blackbox-tests/test-cases/coq/compose-plugin.t
		test/blackbox-tests/test-cases/coq/flags.t
		test/blackbox-tests/test-cases/coq/env.t

		# Unpackaged dependencies (a rabbit hole for now)
		# utop -> lambda-term, zed
		test/blackbox-tests/test-cases/utop/github3188.t
		test/blackbox-tests/test-cases/utop/utop-simple.t
		test/blackbox-tests/test-cases/utop/utop-default.t
		test/blackbox-tests/test-cases/utop/utop-default-implementation.t
		test/blackbox-tests/test-cases/utop/utop-ppx-rewriters.t
		# ocamlformat
		test/blackbox-tests/test-cases/formatting.t
		# mdx
		test/blackbox-tests/test-cases/mdx-stanza.t
		# odoc
		test/blackbox-tests/test-cases/odoc/odoc-simple.t
		test/blackbox-tests/test-cases/odoc/odoc-package-mld-link.t
		test/blackbox-tests/test-cases/odoc/multiple-private-libs.t
		test/blackbox-tests/test-cases/odoc/odoc-unique-mlds.t
		test/blackbox-tests/test-cases/odoc/github717-odoc-index.t
		test/blackbox-tests/test-cases/odoc/warnings.t
	)

	rm -r ${bad_tests[@]} || die "Failed to remove broken/inappropriate tests"
}

src_configure() {
	:
}
