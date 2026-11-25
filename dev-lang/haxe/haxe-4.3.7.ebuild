# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="Multi-target universal programming language"
HOMEPAGE="https://haxe.org/
	https://github.com/HaxeFoundation/haxe/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/HaxeFoundation/${PN}"
else
	# Haxe-debian is a distribution variant that contains the required git modules.
	SRC_URI="https://github.com/HaxeFoundation/${PN}-debian/archive/upstream/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-debian-upstream-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+ MIT"
SLOT="0/${PV}"
IUSE="+ocamlopt"
RESTRICT="strip"

RDEPEND="
	>=dev-ml/extlib-1.7.8:=
	>=dev-ml/luv-0.5.13:=
	>=dev-ml/ptmap-2.0.0:=
	>=dev-ml/sedlex-3.6:=
	dev-ml/ocaml-sha:=
	dev-ml/xml-light:=

	>=dev-lang/ocaml-5.0:=[ocamlopt?]
	dev-lang/neko:=
	dev-libs/boehm-gc:=
	dev-libs/libpcre:=
	net-libs/mbedtls:0=
	virtual/zlib:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-ml/camlp5-8.03.04
	>=dev-ml/dune-1.11
	>=dev-ml/findlib-1.9.1
"

QA_FLAGS_IGNORED="usr/bin/haxelib"
QA_PRESTRIPPED="usr/bin/haxelib"

src_configure() {
	export OCAMLOPT="$(usex ocamlopt ocamlopt.opt ocamlopt)"
}

src_compile() {
	emake -j1 BRANCH="" COMMIT_DATE="" COMMIT_SHA="" \
		OCAMLOPT="${OCAMLOPT}" INSTALL_DIR="/usr"
}

src_install() {
	emake DESTDIR="${D}" INSTALL_DIR="/usr" install
	dodoc *.md
}
