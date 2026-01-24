# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 prefix

if [[ ${PV} = 9999* ]]
then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~ceamac/${CATEGORY}/${PN}/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

DESCRIPTION="Gentoo's installer for web-based applications"
HOMEPAGE="https://wiki.gentoo.org/wiki/Webapp-config"

LICENSE="GPL-2"
SLOT="0"
IUSE="+portage"

DEPEND="app-text/xmlto
	sys-apps/gentoo-functions"
RDEPEND="
	portage? ( sys-apps/portage[${PYTHON_USEDEP}] )"

python_prepare_all() {
	distutils-r1_python_prepare_all
	eprefixify WebappConfig/eprefix.py config/webapp-config
}

python_compile_all() {
	emake -C doc/
}

python_test() {
	PYTHONPATH="." "${EPYTHON}" WebappConfig/tests/external.py -v ||
		die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	# distutils-r1 installs the scripts in /usr/bin in PEP517 mode
	mv "${ED}"/usr/bin "${ED}"/usr/sbin || die "Cannot rename scripts directory to /usr/sbin"

	insinto /etc/vhosts
	doins config/webapp-config

	keepdir /usr/share/webapps
	keepdir /var/db/webapps

	dodoc AUTHORS
	doman doc/*.[58]
}

pkg_postinst() {
	elog "Now that you have upgraded webapp-config, you **must** update your"
	elog "config files in /etc/vhosts/webapp-config before you emerge any"
	elog "packages that use webapp-config."
}
