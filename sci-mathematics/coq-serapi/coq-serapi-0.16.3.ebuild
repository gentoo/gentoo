# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COQV=8.16.0

inherit elisp-common dune

DESCRIPTION="Serialization library and protocol for interaction with the Coq proof assistant"
HOMEPAGE="https://github.com/ejgallego/coq-serapi/"

# The tarball in SRC_URI is comprised of <supported coq>+<package version>
SRC_URI="https://github.com/ejgallego/${PN}/archive/${COQV}+${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COQV}-${PV}

LICENSE="GPL-3+"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="emacs +ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=sci-mathematics/coq-${COQV}:= <sci-mathematics/coq-8.17:=
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
DEPEND="${RDEPEND}"
BDEPEND="
	emacs? ( >=app-editors/emacs-23.1:* )
	test? ( sci-mathematics/coq-mathcomp )
"

SITEFILE="50sertop-gentoo.el"

PATCHES=( "${FILESDIR}"/${PN}-sertop.el-path.patch )

src_compile() {
	dune_src_compile

	use emacs && elisp-compile sertop.el
}

src_install() {
	dune_src_install

	rm -r "${D}"/usr/share/emacs || die

	if use emacs ; then
		elisp-install ${PN} sertop.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
