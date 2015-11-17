# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils depend.apache eutils systemd toolchain-funcs user

DESCRIPTION="Distributed, general purpose, network monitoring engine"
HOMEPAGE="http://icinga.org/icinga2"
SRC_URI="https://github.com/Icinga/icinga2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+mysql postgres classicui minimal nano-syntax +plugins +vim-syntax"

DEPEND="
	dev-libs/openssl:0
	>=dev-libs/boost-1.41
	sys-devel/bison
	>=sys-devel/flex-2.5.35
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql:= )"

RDEPEND="
	${DEPEND}
	plugins? ( || (
		net-analyzer/monitoring-plugins
		net-analyzer/nagios-plugins
	) )
	classicui? ( net-analyzer/icinga[web] )"

REQUIRED_USE="!minimal? ( || ( mysql postgres ) )"

want_apache2

pkg_setup() {
	depend.apache_pkg_setup
	enewgroup icinga
	enewgroup icingacmd
	enewgroup nagios  # for plugins
	enewuser icinga -1 -1 /var/lib/icinga2 "icinga,icingacmd,nagios"
}

src_configure() {
	local mycmakeargs=(
		-DICINGA2_UNITY_BUILD=FALSE
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_BUILD_TYPE=None
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
		-DCMAKE_INSTALL_LOCALSTATEDIR=/var
		-DICINGA2_SYSCONFIGFILE=/etc/conf.d/icinga2
		-DICINGA2_USER=icinga
		-DICINGA2_GROUP=icingacmd
		-DICINGA2_COMMAND_USER=icinga
		-DICINGA2_COMMAND_GROUP=icingacmd
		-DINSTALL_SYSTEMD_SERVICE_AND_INITSCRIPT=yes
	)
	# default to off if minimal, allow the flags to be set otherwise
	if use minimal; then
		mycmakeargs+=(
			-DICINGA2_WITH_MYSQL=OFF
			-DICINGA2_WITH_PGSQL=OFF
		)
	else
		mycmakeargs+=(
			-DICINGA2_WITH_PGSQL=$(usex postgres ON OFF)
			-DICINGA2_WITH_MYSQL=$(usex mysql ON OFF)
		)
	fi
	cmake-utils_src_configure
}

src_install() {
	BUILDDIR="${WORKDIR}"/icinga2-${PV}_build
	cd "${BUILDDIR}" || die

	emake DESTDIR="${D}" install

	einstalldocs

	newinitd "${FILESDIR}"/icinga2.initd icinga2
	newconfd "${FILESDIR}"/icinga2.confd icinga2

	if use mysql ; then
		docinto schema
		newdoc "${WORKDIR}"/icinga2-${PV}/lib/db_ido_mysql/schema/mysql.sql mysql.sql
		docinto schema/upgrade
		dodoc "${WORKDIR}"/icinga2-${PV}/lib/db_ido_mysql/schema/upgrade/*
	elif use postgres ; then
		docinto schema
		newdoc "${WORKDIR}"/icinga2-${PV}/lib/db_ido_pgsql/schema/pgsql.sql pgsql.sql
		docinto schema/upgrade
		dodoc "${WORKDIR}"/icinga2-${PV}/lib/db_ido_pgsql/schema/upgrade/*
	fi

	keepdir /etc/icinga2
	keepdir /var/lib/icinga2/api/zones
	keepdir /var/lib/icinga2/api/repository
	keepdir /var/lib/icinga2/api/log
	keepdir /var/spool/icinga2/perfdata

	rm -r "${D}/var/run" || die "failed to remove /var/run"
	rm -r "${D}/var/cache" || die "failed to remove /var/cache"

	fowners icinga:icinga /etc/icinga2
	fowners icinga:icinga /var/lib/icinga2
	fowners icinga:icinga /var/spool/icinga2
	fowners icinga:icinga /var/spool/icinga2/perfdata
	fowners icinga:icingacmd /var/log/icinga2

	fperms ug+rwX,o-rwx /etc/icinga2
	fperms ug+rwX,o-rwx /var/lib/icinga2
	fperms ug+rwX,o-rwx /var/spool/icinga2
	fperms ug+rwX,o-rwx /var/log/icinga2

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles
		doins -r "${WORKDIR}"/${P}/tools/syntax/vim/ftdetect
		doins -r "${WORKDIR}"/${P}/tools/syntax/vim/syntax
	fi

	if use nano-syntax; then
		insinto /usr/share/nano
		doins "${WORKDIR}"/${P}/tools/syntax/nano/icinga2.nanorc
	fi
}

pkg_postinst() {
	elog "DB IDO schema upgrade required. http://docs.icinga.org/icinga2/snapshot/chapter-2.html#upgrading-the-mysql-database"
	elog "You will need to update your configuration files, see https://dev.icinga.org/issues/5909"
}
