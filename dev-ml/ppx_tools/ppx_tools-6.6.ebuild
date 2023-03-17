# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

MY_PV=$(ver_rs 2 '+')
DESCRIPTION="Tools for authors of ppx rewriters"
HOMEPAGE="https://github.com/alainfrisch/ppx_tools"
SRC_URI="https://github.com/alainfrisch/ppx_tools/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-$(ver_rs 2 '-')"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt"

BDEPEND="
	dev-ml/cppo
"
