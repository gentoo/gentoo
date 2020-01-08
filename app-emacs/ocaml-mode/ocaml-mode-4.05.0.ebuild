# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

MY_P=${P/-mode/}
DESCRIPTION="Emacs mode for OCaml"
HOMEPAGE="https://ocaml.org/"
SRC_URI="https://github.com/ocaml/ocaml/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/${MY_P}/emacs"
SITEFILE="50${PN}-gentoo-3.12.1.el"
DOCS="README README.itz"
