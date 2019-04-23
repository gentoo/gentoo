# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )
inherit python-single-r1 user readme.gentoo-r1

DESCRIPTION="IP address and data center infrastructure management tool"
HOMEPAGE="https://github.com/digitalocean/netbox"
SRC_URI="https://github.com/digitalocean/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ldap webhooks"

RDEPEND=">=dev-python/django-2.1.5[${PYTHON_USEDEP}]
	>=dev-python/django-cors-headers-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/django-debug-toolbar-1.11[${PYTHON_USEDEP}]
	>=dev-python/django-filter-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/django-mptt-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/django-tables2-2.0.3[${PYTHON_USEDEP}]
	>=dev-python/django-taggit-0.23.0[${PYTHON_USEDEP}]
	>=dev-python/django-taggit-serializer-0.1.7[${PYTHON_USEDEP}]
	>=dev-python/django-timezone-field-3.0[${PYTHON_USEDEP}]
	>=dev-python/djangorestframework-3.9.0[${PYTHON_USEDEP}]
	>=dev-python/drf-yasg-1.14.0[${PYTHON_USEDEP},validation]
	>=dev-python/graphviz-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.10[${PYTHON_USEDEP}]
	>=dev-python/markdown-2.6.11[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.19[${PYTHON_USEDEP}]
	>=dev-python/pillow-5.3.0[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.7.6.1[${PYTHON_USEDEP}]
	>=dev-python/py-gfm-0.1.4[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.7.2[${PYTHON_USEDEP}]
	www-servers/gunicorn[${PYTHON_USEDEP}]
	ldap? ( >=dev-python/django-auth-ldap-1.7[${PYTHON_USEDEP}] )
	webhooks? ( dev-python/django-rq )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-no-pip.patch
	)

DISABLE_AUTOFORMATTING=YES
DOC_CONTENTS="
netbox is installed on your system. However, there are some manual steps
you need to complete.

If this is a new installation, please follow these instructions:

From the installation instructions [1], you need to configure postgres
ldap and webhooks if you want to use them.  Then, you need to
configure and install a web server. Gunicorn is already installed, so
skip that step.

Once that is done, you should be able to add the netbox service to the
default runlevel and start it.

If you have webhooks turned on,  you should also add the netbox-rqworker
	to the default runlevel and start it.

The files you need to edit are located in /etc/netbox, not /opt/netbox,
as shown in the installation instructions.

If this is an upgrade, you just need to stop the netbox service,
	run the /opt/netbox/upgrade.sh script, check for new configuration
	options in the installation documentation [1] then restart the
	service.

[1] https://netbox.readthedocs.io/en/stable/installation/
"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /opt/${PN} ${PN}
}

src_install() {
	dodir /opt
	cp -a ../${P} "${ED}"/opt
	dosym ${P} /opt/netbox
dosym ../../etc/netbox/gunicorn_config.py /opt/netbox/gunicorn_config.py
	dosym ../../../../etc/netbox/configuration.py \
	/opt/netbox/netbox/netbox/configuration.py
	dodir /etc/netbox
	insinto /etc/netbox
	newins netbox/netbox/configuration.example.py configuration.py
	doins "${FILESDIR}"/gunicorn_config.py
	fowners -R netbox:netbox /etc/netbox
	fperms o= /etc/netbox/configuration.py /etc/netbox/gunicorn_config.py
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	use webhooks &&
		newinitd "${FILESDIR}"/${PN}-rqworker.initd ${PN}-rqworker
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
