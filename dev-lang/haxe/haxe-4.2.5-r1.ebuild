# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Multi-target universal programming language"
HOMEPAGE="https://haxe.org/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/HaxeFoundation/haxe.git"
else
	# Haxe-debian already contains correct git modules
	SRC_URI="https://github.com/HaxeFoundation/haxe-debian/archive/upstream/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}"/haxe-debian-upstream-${PV}
fi

LICENSE="GPL-2+ MIT"
SLOT="0/${PV}"
IUSE="+ocamlopt"
RESTRICT="strip"
# NOTICE:
# Theoretically luv <= 0.5.8 is pinned but it is because of mingw issues
RDEPEND="
	>=dev-lang/ocaml-4:=[ocamlopt?]
	dev-ml/extlib:=
	dev-ml/luv:=
	dev-ml/ocaml-sha:=
	dev-ml/ptmap:=
	dev-ml/sedlex:=
	dev-ml/xml-light:=

	dev-lang/neko:=
	dev-libs/boehm-gc:=
	dev-libs/libpcre:=
	net-libs/mbedtls:=
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-ml/camlp5
	dev-ml/dune
	dev-ml/findlib
"

QA_FLAGS_IGNORED="usr/bin/haxelib"
QA_PRESTRIPPED="usr/bin/haxelib"

src_configure() {
	if use ocamlopt ; then
		export OCAMLOPT=ocamlopt.opt
	else
		export OCAMLOPT=ocamlopt
	fi
}

src_compile() {
	emake -j1 BRANCH="" COMMIT_DATE="" COMMIT_SHA="" \
		OCAMLOPT="${OCAMLOPT}" INSTALL_DIR=/usr
}

src_install() {
	emake DESTDIR="${D}" INSTALL_DIR=/usr install
	dodoc *.md
}
