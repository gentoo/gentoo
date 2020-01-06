# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit python-single-r1

DESCRIPTION="Tool to produce LaTeX Beamer code from wiki-like input"

MY_P=wiki2beamer-v${PV}
HOMEPAGE="https://wiki2beamer.github.io/"
SRC_URI="https://github.com/wiki2beamer/wiki2beamer/archive/${MY_P}.tar.gz"

LICENSE="GPL-2+ FDL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( dev-ruby/asciidoctor )"

S="${WORKDIR}/wiki2beamer-${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-doc-examples-makefile.patch
	"${FILESDIR}"/${P}-doc-man-makefile.patch
)

src_compile() {
	use doc && emake -C doc/man/ wiki2beamer.1
}

src_install() {
	use examples && dodoc -r doc/examples

	use doc && doman doc/man/${PN}.1
	dodoc ChangeLog README.md

	python_doscript code/${PN}
}
