# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Multi-target universal programming language"
HOMEPAGE="https://haxe.org/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/HaxeFoundation/haxe.git"
else
	# Haxe-debian already contains correct git modules
	SRC_URI="https://github.com/HaxeFoundation/haxe-debian/archive/upstream/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/haxe-debian-upstream-${PV}"
fi

LICENSE="GPL-2+ MIT"
SLOT="0/${PV}"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4:=[ocamlopt?]
	dev-ml/extlib:=
	dev-ml/ptmap:=
	dev-ml/sedlex:=
	dev-ml/ocaml-sha:=
	dev-ml/xml-light:=

	dev-lang/neko:=
	dev-libs/boehm-gc:=
	dev-libs/libpcre:=
	net-libs/mbedtls:=
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED="usr/bin/haxelib"
QA_PRESTRIPPED="usr/bin/haxelib"

src_configure() {
	use ocamlopt && export OCAMLOPT=ocamlopt.opt
}

src_compile() {
	local mymakeargs=(
		BRANCH=""
		COMMIT_DATE=""
		COMMIT_SHA=""
		INSTALL_DIR=/usr
	)
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" INSTALL_DIR=/usr install

	dodoc *.md
}
