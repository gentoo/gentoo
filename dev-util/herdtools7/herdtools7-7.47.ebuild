# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit opam

DESCRIPTION="The Herd toolsuite to deal with .cat memory models"
HOMEPAGE="http://diy.inria.fr/sources/index.html"
SRC_URI="https://github.com/herd/herdtools7/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CeCILL-B"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-ml/ocamlbuild"
RDEPEND=">=dev-lang/ocaml-4.02.0"

PATCHES=(
	"${FILESDIR}/${P}-mkdir.patch"
)

src_compile() {
	./build.sh /usr || die "Build failed"
}

src_install() {
	./install.sh "${ED}/usr" || die "Install failed"
}
