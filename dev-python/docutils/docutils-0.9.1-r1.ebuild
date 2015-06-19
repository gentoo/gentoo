# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/docutils/docutils-0.9.1-r1.ebuild,v 1.18 2015/04/08 08:05:08 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python Documentation Utilities"
HOMEPAGE="http://docutils.sourceforge.net/ http://pypi.python.org/pypi/docutils"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
SRC_URI+=" glep? ( mirror://gentoo/glep-0.4-r1.tbz2 )"

LICENSE="BSD-2 GPL-3 public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="glep"

RDEPEND="dev-python/pygments[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

GLEP_SRC="${WORKDIR}/glep-0.4-r1"

python_prepare_all() {
	# It's easier to move them around now.
	# TODO: add python_newmodule?
	if use glep; then
		mkdir "${GLEP_SRC}"/{read,trans} || die
		mv "${GLEP_SRC}"/{glepread,read/glep}.py || die
		mv "${GLEP_SRC}"/{glepstrans,trans/gleps}.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	# Generate html docs from reStructured text sources.

	# Place html4css1.css in base directory to ensure that the generated reference to it is correct.
	cp docutils/writers/html4css1/html4css1.css . || die

	cd tools || die
	"${PYTHON}" buildhtml.py --input-encoding=utf-8 \
		--stylesheet-path=../html4css1.css --traceback ../docs || die
}

python_test() {
	local tests=test
	[[ ${EPYTHON} == python3* ]] && tests=test3

	cp -r -l ${tests} "${BUILD_DIR}"/test || die
	ln -s "${S}"/docs "${BUILD_DIR}"/ || die
	"${PYTHON}" "${BUILD_DIR}"/test/alltests.py || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	# Install tools.
	python_doscript tools/{buildhtml,quicktest}.py

	# Install Gentoo GLEP tools.
	if use glep; then
		python_doscript "${GLEP_SRC}"/glep.py

		python_moduleinto docutils/readers
		python_domodule "${GLEP_SRC}"/read/glep.py
		python_moduleinto docutils/transforms
		python_domodule "${GLEP_SRC}"/trans/gleps.py
		python_moduleinto docutils/writers
		python_domodule "${GLEP_SRC}"/glep_html
	fi
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
