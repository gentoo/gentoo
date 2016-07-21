# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit elisp

MY_P=${P/-mode/}

DESCRIPTION="Emacs mode for OCaml"
HOMEPAGE="http://www.ocaml.org/"
SRC_URI="http://caml.inria.fr/distrib/${MY_P%.*}/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${MY_P}/emacs"
SITEFILE="50${PN}-gentoo.el"
DOCS="README README.itz"
