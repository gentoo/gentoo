# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
if [[ ${PV} != 9999 ]]; then
	inherit cmake-utils depend.apache eutils systemd toolchain-funcs user wxwidgets
	SRC_URI="https://github.com/Icinga/icinga2/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
else
	inherit cmake-utils depend.apache eutils git-r3 systemd toolchain-funcs user wxwidgets
	EGIT_REPO_URI="https://github.com/Icinga/icinga2.git"
	EGIT_BRANCH="master"
fi

DESCRIPTION="Distributed, general purpose, network monitoring engine"
HOMEPAGE="http://icinga.org/icinga2"

LICENSE="GPL-2"
SLOT="0"
IUSE="+mysql postgres classicui console libressl lto mail minimal nano-syntax +plugins studio +vim-syntax"
WX_GTK_VER="3.0"

CDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	>=dev-libs/boost-1.58-r1
	console? ( dev-libs/libedit )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql:= )"

DEPEND="
	${CDEPEND}
	sys-devel/bison
	>=sys-devel/flex-2.5.35"

RDEPEND="
	${CDEPEND}
	plugins? ( || (
		net-analyzer/monitoring-plugins
		net-analyzer/nagios-plugins
	) )
	mail? ( virtual/mailx )
	classicui? ( net-analyzer/icinga[web] )
	studio? ( x11-libs/wxGTK:3.0 )"

REQUIRED_USE="!minimal? ( || ( mysql postgres ) )"

PATCHES=(
)

want_apache2

pkg_setup() {
	depend.apache_pkg_setup
	if use studio ; then
		setup-wxwidgets
	fi
	enewgroup icinga
	enewgroup icingacmd
	enewgroup nagios  # for plugins
	enewuser icinga -1 -1 /var/lib/icinga2 "icinga,icingacmd,nagios"
}

src_configure() {
	sed -i 's/FLAGS\}\ \-g/FLAGS\}\ \-lpthread\ /g' CMakeLists.txt || die
	local mycmakeargs=(
		-DICINGA2_UNITY_BUILD=FALSE
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_BUILD_TYPE=None
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
		-DCMAKE_INSTALL_LOCALSTATEDIR=/var
		-DICINGA2_SYSCONFIGFILE=/etc/conf.d/icinga2
		-DICINGA2_PLUGINDIR="/usr/$(get_libdir)/nagios/plugins"
		-DICINGA2_USER=icinga
		-DICINGA2_GROUP=icingacmd
		-DICINGA2_COMMAND_GROUP=icingacmd
		-DINSTALL_SYSTEMD_SERVICE_AND_INITSCRIPT=yes
		-DLOGROTATE_HAS_SU=ON
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
	# LTO
	if use lto; then
		mycmakeargs+=(
			-DICINGA2_LTO_BUILD=ON
		)
	else
		mycmakeargs+=(
			-DICINGA2_LTO_BUILD=OFF
		)
	fi
	# STUDIO
	if use studio; then
		mycmakeargs+=(
			-DICINGA2_WITH_STUDIO=ON
		)
	else
		mycmakeargs+=(
			-DICINGA2_WITH_STUDIO=OFF
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

	fowners root:icinga /etc/icinga2
	fperms 0750 /etc/icinga2
	fowners icinga:icinga /var/lib/icinga2
	fowners icinga:icinga /var/spool/icinga2
	fowners -R icinga:icingacmd /var/lib/icinga2/api
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
	if [[ ${PV} != 9999 && -n ${REPLACING_VERSIONS} && ${REPLACING_VERSIONS} != ${PV} ]]; then
		elog "DB IDO schema upgrade may be required required.
		http://docs.icinga.org/icinga2/snapshot/doc/module/icinga2/chapter/upgrading-icinga-2"
	fi
}
