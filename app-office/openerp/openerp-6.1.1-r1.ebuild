# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/openerp/openerp-6.1.1-r1.ebuild,v 1.4 2014/12/28 14:59:12 titanofold Exp $

EAPI="3"
PYTHON_DEPEND="2"

inherit eutils distutils user

DESCRIPTION="Open Source ERP & CRM"
HOMEPAGE="http://www.openerp.com/"
FNAME="${PN}-6.1-1"
SRC_URI="http://nightly.openerp.com/6.1/releases/${FNAME}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="postgres ldap ssl"

CDEPEND="postgres? ( dev-db/postgresql[server] )
	dev-python/lxml
	dev-python/psycopg:2
	dev-python/pychart
	dev-python/reportlab
	media-gfx/pydot
	dev-python/vobject
	dev-python/mako
	dev-python/pyyaml
	dev-python/Babel
	dev-python/gdata
	ldap? ( dev-python/python-ldap )
	dev-python/python-openid
	dev-python/werkzeug
	dev-python/xlwt
	dev-python/feedparser
	dev-python/python-dateutil
	dev-python/pywebdav
	ssl? ( dev-python/pyopenssl )
	dev-python/vatnumber
	dev-python/zsi"

RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

OPENERP_USER="openerp"
OPENERP_GROUP="openerp"

S="${WORKDIR}/${FNAME}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-6.1-setup.py.patch"
}

src_install() {
	distutils_src_install

	doinitd "${FILESDIR}/${PN}-2" "${PN}"
	newconfd "${FILESDIR}/openerp-confd-2" "${PN}"
	keepdir /var/log/openerp

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/openerp.logrotate openerp || die
	dodir /etc/openerp
	insinto /etc/openerp
	newins "${FILESDIR}"/openerp.cfg openerp.cfg || die
}

pkg_preinst() {
	enewgroup ${OPENERP_GROUP}
	enewuser ${OPENERP_USER} -1 -1 -1 ${OPENERP_GROUP}

	fowners ${OPENERP_USER}:${OPENERP_GROUP} /var/run/openerp
	fowners ${OPENERP_USER}:${OPENERP_GROUP} /var/log/openerp
	fowners -R ${OPENERP_USER}:${OPENERP_GROUP} "$(python_get_sitedir)/${PN}/addons/"

	use postgres || sed -i '6,8d' "${D}/etc/init.d/openerp" || die "sed failed"
}

pkg_postinst() {
	chown ${OPENERP_USER}:${OPENERP_GROUP} /var/run/openerp
	chown ${OPENERP_USER}:${OPENERP_GROUP} /var/log/openerp
	chown -R ${OPENERP_USER}:${OPENERP_GROUP} "$(python_get_sitedir)/${PN}/addons/"

	elog "In order to setup the initial database, run:"
	elog " emerge --config =${CATEGORY}/${PF}"
	elog "Be sure the database is started before"
}

pquery() {
	psql -q -At -U postgres -d template1 -c "$@"
}

pkg_config() {
	einfo "In the following, the 'postgres' user will be used."
	if ! pquery "SELECT usename FROM pg_user WHERE usename = '${OPENERP_USER}'" | grep -q ${OPENERP_USER}; then
		ebegin "Creating database user ${OPENERP_USER}"
		createuser --username=postgres --createdb --no-adduser ${OPENERP_USER}
		eend $? || die "Failed to create database user"
	fi
}
