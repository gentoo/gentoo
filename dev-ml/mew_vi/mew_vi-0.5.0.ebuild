# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="A vi-like modal editing engine generator"
HOMEPAGE="https://github.com/kandu/mew_vi"
SRC_URI="https://github.com/kandu/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/mew:=
	dev-ml/react:=
"
DEPEND="${RDEPEND}"
