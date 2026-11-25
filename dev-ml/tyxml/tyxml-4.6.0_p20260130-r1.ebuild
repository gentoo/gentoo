# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == *p20260130 ]] && COMMIT=8d351d6176eeb99f71b7d5d66975593117cba7f1

inherit dune

DESCRIPTION="A library for building correct HTML and SVG documents"
HOMEPAGE="https://github.com/ocsigen/tyxml/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ocsigen/${PN}"
else
	SRC_URI="https://github.com/ocsigen/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ml/markup:=
	dev-ml/ppxlib:=
	dev-ml/uutf:=
	dev-ml/re:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		dev-ml/alcotest
		dev-ml/reason
	)
"

PATCHES=( "${FILESDIR}"/${PN}-4.5.0-gentoo.patch )
