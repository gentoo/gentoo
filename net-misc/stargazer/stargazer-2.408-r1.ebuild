# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PROJECTS="sgconv rlm_stg rscriptd sgauth sgconf sgconf_xml stargazer"

STG_MODULES_AUTH="always_online internet_access freeradius"
STG_MODULES_CAPTURE="ipq ether netflow"
STG_MODULES_CONFIG="sgconfig rpcconfig"
STG_MODULES_OTHER="ping smux remote_script"
STG_MODULES_STORE="files firebird mysql postgres"

declare -A MODULES
MODULES=( [module_auth_always_online]="authorization\/ao:mod_ao"
	[module_auth_internet_access]="authorization\/inetaccess:mod_ia"
	[module_auth_freeradius]="other\/radius:mod_radius"
	[module_capture_ipq]="capture\/ipq_linux:mod_cap_ipq"
	[module_capture_ether]="capture\/ether_linux:mod_cap_ether"
	[module_capture_netflow]="capture\/cap_nf:mod_cap_nf"
	[module_config_sgconfig]="configuration\/sgconfig:mod_sg"
	[module_config_rpcconfig]="configuration\/rpcconfig:mod_rpc"
	[module_other_ping]="other\/ping:mod_ping"
	[module_other_smux]="other\/smux:mod_smux"
	[module_other_remote_script]="other\/rscript:mod_remote_script"
	[module_store_files]="store\/files:store_files"
	[module_store_firebird]="store\/firebird:store_firebird"
	[module_store_mysql]="store\/mysql:store_mysql"
	[module_store_postgres]="store\/postgresql:store_postgresql"
)

declare -A INIT
INIT=(	[module_store_files]="11d"
	[module_store_firebird]="11d;s/need net/need net firebird/"
	[module_store_mysql]="11d;s/need net/need net mysql/"
	[module_store_postgres]="11d;s/need net/need net postgresql/"
)

MY_P="stg-${PV}"

inherit flag-o-matic linux-info user

DESCRIPTION="Billing system for small home and office networks"
HOMEPAGE="http://stg.dp.ua/"
SRC_URI="http://stg.dp.ua/download/server/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	module_config_rpcconfig? (
		dev-libs/expat
		dev-libs/xmlrpc-c[abyss,cxx]
	)
	module_config_sgconfig? ( dev-libs/expat )
	module_store_firebird? ( dev-db/firebird )
	module_store_mysql? ( dev-db/mysql-connector-c:0= )
	module_store_postgres? ( dev-db/postgresql:= )
	sgconf? ( dev-libs/expat )
	sgconf_xml? ( dev-libs/expat )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

REQUIRED_USE="stargazer? ( ^^ ( module_store_files module_store_firebird module_store_mysql module_store_postgres ) )"

DOCS=( BUGS ../../ChangeLog CHANGES README TODO )

# Patches already in upstream's trunk
PATCHES=(
	# Fix dependency on fbclient for module_store_firebird
	"${FILESDIR}"/patches/stg-2.408-makefile-firebird-upstream.patch
	# Rewrite config for rscriptd
	"${FILESDIR}"/patches/stg-2.408-rscriptd.conf-upstream.patch
	# Rewrite config for sgauth
	"${FILESDIR}"/patches/stg-2.408-sgauth.conf-upstream.patch
	# Standardization of 'On-scripts'
	"${FILESDIR}"/patches/stg-2.408-on-upstream.patch
	# Install demo scripts for rscriptd
	"${FILESDIR}"/patches/stg-2.408-rscriptd-upstream.patch
	# Fix crush on stop
	"${FILESDIR}"/patches/stg-2.408-fix-crash-on-stop.patch
	# Rename convertor to sgconv to avoid possible file name collisions
	"${FILESDIR}"/patches/stg-2.408-sgconv-upstream.patch
	# Debug support. Install radius lib to /usr/lib/freeradius
	"${FILESDIR}"/patches/stg-2.408-makefile-build-upstream.patch
	# Don't compile sgconv always with debug. Remove MAKEOPTS=-j1
	"${FILESDIR}"/patches/stg-2.408-build-upstream.patch
	# FreeBSD install directory
	"${FILESDIR}"/patches/stg-2.408-radius-upstream.patch
)

