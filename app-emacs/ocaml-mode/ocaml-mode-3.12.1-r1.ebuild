# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ocaml-mode/ocaml-mode-3.12.1-r1.ebuild,v 1.11 2013/02/20 15:35:15 jer Exp $

EAPI=5

inherit elisp

MY_P=${P/-mode/}
DESCRIPTION="Emacs mode for OCaml"
HOMEPAGE="http://www.ocaml.org/"
SRC_URI="http://caml.inria.fr/distrib/${MY_P%.*}/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"

S="${WORKDIR}/${MY_P}/emacs"
SITEFILE="50${PN}-gentoo-${PV}.el"
DOCS="README README.itz"
