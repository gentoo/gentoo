# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DB_COMMIT="b48055c9b54ef4fb941a07eb3b763c868ef4e0ca"
DB_DIR="rafaelmartins-${PN}-db-${DB_COMMIT:0:7}"

DESCRIPTION="A tool that generates and installs ebuilds for Octave-Forge"
HOMEPAGE="https://github.com/rafaelmartins/g-octave"
SRC_URI="https://github.com/downloads/rafaelmartins/${PN}/${P}.tar.gz
	https://github.com/rafaelmartins/${PN}-db/archive/${DB_COMMIT}.tar.gz ->
		${PN}-db-${DB_COMMIT:0:7}.tar.gz
	https://dev.gentoo.org/~rafaelmartins/distfiles/${PN}-patches-${PV}-r7.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-apps/portage"

PATCHES=(
	"${WORKDIR}/${PN}-patches-${PV}-r7"
)

distutils_enable_sphinx docs

pkg_config() {
	local db="$(g-octave --config db)"
	mkdir -p "${db}" || die 'mkdir failed.'
	einfo "Extracting g-octave database files to: ${db}"
	tar -xzf "${EROOT}/usr/share/g-octave/${PN}-db-${DB_COMMIT:0:7}.tar.gz" -C "${db}" || die 'tar failed.'
	rm -r "${db}"/{patches,octave-forge,info.json,manifest.json,timestamp} || die 'rm db files failed.'
	mv "${db}/${DB_DIR}"/* "${db}" || die 'mv failed.'
	rm -r "${db}/${DB_DIR}" || die 'rm db dir failed.'
}

python_prepare_all() {
	sed -i -e 's/^has_fetch.*$/has_fetch = False/' scripts/g-octave \
		|| die 'failed to patch the g-octave main script'
	distutils-r1_python_prepare_all
}

python_install_all() {
	doman ${PN}.1
	insinto /usr/share/g-octave
	doins "${DISTDIR}"/${PN}-db-${DB_COMMIT:0:7}.tar.gz
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
