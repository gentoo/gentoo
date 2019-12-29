# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{5,6}} )  # 3.7 dropped due to dep-hell

inherit distutils-r1 prefix

DESCRIPTION="Enterprise scalable realtime graphing"
HOMEPAGE="https://graphiteapp.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+carbon ldap mysql memcached postgres +sqlite"

DEPEND=""
RDEPEND="
	carbon? ( dev-python/carbon[${PYTHON_USEDEP}] )
	ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )
	memcached? ( dev-python/python-memcached[${PYTHON_USEDEP}] )
	mysql? (
		|| (
			dev-python/mysql-python[${PYTHON_USEDEP}]
			dev-python/mysqlclient[${PYTHON_USEDEP}]
		)
	)
	postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
	>=dev-python/django-1.8[sqlite?,${PYTHON_USEDEP}]
	<dev-python/django-2.1.99[sqlite?,${PYTHON_USEDEP}]
	>=dev-python/django-tagging-0.4.6[${PYTHON_USEDEP}]
	dev-python/cairocffi[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/scandir[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	media-libs/fontconfig
"

PATCHES=(
	# Do not install the configuration and data files. We install them
	# somewhere sensible by hand.
	"${FILESDIR}"/${PN}-1.1.5-fhs-paths.patch
)

python_prepare_all() {
	# Use a less common name
	mv bin/build-index bin/${PN}-build-index || die
	# use FHS-style paths
	export GRAPHITE_NO_PREFIX=yes
	distutils-r1_python_prepare_all
	eprefixify \
		conf/graphite.wsgi.example \
		webapp/graphite/local_settings.py.example
}

python_install_all() {
	distutils-r1_python_install_all
	keepdir /var/{lib,log}/${PN}
	docinto examples
	docompress -x "/usr/share/doc/${PF}/examples"
	dodoc \
		examples/example-graphite-vhost.conf \
		conf/dashboard.conf.example \
		conf/graphite.wsgi.example
}

python_install() {
	distutils-r1_python_install \
		--install-data="${EPREFIX}"/usr/share/${PN}

	insinto /etc/${PN}
	newins webapp/graphite/local_settings.py.example local_settings.py
	pushd "${D}/$(python_get_sitedir)"/graphite > /dev/null || die
	ln -s ../../../../../etc/${PN}/local_settings.py local_settings.py || die
	popd > /dev/null || die
}

pkg_config() {
	"${EROOT}"/usr/bin/django-admin.py migrate \
		--settings=graphite.settings --run-syncdb
	"${EROOT}"/usr/bin/${PN}-build-index
}

pkg_postinst() {
	# Only display this for new installs
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "You need to configure ${PN} to run with a WSGI server of your choice."
		elog "For example using Apache, you can use www-apache/mod_wsgi,"
		elog "            using Nginx, you can use www-servers/uwsgi."
		elog "Don't forget to edit local_settings.py in ${EPREFIX}/etc/${PN}"
		elog "See https://graphite.readthedocs.org/en/latest/config-local-settings.html"
		elog "Run emerge --config =${PN}-${PVR} if this is a fresh install."
		elog ""
		elog "If you want to update the search index regularily, you should consider running"
		elog "the '${PN}-build-index' script in a crontab."
	fi
}
