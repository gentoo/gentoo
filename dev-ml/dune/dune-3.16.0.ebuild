# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing elisp-common

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="emacs"
RESTRICT="strip test"

RDEPEND="
	>=dev-lang/ocaml-4.08:=
	emacs? ( >=app-editors/emacs-23.1:* )
"
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED="usr/bin/dune"

BYTECOMPFLAGS="-L ${S}/editor-integration/emacs"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	# This allows `dune --version` to output the correct version
	# instead of "n/a"
	sed -i "/^(name dune)/a (version ${PV})" dune-project || die
}

src_configure() {
	./configure \
		--libdir="$(ocamlc -where)" \
		--mandir=/usr/share/man \
		--docdir=/usr/share/doc \
		--etcdir=/etc \
		--datadir=/usr/share \
		--sbindir=/usr/sbin \
		--bindir=/usr/bin \
		|| die
}

src_compile() {
	ocaml boot/bootstrap.ml -j $(makeopts_jobs) --verbose || die
	./_boot/dune.exe build @install -p "${PN}" --profile dune-bootstrap \
		-j $(makeopts_jobs) --display short || die

	use emacs && elisp-compile editor-integration/emacs/*.el
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
