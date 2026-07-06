# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit multiprocessing elisp-common

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="emacs test"
RESTRICT="strip !test? ( test )"

RDEPEND="
	dev-lang/ocaml:=
	emacs? ( >=app-editors/emacs-23.1:* )
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		app-misc/jq
		dev-debug/strace
		>=dev-lang/ocaml-5.4.0
		dev-ml/csexp
		dev-ml/lwt
		dev-ml/pp
		dev-ml/ppx_expect
		dev-ml/re
		dev-ml/spawn
		dev-ml/uutf
		dev-vcs/git
	)
"

QA_FLAGS_IGNORED="usr/bin/dune"

BYTECOMPFLAGS="-L ${S}/editor-integration/emacs"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	# This allows `dune --version` to output the correct version
	# instead of "n/a"
	sed -i "/^(name dune)/a (version ${PV})" dune-project || die

	# the dune-project file for dune includes generating .opam files,
	# but they differ from the committed versions in that they include a
	# version entry. Supposedly "dune promote" should be able to update
	# these files, but it always fails with an error that the generated
	# opam files do not match the committed ones (because of this
	# version field). These files are not in the install image, they
	# only trip up testing.
	find opam -name '*.opam' -exec sed -i "/^opam-version: \"2.0\"/a version: \"${PV}\"" {} + || die

	# Remove tests from test/blackbox-tests that don't work for various
	# reasons. The majority of these are taken from Debian's testing, but
	# the list is expanded with additional tests that fail (for example,
	# because unpackaged dependencies like js_of_ocaml)
	#
	# See: https://salsa.debian.org/ocaml-team/ocaml-dune/-/blob/master/debian/rules?ref_type=heads

	# Tests that need melc
	rm -r test/blackbox-tests/test-cases/melange || die
	rm -r test/blackbox-tests/test-cases/merlin || die

	# Tests that need files in /usr/doc
	rm -r test/blackbox-tests/test-cases/cinaps || die
	rm -r test/blackbox-tests/test-cases/inline-tests || die
	rm -r test/blackbox-tests/test-cases/ppx || die
	rm -r test/blackbox-tests/test-cases/utop || die
	rm -r test/blackbox-tests/test-cases/jsoo || die
	rm -r test/blackbox-tests/test-cases/ctypes || die

	# Tests with other unsatisfied assumptions
	rm -r test/blackbox-tests/test-cases/custom-cross-compilation || die
	rm -r test/blackbox-tests/test-cases/subst || die
	rm -r test/blackbox-tests/test-cases/pkg || die
	rm test/blackbox-tests/test-cases/os-variables.t || die
	rm -r test/blackbox-tests/test-cases/cram || die
	rm -r test/blackbox-tests/test-cases/actions || die
	#rm -r test/blackbox-tests/test-cases/foreign-stubs/github7146.t || die
	rm -r test/expect-tests/vcs || die

	# Many expect-tests fail, but common and test_scheduler are needed for the rest
	mkdir test-libs || die
	mv test/expect-tests/{common,test_scheduler} test-libs || die
	rm -r test/expect-tests || die

	# Flaky tests (to be investigated)
	rm -r otherlibs/dune-site/test || die # failed on amd64
	rm -r otherlibs/dune-rpc-lwt/examples/rpc_client/test || die # failed on riscv64
	rm -r otherlibs/dune-rpc-lwt/test || die # failed on s390x
	rm -r otherlibs/stdune/test || die # failed on i386

	# requires dev-ml/opam
	rm -r test/blackbox-tests/test-cases/stanzas || die
	rm test/blackbox-tests/test-cases/empty-meta-version-gh9176.t || die
	rm -r test/blackbox-tests/test-cases/workspaces || die

	# requires js_of_ocaml
	rm -r test/blackbox-tests/test-cases/separate-compilation-github3622 || die

	# requires dev-ml/odoc
	rm -r test/blackbox-tests/test-cases/odoc || die
	rm -r test/blackbox-tests/test-cases/install-mld-pages || die

	# requires dev-ml/menhir
	rm -r test/blackbox-tests/test-cases/menhir || die
	rm -r test/blackbox-tests/test-cases/formatting || die

	# fails with a diff
	rm -r test/blackbox-tests/test-cases/trace/action-traces || die
	rm -r test/blackbox-tests/test-cases/trace/first-last-events.t || die
	rm -r test/blackbox-tests/test-cases/tests-locks.t || die
	rm -r test/blackbox-tests/test-cases/install-dir || die

	# attempts to install outside of build dir
	rm -r test/blackbox-tests/test-cases/install || die

	# fails with newer versions of dune (> 3.17)
	rm -r test/blackbox-tests/test-cases/hidden-deps-unsupported.t || die

	# requires fdo
	rm -r test/blackbox-tests/test-cases/fdo.t || die
}

src_configure() {
	local confargs=(
		--libdir="$(ocamlc -where)"
		--mandir="${EPREFIX}"/usr/share/man
		--docdir="${EPREFIX}"/usr/share/doc
		--etcdir="${EPREFIX}"/etc
		--datadir="${EPREFIX}"/usr/share
		--sbindir="${EPREFIX}"/usr/sbin
		--bindir="${EPREFIX}"/usr/bin
	)
	edo ./configure "${confargs[@]}"
}

src_compile() {
	edo ocaml boot/bootstrap.ml -j $(get_makeopts_jobs) --verbose

	local buildargs=(
		build dune.install
		-p "${PN}"
		--profile dune-bootstrap
		-j "$(get_makeopts_jobs)"
		--display short
	)
	edo ./_boot/dune.exe "${buildargs[@]}"

	use emacs && elisp-compile editor-integration/emacs/*.el
}

src_test() {
	# Dune's own approach to testing relies on opam switches and
	# vendored copies of necessary dependencies. The majority of these
	# dependencies require dune itself to build.
	#
	# We take an approach similar to Debian where we keep the majority
	# of the tests and remove those that don't work for whatever reason.
	edo ./_boot/dune.exe runtest --display short
}

src_install() {
	# OCaml generates textrels on 32-bit arches
	if use arm || use ppc || use x86 ; then
		export QA_TEXTRELS='.*'
	fi
	default

	mv "${ED}"/usr/share/doc/dune "${ED}"/usr/share/doc/${PF} || die

	if use emacs ; then
		elisp-install ${PN} editor-integration/emacs/*.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}