IUSE="sgconv radius rscriptd sgauth sgconf sgconf_xml stargazer debug"

for module in ${STG_MODULES_AUTH} ; do IUSE="${IUSE} module_auth_${module}" ; done
for module in ${STG_MODULES_CAPTURE} ; do IUSE="${IUSE} module_capture_${module}" ; done
for module in ${STG_MODULES_CONFIG} ; do IUSE="${IUSE} module_config_${module}" ; done
for module in ${STG_MODULES_OTHER} ; do IUSE="${IUSE} module_other_${module}" ; done
for module in ${STG_MODULES_STORE} ; do IUSE="${IUSE} module_store_${module}" ; done

IUSE=${IUSE/stargazer/+stargazer}
IUSE=${IUSE/module_store_files/+module_store_files}

src_prepare() {
	# Rename convertor to sgconv to avoid possible file name collisions
	mv projects/convertor/ projects/sgconv/ \
		|| die "Couldn't move convertor folder"
	mv projects/sgconv/convertor.conf \
		projects/sgconv/sgconv.conf || die "Couldn't move convertor config"

	default

	local project
	for project in ${PROJECTS} ; do
		# Rename build script to configure for further econf launch in every project
		mv projects/$project/build projects/$project/configure \
			|| die "Couldn't move build folder for $project"
		# Change check for debug build
		sed -i 's/if \[ "$1" = "debug" \]/if \[ "${10}" = "--enable-debug" \]/' \
			projects/$project/configure \
			|| die "sed for debug check failed"
	done

	# Correct working directory, user and group for sgconv.conf, store_files.conf
	# Correct paths for rscriptd.conf, store_firebird.conf, mod_remote_scriptd.conf, stargazer.conf, rpcconfig.cpp, 00-base-00.sql
	eapply "${FILESDIR}"/patches/stg-2.408-correct-paths.patch

	# Correct target install-data for stargazer, rscriptd, sgauth, remove debug symbols stripping
	eapply "${FILESDIR}"/patches/stg-2.408-makefile.patch

	# Remove make from script (for keeping symbols), always add variable to Makefile.conf for all projects
	eapply "${FILESDIR}"/patches/stg-2.408-build.patch

	# Remove static-libs
	eapply "${FILESDIR}"/patches/stg-2.408-static-libs.patch

	# Define which module to compile
	local module
	for module in ${!MODULES[@]} ; do
		if ! use $module ; then
			sed -i "s/${MODULES[$module]%:*}//" \
				projects/stargazer/configure \
				|| die "sed for module configure failed"
		fi
	done

	# Correct Gentoo init script
	sed -i	-e 's/opts/extra_commands/' \
		-e 's/runscript/openrc-run/' \
		projects/stargazer/inst/linux/etc/init.d/stargazer.gentoo \
		|| die "sed for init-script failed"
	local init
	for init in ${!INIT[@]} ; do
		if use $init ; then
			sed -i "${INIT[$init]}" \
				projects/stargazer/inst/linux/etc/init.d/stargazer.gentoo \
				|| die "sed for $init failed"
		fi
	done

	# Check for IPQ subsystem availability
	if use module_capture_ipq && kernel_is ge 3 5 ; then
		die "The IPQ subsystem requires kernel 3.5 or greater."
	fi
}

