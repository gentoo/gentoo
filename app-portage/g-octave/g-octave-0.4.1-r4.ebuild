# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5 *-jython"

DB_COMMIT="bdf02cbf0a8d017c6c1bddeffd6f03d5d90695ed"
DB_DIR="rafaelmartins-${PN}-db-${DB_COMMIT:0:7}"

inherit distutils eutils

DESCRIPTION="A tool that generates and installs ebuilds for Octave-Forge"
HOMEPAGE="https://github.com/rafaelmartins/g-octave"

SRC_URI="mirror://github/rafaelmartins/${PN}/${P}.tar.gz
	https://github.com/rafaelmartins/${PN}-db/tarball/${DB_COMMIT} ->
		${PN}-db-${DB_COMMIT:0:7}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="doc? ( >=dev-python/sphinx-1.0 )"
RDEPEND="sys-apps/portage"

PYTHON_MODNAME="g_octave"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-add_cave_support.patch"
	epatch "${FILESDIR}/${P}-fix-sourceforge-svn-root.patch"
	epatch "${FILESDIR}/${P}-fix-Makefile.patch"
	sed -i -e 's/^has_fetch.*$/has_fetch = False/' scripts/g-octave \
		|| die 'failed to patch the g-octave main script'
}

src_compile() {
	distutils_src_compile
	if use doc; then
		emake -C docs html || die 'failed to compile the documentation.'
	fi
}

src_install() {
	distutils_src_install
	dohtml ${PN}.html || die 'dohtml failed.'
	doman ${PN}.1 || die 'doman failed.'
	if use doc; then
		mv docs/_build/{html,sphinx} || die 'mv failed.'
		dohtml -r docs/_build/sphinx || die 'dohtml failed.'
	fi
}

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" \
			scripts/run_tests.py || die 'test failed.'
	}
	python_execute_function testing
}

pkg_postinst() {
	distutils_pkg_postinst
	elog
	elog 'To be able to use g-octave with the shipped package database, please'
	elog 'edit your configuration file, clean your db directory and run:'
	elog "    emerge --config =${PF}"
	elog
	elog "If you are upgrading from =${PN}-0.3, please read this:"
	elog "http://g-octave.readthedocs.org/en/latest/upgrading/#from-0-3-to-0-4"
	elog
	elog 'Please install the package manager that you want to use before run g-octave'
	elog
}

pkg_config() {
	local db="$(g-octave --config db)"
	mkdir -p "${db}"
	einfo "Extracting g-octave database files to: ${db}"
	tar -xzf "${DISTDIR}/${PN}-db-${DB_COMMIT:0:7}.tar.gz" -C "${db}" || die 'tar failed.'
	rm -rf "${db}"/{patches,octave-forge,info.json,manifest.json,timestamp}
	mv -f "${db}/${DB_DIR}"/* "${db}" || die 'mv failed.'
	rm -rf "${db}/${DB_DIR}"
}
