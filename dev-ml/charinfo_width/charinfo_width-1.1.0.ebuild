# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="charInfo_width"
DUNE_PKG_NAME="${MY_PN}"

inherit dune

DESCRIPTION="Determine column width for a character"
HOMEPAGE="https://github.com/kandu/charInfo_width"
SRC_URI="https://github.com/kandu/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/camomile:=
	dev-ml/ppx_expect:=
	dev-ml/result:=
"
DEPEND="${RDEPEND}"
