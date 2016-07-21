# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
PYTHON_USE_WITH="xml"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit git-2 python

DESCRIPTION="Tools to work with layman-global.txt/repositories.xml like files"
HOMEPAGE="https://cgit.gentoo.org/proj/repositories-xml-format.git"
SRC_URI=""
EGIT_REPO_URI="git://anongit.gentoo.org/proj/repositories-xml-format.git
	https://anongit.gentoo.org/git/proj/repositories-xml-format.git"
EGIT_COMMIT="8c4d7440c6d47f7ed690edafb7c0af53742f3297"

if [[ ${PV} != 0_p20100322 ]]; then
	die 'Broken bump detected: same \${EGIT_COMMIT} again'
fi

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-portage/layman"

src_install() {
	abi_specific_install() {
		local code_dir="$(python_get_sitedir)"/layman/dbtools

		exeinto "${code_dir}"
		doexe write-repositories-xml.py || die "doexe failed"

		insinto "${code_dir}"
		doins layman/dbtools/*.py || die "doins failed"

		dodir /usr/bin
		dosym "${code_dir}"/write-repositories-xml.py /usr/bin/write-repositories-xml-${PYTHON_ABI} \
			|| die "dosym failed"
	}
	python_execute_function abi_specific_install

	python_generate_wrapper_scripts "${ED}usr/bin/write-repositories-xml"
}

pkg_postinst() {
	python_mod_optimize layman/dbtools
}

pkg_postrm() {
	python_mod_cleanup layman/dbtools
}
