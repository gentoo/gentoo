# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Python Documentation Utilities"
HOMEPAGE="http://docutils.sourceforge.net/ https://pypi.org/project/docutils"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD-2 GPL-3 public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="dev-python/pygments[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_compile_all() {
	# Generate html docs from reStructured text sources.

	# Place html4css1.css in base directory to ensure that the generated reference to it is correct.
	cp docutils/writers/html4css1/html4css1.css . || die

	cd tools || die
	"${EPYTHON}" buildhtml.py --input-encoding=utf-8 \
		--stylesheet-path=../html4css1.css, --traceback ../docs || die
}

python_test() {
	if python_is_python3; then
		pushd test3 > /dev/null || die
	else
		pushd test > /dev/null || die
	fi
	"${EPYTHON}" alltests.py || die "Testing failed with ${EPYTHON}"
	popd > /dev/null || die
}

python_install() {
	distutils-r1_python_install

	# Install tools.
	python_doscript tools/{buildhtml,quicktest}.py
}

install_txt_doc() {
	local doc="${1}"
	local dir="txt/$(dirname ${doc})"
	docinto "${dir}"
	dodoc "${doc}"
}

python_install_all() {
	local DOCS=( *.txt )
	local HTML_DOCS=( docs tools docutils/writers/html4css1/html4css1.css )

	distutils-r1_python_install_all

	local doc
	while IFS= read -r -d '' doc; do
		install_txt_doc "${doc}"
	done < <(find docs tools -name '*.txt' -print0)
}
