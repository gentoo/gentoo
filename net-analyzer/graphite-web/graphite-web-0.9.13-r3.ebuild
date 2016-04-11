# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 python-utils-r1 prefix

DESCRIPTION="Enterprise scalable realtime graphing"
HOMEPAGE="http://graphite.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://raw.githubusercontent.com/graphite-project/graphite-web/522d84fed687bd946878e48d85982d59f7bd1267/webapp/content/img/share.png -> ${P}-share.png"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+carbon ldap mysql memcached postgres +sqlite"

DEPEND=""
RDEPEND="
	dev-lang/python[sqlite?]
	sqlite? ( >=dev-python/django-1.4[sqlite?,${PYTHON_USEDEP}] )
	mysql? ( >=dev-python/django-1.4[${PYTHON_USEDEP}]
		|| (
			dev-python/mysql-python[${PYTHON_USEDEP}]
			dev-python/mysqlclient[${PYTHON_USEDEP}]
		)
	)
	postgres? (
		>=dev-python/django-1.4[${PYTHON_USEDEP}]
		dev-python/psycopg:2[${PYTHON_USEDEP}]
	)
	>=dev-python/twisted-core-10.0[${PYTHON_USEDEP}]
	>=dev-python/django-tagging-0.3.1[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/txAMQP[${PYTHON_USEDEP}]
	carbon? ( dev-python/carbon[${PYTHON_USEDEP}] )
	dev-python/whisper[${PYTHON_USEDEP}]
	media-libs/fontconfig
	memcached? ( dev-python/python-memcached[${PYTHON_USEDEP}] )
	ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )"

PATCHES=(
	# Do not install the configuration and data files. We install them
	# somewhere sensible by hand.
	"${FILESDIR}"/${P}-fhs-paths.patch
	"${FILESDIR}"/${P}-system-libs.patch
)

EXAMPLES=(
	examples/example-graphite-vhost.conf
	conf/dashboard.conf.example
	conf/graphite.wsgi.example
)

src_prepare() {
	# use FHS-style paths
	rm setup.cfg || die
	# make sure we don't use bundled stuff
	rm -Rf webapp/graphite/thirdparty
	distutils-r1_src_prepare
	eprefixify \
		conf/graphite.wsgi.example \
		webapp/graphite/local_settings.py.example
}

python_install() {
	distutils-r1_python_install \
		--install-data="${EPREFIX}"/usr/share/${PN}

	# make manage.py available from an easier location/name
	dodir /usr/bin
	mv "${D}"/$(python_get_sitedir)/graphite/manage.py \
		"${ED}"/usr/bin/${PN}-manage || die
	chmod 0755 "${ED}"/usr/bin/${PN}-manage || die
	python_fix_shebang "${ED}"/usr/bin/${PN}-manage

	# shortener image isn't included for some reason
	cp "${DISTDIR}"/"${P}"-share.png "${ED}"/usr/share/${PN}/webapp/content/img/

	insinto /etc/${PN}
	newins webapp/graphite/local_settings.py.example local_settings.py
	pushd "${D}"/$(python_get_sitedir)/graphite > /dev/null || die
	ln -s ../../../../../etc/${PN}/local_settings.py local_settings.py
	popd > /dev/null || die
}

pkg_config() {
	"${ROOT}"/usr/bin/${PN}-manage syncdb --noinput
	local idx=$(grep 'INDEX_FILE =' "${EROOT}"/etc/local_settings.py 2>/dev/null)
	if [[ -n ${idx} ]] ; then
		idx=${idx##*=}
		idx=$(echo ${idx})
		eval "idx=${idx}"
		touch "${ROOT}"/"${idx}"/index
	fi
}

pkg_postinst() {
	einfo "You will need to ${PN} it with Apache (mod_wsgi) or nginx (uwsgi)."
	einfo "Don't forget to edit local_settings.py in ${EPREFIX}/etc/${PN}"
	einfo "See http://graphite.readthedocs.org/en/latest/config-local-settings.html"
	einfo "Run emerge --config =${PN}-${PVR} if this is a fresh install."
}
