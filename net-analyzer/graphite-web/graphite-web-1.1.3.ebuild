# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit distutils-r1 python-utils-r1 prefix

DESCRIPTION="Enterprise scalable realtime graphing"
HOMEPAGE="https://graphiteapp.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+carbon mysql memcached postgres +sqlite"
#ldap - needs bump of python-ldap to latest
# ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )

DEPEND=""
RDEPEND="
	carbon? ( dev-python/carbon[${PYTHON_USEDEP}] )
	mysql? (
		|| (
			dev-python/mysql-python[${PYTHON_USEDEP}]
			dev-python/mysqlclient[${PYTHON_USEDEP}]
		)
	)
	memcached? ( dev-python/python-memcached[${PYTHON_USEDEP}] )
	postgres? (
		dev-python/psycopg:2[${PYTHON_USEDEP}]
	)
	dev-lang/python[sqlite?]
	dev-python/cairocffi[${PYTHON_USEDEP}]
	>=dev-python/django-1.8[sqlite?,${PYTHON_USEDEP}]
	<dev-python/django-1.11.99[sqlite?,${PYTHON_USEDEP}]
	>=dev-python/django-tagging-0.4.3[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/scandir[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/txAMQP[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	dev-python/whisper[${PYTHON_USEDEP}]
	media-libs/fontconfig"

PATCHES=(
	# Do not install the configuration and data files. We install them
	# somewhere sensible by hand.
	"${FILESDIR}"/${PN}-1.1.3-fhs-paths.patch
)

src_prepare() {
	# use FHS-style paths
	export GRAPHITE_NO_PREFIX=yes
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
	# (missing from tarball)
	dodir /usr/bin
	cat > "${ED}"/usr/bin/${PN}-manage <<- EOS
		#!/usr/bin/env python
		import os
		import sys

		if __name__ == "__main__":
		    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "graphite.settings")

		    from django.core.management import execute_from_command_line

		    execute_from_command_line(sys.argv)
	EOS
	#mv "${D}"/$(python_get_sitedir)/graphite/manage.py \
	#	"${ED}"/usr/bin/${PN}-manage || die
	chmod 0755 "${ED}"/usr/bin/${PN}-manage || die
	python_fix_shebang "${ED}"/usr/bin/${PN}-manage

	insinto /etc/${PN}
	newins webapp/graphite/local_settings.py.example local_settings.py
	pushd "${D}"/$(python_get_sitedir)/graphite > /dev/null || die
	ln -s ../../../../../etc/${PN}/local_settings.py local_settings.py
	popd > /dev/null || die

	insinto /usr/share/doc/${PF}/examples
	doins \
		examples/example-graphite-vhost.conf \
		conf/dashboard.conf.example \
		conf/graphite.wsgi.example
}

pkg_config() {
	"${ROOT}"/usr/bin/${PN}-manage syncdb --noinput
	local idx=$(grep 'INDEX_FILE =' "${EROOT}"/etc/graphite-web/local_settings.py 2>/dev/null)
	if [[ -n ${idx} ]] ; then
		idx=${idx##*=}
		idx=$(echo ${idx})
		eval "idx=${idx}"
		touch "${ROOT}"/"${idx}"/index
	fi
}

pkg_postinst() {
	einfo "You need to configure ${PN} to run with a WSGI server of your choice."
	einfo "Don't forget to edit local_settings.py in ${EPREFIX}/etc/${PN}"
	einfo "See http://graphite.readthedocs.org/en/latest/config-local-settings.html"
	einfo "Run emerge --config =${PN}-${PVR} if this is a fresh install."
}
