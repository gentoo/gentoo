# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )
inherit python-single-r1 user readme.gentoo-r1

DESCRIPTION="IP address and data center infrastructure management tool"
HOMEPAGE="https://github.com/netbox-community/netbox"
SRC_URI="https://github.com/netbox-community/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ldap webhooks"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/django-2.2[${PYTHON_USEDEP}]
	>=dev-python/django-cacheops-4.1[${PYTHON_USEDEP}]
	>=dev-python/django-cors-headers-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/django-debug-toolbar-2.0[${PYTHON_USEDEP}]
	>=dev-python/django-filter-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/django-mptt-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/django-prometheus-1.0.15[${PYTHON_USEDEP}]
	>=dev-python/django-tables2-2.0.6[${PYTHON_USEDEP}]
	>=dev-python/django-taggit-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/django-taggit-serializer-0.1.7[${PYTHON_USEDEP}]
	>=dev-python/django-timezone-field-3.0[${PYTHON_USEDEP}]
	>=dev-python/djangorestframework-3.9.4[${PYTHON_USEDEP}]
	>=dev-python/drf-yasg-1.16.0[${PYTHON_USEDEP},validation]
	>=dev-python/graphviz-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.10.1[${PYTHON_USEDEP}]
	>=dev-python/markdown-2.6.11[${PYTHON_USEDEP}]
	<dev-python/markdown-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.19[${PYTHON_USEDEP}]
	>=dev-python/pillow-6.2.0[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.8.3[${PYTHON_USEDEP}]
	>=dev-python/py-gfm-0.1.4[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.8.2[${PYTHON_USEDEP}]
	www-servers/gunicorn[${PYTHON_USEDEP}]
	ldap? ( >=dev-python/django-auth-ldap-1.7[${PYTHON_USEDEP}] )
	webhooks? ( >=dev-python/django-rq-2.1.0[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.7-no-pip.patch
	)

DISABLE_AUTOFORMATTING=YES
DOC_CONTENTS="
netbox is installed on your system. However, there are some manual steps
you need to complete from the installation guide [1].

On Gentoo, the configuration files you need to edit are located in
/etc/netbox, not /opt/netbox as shown in the installation guide.

If this is a new installation, please follow the installation guide
other than this difference. Also, if you need ldap or webhooks, set the
appropriate use flags when you emerge netbox to install the
dependencies.

Once that is done, you should be able to add the netbox service to the
default runlevel and start it.

If you have webhooks turned on,  you should also add the netbox-rqworker
service to the default runlevel and start it.

If this is an upgrade, follow these instructions:

Stop the netbox service. If the  netbox-rqworker service is running,
stop it as well.

Next, run the upgrade script as described in the upgrading guide[2].

Next, check for new configuration options and set them as appropriate
for your system.

Next, start the netbox service.

Finally, if you are using webhooks, start the netbox-rqworker service.

[1] https://netbox.readthedocs.io/en/stable/installation/
[2] https://netbox.readthedocs.io/en/stable/installation/upgrading/
"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
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
	fowners -R netbox:netbox /etc/netbox /opt/${P}
	fowners -h netbox:netbox /opt/netbox
	fperms o= /etc/netbox/configuration.py /etc/netbox/gunicorn_config.py
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	use webhooks &&
		newinitd "${FILESDIR}"/${PN}-rqworker.initd ${PN}-rqworker
	keepdir /var/log/netbox
	fowners -R netbox:netbox /var/log/netbox
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	local r
	for r in $REPLACING_VERSIONS; do
		if [[ $r = "2.5.10" ]]; then
			ewarn "The home directory of the netbox user is now /var/lib/netbox"
			ewarn "Please adjust your system."
		fi
	done
}
