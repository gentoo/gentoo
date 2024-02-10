# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Nagios addon to store Nagios data in a MySQL database"
HOMEPAGE="https://www.nagios.org/"
SRC_URI="https://github.com/NagiosEnterprises/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

# We require the "nagios" user from net-analyzer/nagios-core at build
# time.
DEPEND="
	dev-db/mysql-connector-c
	dev-perl/DBD-mysql
	dev-perl/DBI
	>=net-analyzer/nagios-core-4.4.5"
RDEPEND="${DEPEND}
	virtual/mysql"

PATCHES=(
	"${FILESDIR}"/format-security.patch
	"${FILESDIR}"/ndoutils-2.0.0-asprintf.patch
	"${FILESDIR}"/sample-config-piddir.patch
	"${FILESDIR}"/openrc-init.patch
)

src_configure() {
	# The localstatedir is where our socket will be created by the
	# nagios daemon, so we put it in /var/lib/nagios where the "nagios"
	# user will be able to write.
	#
	# And normally, we would use /run for the pid file, but the daemon
	# drops permissions before creating it, so the piddir also needs
	# to be writable by the nagios user.
	econf --enable-mysql \
		  --localstatedir=/var/lib/nagios \
		  --sysconfdir=/etc/nagios \
		  --with-piddir=/var/lib/nagios
}

src_compile() {
	# Avoid "emake all" so that we don't build the stuff for nagios-2.x
	# and nagios-3.x, some of which throws QA warnings. We don't use it
	# anyway.
	emake -C src file2sock log2ndo ndo2db-4x ndomod-4x.o sockdebug
}

src_install() {
	# The documentation isn't installed by the build system
	HTML_DOCS=( docs/html/. )
	default

	dodoc Changelog UPGRADING \
		"docs/NDOUTILS DB Model.pdf" "docs/NDOUtils Documentation.pdf"

	systemd_newunit startup/default-service ndoutils.service

	insinto /etc/nagios
	newins config/ndo2db.cfg-sample ndo2db.cfg
	newins config/ndomod.cfg-sample ndomod.cfg
	newinitd startup/openrc-init ndo2db
	newconfd startup/openrc-conf ndo2db

	insinto /usr/share/ndoutils
	doins -r db

	# These need to be executable...
	exeinto /usr/share/ndoutils/db
	doexe db/{installdb,prepsql,upgradedb}

	# Use symlinks because the installdb/upgradedb scripts use relative
	# paths to the SQL queries.
	dosym ../share/ndoutils/db/installdb /usr/bin/ndoutils-installdb
	dosym ../share/ndoutils/db/upgradedb /usr/bin/ndoutils-upgradedb

	keepdir /var/lib/nagios
}

pkg_postinst() {
	elog "To include NDO in your Nagios setup, you'll need to activate"
	elog "the NDO broker module in /etc/nagios/nagios.cfg:"
	elog "  broker_module=/usr/bin/ndomod.o config_file=/etc/nagios/ndomod.cfg"
}
