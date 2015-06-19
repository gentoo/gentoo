# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ocaml-mode/ocaml-mode-4.00.1.ebuild,v 1.2 2014/01/16 00:00:54 bicatali Exp $

EAPI=5

inherit elisp

MY_P=${P/-mode/}
DESCRIPTION="Emacs mode for OCaml"
HOMEPAGE="http://www.ocaml.org/"
SRC_URI="http://caml.inria.fr/distrib/${MY_P%.*}/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-fbsd ~x86-linux"

S="${WORKDIR}/${MY_P}/emacs"
SITEFILE="50${PN}-gentoo-3.12.1.el"
DOCS="README README.itz"