src_configure() {
	use debug && filter-flags '-O?'

	# Define local variables, strip '+' symbol for used by default USE flags
	local USEFLAGS=(${IUSE//+})
	local PROJECTS=($PROJECTS)
	local i

	for (( i = 0 ; i < ${#PROJECTS[@]} ; i++ )) ; do
		if use ${USEFLAGS[$i]} ; then
			cd "${S}"/projects/${PROJECTS[$i]} \
				|| die "cd to ${PROJECTS[$i]} failed"
			econf $(use_enable debug)
		fi
	done
}

src_compile() {
	# Define local variables, strip '+' symbol for used by default USE flags
	local USEFLAGS=(${IUSE//+})
	local PROJECTS=($PROJECTS)
	local i

	# Set jobs to 1 for debug build
	use debug && MAKEOPTS="-j1"

	# Build necessary libraries first
	touch Makefile.conf
	cd stglibs || die "cd to stglibs failed"
	emake STG_LIBS="ia.lib srvconf.lib"

	for (( i = 0 ; i < ${#PROJECTS[@]} ; i++ )) ; do
		if use ${USEFLAGS[$i]} ; then
			cd "${S}"/projects/${PROJECTS[$i]} \
				|| die "cd to ${PROJECTS[$i]} failed"
			emake
		fi
	done
}

src_install() {
	if use rscriptd || use stargazer ; then
		# Install config file for logrotate
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/logrotate stargazer

		# Keeping logs directory
		diropts -m 755 -o stg -g stg
		keepdir /var/log/stargazer
		if use stargazer ; then
			diropts -m 775 -o stg -g stg
			keepdir /var/lib/stargazer
		fi
	fi

	if use sgconv ; then
		cd projects/sgconv || die "cd to sgconv failed"

		emake DESTDIR="${D}" PREFIX="${D}" install

		# Install files into specified directory
		insinto /etc/stargazer
		doins "${S}"/projects/sgconv/sgconv.conf

		# Install manual page
		doman "${FILESDIR}"/mans/sgconv.1
	fi

	if use radius ; then
		cd "${S}"/projects/rlm_stg || die "cd to rlm_stg failed"

		emake DESTDIR="${D}" PREFIX="${D}" install
	fi

	if use rscriptd ; then
		cd "${S}"/projects/rscriptd || die "cd to rscriptd failed"

		emake DESTDIR="${D}" PREFIX="${D}" install

		# Install Gentoo init script
		doinitd "${FILESDIR}"/rscriptd

		# Correct permissions for file
		fperms 0640 /etc/stargazer/rscriptd.conf

		# Install manual page
		doman "${FILESDIR}"/mans/rscriptd.8
	fi

	if use sgauth ; then
		cd "${S}"/projects/sgauth || die "cd to sgauth failed"

		emake DESTDIR="${D}" PREFIX="${D}" install

		# Correct permissions for file
		fperms 0640 /etc/stargazer/sgauth.conf

		# Install manual page
		doman "${FILESDIR}"/mans/sgauth.8
	fi

	if use sgconf ; then
		cd "${S}"/projects/sgconf || die "cd to sgconf failed"

		emake DESTDIR="${D}" PREFIX="${D}" install

		# Install manual page
		doman "${FILESDIR}"/mans/sgconf.1
	fi

	if use sgconf_xml ; then
		cd "${S}"/projects/sgconf_xml || die "cd to sgconf_xml failed"

		emake DESTDIR="${D}" PREFIX="${D}" install

		# Install manual page
		doman "${FILESDIR}"/mans/sgconf_xml.1
	fi

	if use stargazer ; then
		cd "${S}"/projects/stargazer || die "cd to stargazer failed"

		emake DESTDIR="${D}" PREFIX="${D}" install

		# Install docs
		einstalldocs

		# Install and rename Gentoo init script
		newinitd "${S}"/projects/stargazer/inst/linux/etc/init.d/stargazer.gentoo stargazer

		# Install manual page
		doman "${FILESDIR}"/mans/stargazer.8

		# Install files needed for module_store_files
		if use module_store_files ; then
			# Install files into specified directory
			insinto /var/lib
			doins -r "${S}"/projects/stargazer/inst/var/stargazer

			# Correct user and group for files and directories
			fowners -R stg:stg /var/lib/stargazer
		fi

		if use module_store_firebird ; then
			# Install files into specified directory
			insinto /usr/share/stargazer/db/firebird
			doins \
				"${S}"/projects/stargazer/inst/var/00-base-00.sql \
				"${S}"/projects/stargazer/inst/var/00-alter-01.sql
		fi

		if use module_store_mysql ; then
			# Install file into specified directory
			insinto /usr/share/stargazer/db/mysql
			doins "${S}"/projects/stargazer/inst/var/00-mysql-01.sql
		fi

		if use module_store_postgres ; then
			# Install files into specified directory
			insinto /usr/share/stargazer/db/postgresql
			doins \
				"${S}"/projects/stargazer/inst/var/00-base-00.postgresql.sql \
				"${S}"/projects/stargazer/inst/var/00-alter-01.postgresql.sql
		fi

		if use module_other_smux ; then
			# Install files into specified directory
			insinto /usr/share/snmp/mibs
			doins "${S}"/projects/stargazer/plugins/other/smux/STG-MIB.mib
		fi

		if use module_other_remote_script ; then
			# Create subnets file based on example from mod_remote_script.conf
			grep 192 "${S}"/projects/stargazer/inst/linux/etc/stargazer/conf-available.d/mod_remote_script.conf \
				| sed 's/# //' > "${ED}"/etc/stargazer/subnets

			# Correct permissions for file
			fperms 0640 /etc/stargazer/subnets
		fi

		# Correct permissions for files
		fperms 0640 \
			/etc/stargazer/rules \
			/etc/stargazer/stargazer.conf

		# Install files into specified directory for selected modules
		insinto /etc/stargazer/conf-available.d
		insopts -m 0640

		local module
		for module in ${!MODULES[@]} ; do
			use $module && doins "${S}"/projects/stargazer/inst/linux/etc/stargazer/conf-available.d/${MODULES[$module]#*:}.conf
		done

		# Create symlinks of configs for selected modules
		for module in ${!MODULES[@]} ; do
			use $module \
				&& dosym \
				/etc/stargazer/conf-available.d/${MODULES[$module]#*:}.conf \
				/etc/stargazer/conf-enabled.d/${MODULES[$module]#*:}.conf
		done
	fi

	# Correct user and group for files and directories
	if use sgconv || use rscriptd || use sgauth || use stargazer ; then
		fowners -R stg:stg /etc/stargazer
	fi

	# Put the files in the right folder to support multilib
	if [ ! -e "${ED}"/usr/$(get_libdir) ] ; then
		mv "${ED}"/usr/lib/ "${ED}"/usr/$(get_libdir) \
			|| die "Failed to move library directory for multilib support"
	fi
}

pkg_setup() {
	# Add user and group to system only when necessary
	if use sgconv || use rscriptd || use sgauth || use stargazer ; then
		enewgroup stg
		enewuser stg -1 -1 -1 stg
	fi
}

pkg_postinst() {
	if use sgconv ; then
		einfo "\nSgconv:"
		einfo "----------"
		einfo "For further use edit /etc/stargazer/sgconv.conf."
	fi

	if use radius ; then
		einfo "\nRadius:"
		einfo "-------"
		einfo "For further use emerge net-dialup/freeradius.\n"

		einfo "Example config:\n"

		einfo "stg {"
		einfo "      local_port = 6667"
		einfo "      server = localhost"
		einfo "      port = 6666"
		einfo "      password = 123456"
		einfo "    }\n"

		einfo "You should place 'stg' into section Instantiate, Authorize."
		einfo "In section Authentificate 'stg' should go in sub-section"
		einfo "Auth-Type before other authentifications modules:\n"

		einfo "Auth-Type PAP {"
		einfo "                stg"
		einfo "                pap"
		einfo "}\n"

		einfo "It also may be used in section Accounting and Post-Auth."

		use module_auth_freeradius || einfo "\nFor use RADIUS enable USE-flag module_auth_freeradius."
	fi

	if use rscriptd ; then
		einfo "\nRemote Script Executer:"
		einfo "-----------------------"
		einfo "For further use edit /etc/stargazer/rscriptd.conf."
		einfo "You have to change 'Password' field at least."
	fi

	if use sgauth ; then
		einfo "\nSgauth:"
		einfo "-------"
		einfo "For further use edit /etc/stargazer/sgauth.conf."
		einfo "You have to change 'ServerName', 'Login', 'Password' fields at least."
	fi

	if use sgconf ; then
		einfo "\nSgconf:"
		einfo "-------"
		use module_config_sgconfig \
			|| einfo "For further use enable USE-flag module_config_sgconfig."
	fi

	if use sgconf_xml ; then
		einfo "\nSgconf_xml:"
		einfo "-----------"
		use module_config_rpcconfig \
			|| einfo "For further use enable USE-flag module_config_rpcconfig."
	fi

	if use stargazer ; then
		einfo "\nStargazer:"
		einfo "----------"
		einfo "Modules availability:\n"
		if use module_auth_always_online ; then
			einfo "* module_auth_always_online available."
		fi
		if use module_auth_internet_access ; then
			einfo "* module_auth_internet_access available."
		fi
		if use module_auth_freeradius ; then
			einfo "* module_auth_freeradius available.\n"
			einfo "For further use emerge net-dialup/freeradius.\n"
			use radius || einfo "\n           For use RADIUS enable use USE-flag radius."
		fi
		if use module_capture_ipq ; then
			einfo "* module_capture_ipq available."
		fi
		if use module_capture_ether ; then
			einfo "* module_capture_ether available."
		fi
		if use module_capture_netflow ; then
			einfo "* module_capture_netflow available.\n"
			einfo "For further use emerge any netflow sensor:\n"
			einfo "net-firewall/ipt_netflow or net-analyzer/softflowd.\n"
		fi
		if use module_config_sgconfig ; then
			einfo "* module_config_sgconfig available."
		fi
		if use module_config_rpcconfig ; then
			einfo "* module_config_rpcconfig available.\n"
			einfo "KNOWN BUG: Sometimes you can't configure Stargazer"
			einfo "through xml-based configurator, because module is not responding."
			einfo "This bug is introduced by xmlrpc-c library."
			einfo "This bug proceeds very rare, but it still exists.\n"
		fi
		if use module_other_ping ; then
			einfo "* module_other_ping available."
		fi
		if use module_other_smux ; then
			einfo "* module_other_smux available.\n"
			einfo "For further use emerge net-analyzer/net-snmp.\n"
		fi
		if use module_other_remote_script ; then
			einfo "* module_other_remote_script available.\n"
			einfo "For further use edit /etc/stargazer/subnets.\n"
		fi
		if use module_store_files ; then
			einfo "* module_store_files available."
		fi
		if use module_store_firebird ; then
			einfo "* module_store_firebird available.\n"
			einfo "You should add 'firebird' user to stg group:\n"
			einfo "# usermod -a -G stg firebird\n"
			einfo "and restart firebird:\n"
			einfo "# /etc/init.d/firebird restart\n"
			einfo "Stargazer DB schema for Firebird is here: /usr/share/stargazer/db/firebird"
			einfo "For new setup you should execute 00-base-00.sql:\n"
			einfo "# fbsql -q -i /usr/share/stargazer/db/firebird/00-base-00.sql\n"
			einfo "For upgrade from version 2.406 you should execute 00-alter-01.sql:\n"
			einfo "# fbsql -i /usr/share/stargazer/db/firebird/00-alter-01.sql\n"
		fi
		if use module_store_mysql ; then
			einfo "* module_store_mysql available.\n"
			einfo "For upgrade from version 2.406 you should execute 00-mysql-01.sql:\n"
			einfo "# mysql < /usr/share/stargazer/db/mysql/00-mysql-01.sql\n"
		fi
		if use module_store_postgres ; then
			einfo "* module_store_postgres available.\n"
			einfo "DB schema for PostgresSQL is here: /usr/share/stargazer/db/postgresql"
			einfo "For new setup you should execute 00-base-00.postgresql.sql:\n"
			einfo "# psql -f /usr/share/stargazer/db/postgresql/00-base-00.postgresql.sql\n"
			einfo "For upgrade from version 2.406 you should execute 00-alter-01.sql:\n"
			einfo "# psql -f /usr/share/stargazer/db/postgresql/00-alter-01.sql\n"
		fi
		einfo "\n    For all storage backends:\n"
		einfo "* Default admin login - admin, default admin password - 123456."
		einfo "* Default subscriber login - test, default subscriber password - 123456.\n"
		einfo "Don't run newer versions without reading their ChangeLog first,"
		einfo "it can be found in /usr/share/doc/${PF}"
	fi
	if use debug ; then
		ewarn "\nThis is a debug build, avoid to use it in production."
	fi
}
