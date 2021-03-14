# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> dune-${PV}.tar.gz"
S="${WORKDIR}/dune-${PV}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="
	~dev-ml/dune-private-libs-${PV}:=[ocamlopt=]
	dev-ml/csexp:=[ocamlopt=]
	dev-ml/result:=[ocamlopt=]
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	test? (
		dev-ml/core_bench
		dev-ml/menhir
		dev-ml/opam
		dev-ml/ppx_expect
	)
"
# TODO for test deps:
# Add cram?
# Add dev-ml/js_of_ocaml once dev-ml/ocaml-base64 is ported to Dune
# Add coq?

src_prepare() {
	default

	# Keep this list in sync with dev-ml/dune-private-libs
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

src_configure(){
	:
}
