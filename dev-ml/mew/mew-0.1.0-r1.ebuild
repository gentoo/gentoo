# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="General modal editing engine generator"
HOMEPAGE="https://github.com/kandu/mew"
SRC_URI="https://github.com/kandu/mew/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/result:=
	dev-ml/trie:=
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-ml/ppx_expect )"
