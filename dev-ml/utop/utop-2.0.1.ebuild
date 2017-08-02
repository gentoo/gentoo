# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib opam

DESCRIPTION="A new toplevel for OCaml with completion and colorization"
HOMEPAGE="https://github.com/diml/utop"
SRC_URI="https://github.com/diml/utop/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-ml/lwt-2.4.0:=
	dev-ml/lwt_react:=
	>=dev-ml/lambda-term-1.2:=
	>=dev-ml/zed-1.2:=
	>=dev-ml/cppo-1.0.1:=
	>=dev-ml/findlib-1.7.2:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/jbuilder"
