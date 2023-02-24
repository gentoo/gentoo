# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing elisp-common

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="emacs test"
RESTRICT="strip !test? ( test )"

RDEPEND="
	>=dev-lang/ocaml-4.08:=
	emacs? ( >=app-editors/emacs-23.1:* )
"
DEPEND="
	${RDEPEND}
	dev-ml/findlib
	test? (
		dev-ml/core_bench
		dev-ml/ppx_bench
		dev-ml/ppx_expect
	)
"

QA_FLAGS_IGNORED="usr/bin/dune"

BYTECOMPFLAGS="-L ${S}/editor-integration/emacs"
SITEFILE="50${PN}-gentoo.el"

src_configure() {
	:
}

src_compile() {
	ocaml bootstrap.ml -j $(makeopts_jobs) || die
	./dune.exe build -p "${PN}" --profile dune-bootstrap -j $(makeopts_jobs) \
		--display short || die

	use emacs && elisp-compile editor-integration/emacs/*.el
}

src_install() {
	default
	mv "${ED}"/usr/doc "${ED}"/usr/share/doc/${PF} || die
	mv "${ED}"/usr/man "${ED}"/usr/share/man || die

	if use emacs ; then
		elisp-install ${PN} editor-integration/emacs/*.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}
