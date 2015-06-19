# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/arm/arm-1.4.5.0_p20140714-r2.ebuild,v 1.5 2014/11/15 19:28:27 blueness Exp $

EAPI=5
PYTHON_COMPAT=(python2_7)
PYTHON_REQ_USE="ncurses"
inherit vcs-snapshot distutils-r1

DESCRIPTION="A ncurses-based status monitor for Tor relays"
HOMEPAGE="http://www.atagar.com/arm/"
COMMIT_ID="ac7923e31f52d3cf51b538ddf799162d67c04ecc"
SRC_URI="https://gitweb.torproject.org/arm.git/snapshot/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="test"

DEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=net-libs/stem-1.2.2_p20140718[${PYTHON_USEDEP}]
	net-misc/tor"

python_prepare_all() {
	sed -i -e "s/.version import VERSION/ import __version__ as VERSION/"\
		-e "s/, 'arm.cli'//"\
		-e "s/arm.cli/arm/g"\
		-e "s/'arm.stem'//"\
		-e "/gui/d"\
		-e "s/\"arm\/settings.cfg\",//"\
		-e "/install-purelib/d"\
		-e "/eggPath/d" setup.py || die
	sed -i -e "s/1.4.6_dev/${PV}/" arm/__init__.py || die
	sed -i -e "s/line.replace(/line.replace(u/" arm/util/ui_tools.py || die
	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install --docPath "${EPREFIX}"/usr/share/doc/${PF}
	# Workaround until setup.py is fixed upstream
	python_moduleinto arm
	python_domodule arm/config
	python_replicate_script "${ED}"/usr/bin/run_arm
}
python_install_all() {
	distutils-r1_python_install_all --docPath "${EPREFIX}"/usr/share/doc/${PF}
}

python_test() {
	${PYTHON} run_tests.py || die
}

pkg_postinst() {
	elog "Some graphing data issues have been noted in testing"
	elog "when run as root. It is not recommended to run arm as"
	elog "root until those issues have been isolated and fixed."
	elog
	elog "Trouble with graphs under app-misc/screen? Try:"
	elog 'TERM="rxvt-unicode" arm'
}
