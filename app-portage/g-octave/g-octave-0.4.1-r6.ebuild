# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

DB_COMMIT="bdf02cbf0a8d017c6c1bddeffd6f03d5d90695ed"
DB_DIR="rafaelmartins-${PN}-db-${DB_COMMIT:0:7}"

inherit distutils-r1 eutils

DESCRIPTION="A tool that generates and installs ebuilds for Octave-Forge"
HOMEPAGE="https://github.com/rafaelmartins/g-octave"

SRC_URI="https://github.com/downloads/rafaelmartins/${PN}/${P}.tar.gz
	https://github.com/rafaelmartins/${PN}-db/tarball/${DB_COMMIT} ->
		${PN}-db-${DB_COMMIT:0:7}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="doc? ( >=dev-python/sphinx-1.0 )"
RDEPEND="sys-apps/portage"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${P}-add_cave_support.patch"
		"${FILESDIR}/${P}-fix-sourceforge-svn-root.patch"
		"${FILESDIR}/${P}-fix-Makefile.patch"
	)
	sed -i -e 's/^has_fetch.*$/has_fetch = False/' scripts/g-octave \
		|| die 'failed to patch the g-octave main script'
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
	fi
}

python_install_all() {
	local HTML_DOCS=( ${PN}.html )
	doman ${PN}.1
	if use doc; then
		mv docs/_build/{html,sphinx} || die 'mv failed.'
		HTML_DOCS+=( docs/_build/sphinx )
	fi
	distutils-r1_python_install_all
}

python_test() {
	"${EPYTHON}" scripts/run_tests.py || die 'test failed.'
}

pkg_postinst() {
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
	mkdir -p "${db}" || die 'mkdir failed.'
	einfo "Extracting g-octave database files to: ${db}"
	tar -xzf "${DISTDIR}/${PN}-db-${DB_COMMIT:0:7}.tar.gz" -C "${db}" || die 'tar failed.'
	rm -rf "${db}"/{patches,octave-forge,info.json,manifest.json,timestamp} || die 'rm db files failed.'
	mv -f "${db}/${DB_DIR}"/* "${db}" || die 'mv failed.'
	rm -rf "${db}/${DB_DIR}" || die 'rm db dir failed.'
}
