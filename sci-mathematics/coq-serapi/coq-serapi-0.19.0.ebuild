# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COQ_MIN_V=8.19.0
COQ_MAX_V=8.20.0

inherit dune elisp-common

DESCRIPTION="Serialization library and protocol for interaction with the Coq proof assistant"
HOMEPAGE="https://github.com/ejgallego/coq-serapi/"

# The tarball in SRC_URI is comprised of <supported coq>+<package version>
SRC_URI="https://github.com/ejgallego/${PN}/archive/${COQ_MIN_V}+${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COQ_MIN_V}-${PV}"

LICENSE="GPL-3+"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="emacs +ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=sci-mathematics/coq-${COQ_MIN_V}:= <sci-mathematics/coq-${COQ_MAX_V}:=
	>=dev-ml/ppx_sexp_conv-0.13.0:=
	dev-ml/cmdliner:=
	dev-ml/ppx_compare:=
	dev-ml/ppx_deriving:=
	dev-ml/ppx_deriving_yojson:=
	dev-ml/ppx_hash:=
	dev-ml/ppx_import:=
	dev-ml/sexplib:=
	dev-ml/yojson:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	emacs? (
		>=app-editors/emacs-23.1:*
	)
	test? (
		sci-mathematics/coq-mathcomp
	)
"

PATCHES=( "${FILESDIR}/${PN}-0.19.0-sertop-el.patch" )

SITEFILE="50sertop-gentoo.el"

src_compile() {
	dune_src_compile

	use emacs && elisp-compile sertop/*.el
}

src_install() {
	dune_src_install

	rm -r "${ED}/usr/share/emacs" || die

	if use emacs ; then
		elisp-install "${PN}" sertop/*.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
