# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_CONFIG_NAME="doxygen.conf"
inherit docs toolchain-funcs

DESCRIPTION="Eukaryotic gene predictor"
HOMEPAGE="https://bioinf.uni-greifswald.de/augustus/"
SRC_URI="https://github.com/Gaius-Augustus/Augustus/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P^}"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-db/sqlite:3
	dev-db/mysql++:=
	dev-db/mysql-connector-c:=
	dev-libs/boost:=[zlib]
	sci-biology/bamtools:=
	sci-biology/samtools:0
	sci-libs/gsl:=
	sci-libs/htslib:=
	sci-libs/suitesparse
	sci-mathematics/lpsolve
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

src_compile() {
	tc-export CC CXX

	emake LINK.cc="$(tc-getCXX)"

	docs_compile
}

src_install() {
	einstalldocs
	# from upstream Makefile install:
	dodir "opt/${P}"
	cp -a config bin scripts "${ED}/opt/${P}" || die
	local file
	for file in bin/*; do
		dosym "../${P}/${file}" "/opt/${file}"
	done
}
