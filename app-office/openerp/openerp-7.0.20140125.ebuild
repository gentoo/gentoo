# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit eutils distutils-r1 user

DESCRIPTION="Open Source ERP & CRM"
HOMEPAGE="http://www.openerp.com/"
MY_PV=${PV/7.0./7.0-}
FNAME="${PN}-${MY_PV}-002455"
SRC_URI="http://nightly.openerp.com/7.0/nightly/src/${FNAME}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+postgres ldap ssl"

CDEPEND="!app-office/openerp-web
	postgres? ( dev-db/postgresql[server] )
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/psycopg:2[${PYTHON_USEDEP}]
	dev-python/pychart[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/reportlab[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	media-gfx/pydot
	dev-python/vobject[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/gdata[${PYTHON_USEDEP}]
	ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )
	dev-python/python-openid[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	dev-python/xlwt[${PYTHON_USEDEP}]
	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pywebdav[${PYTHON_USEDEP}]
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	dev-python/vatnumber[${PYTHON_USEDEP}]
	dev-python/zsi[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/unittest2[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pillow[jpeg,${PYTHON_USEDEP}]
	${PYTHON_DEPS}
	"

RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

OPENERP_USER="openerp"
OPENERP_GROUP="openerp"

S="${WORKDIR}/${FNAME}"

python_install_all() {
	distutils-r1_python_install_all

	newinitd "${FILESDIR}/${PN}-2" "${PN}"
	newconfd "${FILESDIR}/openerp-confd-2" "${PN}"
	keepdir /var/log/openerp

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/openerp.logrotate openerp
	dodir /etc/openerp
	insinto /etc/openerp
	newins "${FILESDIR}"/openerp.cfg.2 openerp.cfg

	# #453424 Fix error on /usr/openerp/import_xml.rng
	dosym /usr/${PN}/import_xml.rng $(python_get_sitedir)/${PN}/import_xml.rng

	# #453424 Fix error on /usr/openerp/addons/base/res/res_company_logo.png
	dosym /usr/${PN}/addons/base/res/res_company_logo.png $(python_get_sitedir)/${PN}/addons/base/res/res_company_logo.png
}

pkg_preinst() {
	enewgroup ${OPENERP_GROUP}
	enewuser ${OPENERP_USER} -1 -1 -1 ${OPENERP_GROUP}

	fowners -R ${OPENERP_USER}:${OPENERP_GROUP} /etc/openerp
	fowners ${OPENERP_USER}:${OPENERP_GROUP} /var/log/openerp
	fowners -R ${OPENERP_USER}:${OPENERP_GROUP} "$(python_get_sitedir)/${PN}/addons/"

	fperms 0640 /etc/openerp/openerp.cfg

	use postgres || sed -i '6,8d' "${D}/etc/init.d/openerp" || die "sed failed"
}

pkg_postinst() {
	chown -R ${OPENERP_USER}:${OPENERP_GROUP} /etc/openerp
	chown ${OPENERP_USER}:${OPENERP_GROUP} /var/log/openerp
	chown -R ${OPENERP_USER}:${OPENERP_GROUP} "$(python_get_sitedir)/${PN}/addons/"

	elog "In order to setup the initial database, run:"
	elog " emerge --config =${CATEGORY}/${PF}"
	elog "Be sure the database is started before"
}

psqlquery() {
	psql -q -At -U postgres -d template1 -c "$@"
}

pkg_config() {
	einfo "In the following, the 'postgres' user will be used."
	if ! psqlquery "SELECT usename FROM pg_user WHERE usename = '${OPENERP_USER}'" | grep -q ${OPENERP_USER}; then
		ebegin "Creating database user ${OPENERP_USER}"
		createuser --username=postgres --createdb --no-adduser ${OPENERP_USER}
		eend $? || die "Failed to create database user"
	fi
}
