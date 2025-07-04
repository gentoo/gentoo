# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1

MY_PV="${PV:0:4}-${PV:4:2}-${PV:6:2}"
MY_PN="Limnoria"
MY_P="${MY_PN}-${MY_PV}"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/ProgVal/${MY_PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ProgVal/${MY_PN}/archive/master-${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-master-${MY_PV}"
	KEYWORDS="~amd64 ~riscv ~x86"
fi

DESCRIPTION="Python based extensible IRC infobot and channel bot"
HOMEPAGE="https://docs.limnoria.net"
LICENSE="BSD GPL-2 GPL-2+"
SLOT="0"
IUSE="crypt ssl"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pysocks[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	crypt? ( dev-python/python-gnupg[${PYTHON_USEDEP}] )
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# replace "installed on ${timestamp}" with real version
	echo "version='${MY_PV//-/.}'" > "${S}"/src/version.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	PLUGINS_DIR="${BUILD_DIR}/build/lib/supybot/plugins"
	# intermittent failure due to issues loading libsandbox.so from LD_PRELOAD
	# runs successfully when running the tests on the installed system
	EXCLUDE_PLUGINS=(
		--exclude="${PLUGINS_DIR}/Unix"
		--exclude="${PLUGINS_DIR}/Aka"
		--exclude="${PLUGINS_DIR}/Misc"
	)

	"${EPYTHON}" "${BUILD_DIR}/install/usr/bin/supybot-test" \
		--plugins-dir="${PLUGINS_DIR}" --no-network \
		--disable-multiprocessing "${EXCLUDE_PLUGINS[@]}" \
		"${S}/test" \
		|| die "Tests failed under ${EPYTHON}"
}

pkg_postinst() {
	elog "Complete user documentation is available at https://limnoria-doc.readthedocs.io/"
	elog ""
	elog "Use supybot-wizard to create a configuration file."
	elog "Run supybot </path/to/config> to use the bot."
}
