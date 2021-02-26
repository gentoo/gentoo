# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

MY_PV="${PV:0:4}-${PV:4:2}-${PV:6:2}"
MY_PN="Limnoria"
MY_P="${MY_PN}-${MY_PV}"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/ProgVal/${MY_PN}.git"
	EGIT_BRANCH="testing"
	inherit git-r3
else
	SRC_URI="https://github.com/ProgVal/${MY_PN}/archive/master-${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-master-${MY_PV}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Python based extensible IRC infobot and channel bot"
HOMEPAGE="https://docs.limnoria.net"
LICENSE="BSD GPL-2 GPL-2+"
SLOT="0"
IUSE="crypt ssl test"
RESTRICT=" !test? ( test )"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	crypt? ( dev-python/python-gnupg[${PYTHON_USEDEP}] )
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	!net-irc/supybot
	!net-irc/supybot-plugins"
BDEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"

python_prepare() {
	einfo "Removing the RSS plugin because of clashes between libxml2's Python3"
	einfo "bindings and feedparser."
	rm -r "plugins/RSS" || die
}

python_test() {
	pushd "${T}" > /dev/null || die
	PLUGINS_DIR="${BUILD_DIR}"/lib/supybot/plugins
	EXCLUDE_PLUGINS=()
	# intermittent failure due to issues loading libsandbox.so from LD_PRELOAD
	# runs successfully when running the tests on the installed system
	EXCLUDE_PLUGINS+=( --exclude="${PLUGINS_DIR}/Unix" )
	# Runs despite --no-network (GH #1392)
	EXCLUDE_PLUGINS+=( --exclude="${PLUGINS_DIR}/Aka" )
	"${EPYTHON}" "${BUILD_DIR}"/scripts/supybot-test "${BUILD_DIR}/../test" \
		--plugins-dir="${PLUGINS_DIR}" --no-network \
		--disable-multiprocessing "${EXCLUDE_PLUGINS[@]}" \
		|| die "Tests failed under ${EPYTHON}"
	popd > /dev/null || die
}

python_install_all() {
	distutils-r1_python_install_all
	doman man/*
}

pkg_postinst() {
	elog "Complete user documentation is available at https://limnoria-doc.readthedocs.org/"
	elog ""
	elog "Use supybot-wizard to create a configuration file."
	elog "Run supybot </path/to/config> to use the bot."
}
