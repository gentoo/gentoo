# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISABLE_AUTOFORMATTING=true
PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=hatchling
inherit desktop readme.gentoo-r1 distutils-r1

DESCRIPTION="Elog viewer for Gentoo"
HOMEPAGE="https://github.com/Synss/elogviewer"
SRC_URI="https://github.com/Synss/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~riscv ~x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pyqt6[gui,widgets,${PYTHON_USEDEP}]
		sys-apps/portage[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			dev-python/pyfakefs[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-qt[${PYTHON_USEDEP}]
		')
	)
"

DOC_CONTENTS="In order to use this software, you need to activate
Portage's elog features.  Required is
	PORTAGE_ELOG_SYSTEM=\"save\"
and at least one of
	PORTAGE_ELOG_CLASSES=\"warn error info log qa\"
More information on the elog system can be found in
/usr/share/portage/config/make.conf.example

To operate properly this software needs the directory
${PORT_LOGDIR:-/var/log/portage}/elog created, belonging to group portage.
To start the software as a user, add yourself to the portage group."

python_test() {
	export PYTEST_QT_API=pyqt6
	local -x QT_QPA_PLATFORM=offscreen
	epytest
}

python_install() {
	default
	distutils-r1_python_install
	make_desktop_entry --eapi9 ${PN} -c System
	doman man/elogviewer.1
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
