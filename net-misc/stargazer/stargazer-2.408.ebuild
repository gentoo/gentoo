# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/stargazer/stargazer-2.408.ebuild,v 1.6 2014/12/28 16:42:54 titanofold Exp $

EAPI="5"

inherit eutils linux-info multilib user

DESCRIPTION="Billing system for small home and office networks"
HOMEPAGE="http://stg.dp.ua/"
LICENSE="GPL-2"

MY_P="stg-${PV}"
SRC_URI="http://stg.dp.ua/download/server/${PV}/${MY_P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}"

REQUIRED_USE="stargazer? ( ^^ ( module_store_files module_store_firebird module_store_mysql module_store_postgres ) )"

RDEPEND="module_config_rpcconfig? ( dev-libs/xmlrpc-c[abyss] sys-libs/zlib )
	module_config_sgconfig? ( dev-libs/expat )
	module_store_firebird? ( >=dev-db/firebird-2.0.3.12981.0-r6 )
	module_store_mysql? ( virtual/mysql )
	module_store_postgres? ( dev-db/postgresql dev-libs/openssl sys-libs/zlib )
	sgconf? ( dev-libs/expat )
	sgconf_xml? ( dev-libs/expat )"

DEPEND="${RDEPEND}
	doc? ( dev-libs/libxslt )"

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

IUSE="sgconv radius rscriptd sgauth sgconf sgconf_xml stargazer debug doc examples static-libs"

for module in ${STG_MODULES_AUTH} ; do IUSE="${IUSE} module_auth_${module}" ; done
for module in ${STG_MODULES_CAPTURE} ; do IUSE="${IUSE} module_capture_${module}" ; done
for module in ${STG_MODULES_CONFIG} ; do IUSE="${IUSE} module_config_${module}" ; done
for module in ${STG_MODULES_OTHER} ; do IUSE="${IUSE} module_other_${module}" ; done
for module in ${STG_MODULES_STORE} ; do IUSE="${IUSE} module_store_${module}" ; done

IUSE=${IUSE/stargazer/+stargazer}
IUSE=${IUSE/module_store_files/+module_store_files}

src_prepare() {
	# Patches already in upstream's trunk
	# Rename convertor to sgconv to avoid possible file name collisions
	mv "${S}"/projects/convertor/ "${S}"/projects/sgconv/ || die "Couldn't move convertor folder"
	mv "${S}"/projects/sgconv/convertor.conf "${S}"/projects/sgconv/sgconv.conf || die "Couldn't move convertor config"
	epatch "${FILESDIR}"/patches/stg-2.408-sgconv-upstream.patch

	# Fix dependency on fbclient for module_store_firebird
	epatch "${FILESDIR}"/patches/stg-2.408-makefile-firebird-upstream.patch

	# Debug support. Install radius lib to /usr/lib/freeradius
	epatch "${FILESDIR}"/patches/stg-2.408-makefile-build-upstream.patch

	# Don't compile sgconv always with debug. Remove MAKEOPTS=-j1
	epatch "${FILESDIR}"/patches/stg-2.408-build-upstream.patch

	# Rewrite config for rscriptd
	epatch "${FILESDIR}"/patches/stg-2.408-rscriptd.conf-upstream.patch

	# Rewrite config for sgauth
	epatch "${FILESDIR}"/patches/stg-2.408-sgauth.conf-upstream.patch

	# Standardization of 'On-scripts'
	epatch "${FILESDIR}"/patches/stg-2.408-on-upstream.patch

	# FreeBSD install directory
	epatch "${FILESDIR}"/patches/stg-2.408-radius-upstream.patch

	# Install demo scripts for rscriptd
	epatch "${FILESDIR}"/patches/stg-2.408-rscriptd-upstream.patch

	# Fix crush on stop
	epatch "${FILESDIR}"/patches/stg-2.408-fix-crash-on-stop.patch

	for project in ${PROJECTS} ; do
		# Rename build script to configure for further econf launch in every projects
		mv "${S}"/projects/${project}/build "${S}"/projects/${project}/configure || die "Couldn't move build folder for ${project}"

		# Change check for debug build
		sed -i 's/if \[ "$1" = "debug" \]/if \[ "${10}" = "--enable-debug" \]/' "${S}"/projects/${project}/configure || die "sed for debug check failed"
	done

	# Correct working directory, user and group for sgconv.conf, store_files.conf
	# Correct paths for rscriptd.conf, store_firebird.conf, mod_remote_scriptd.conf, stargazer.conf, rpcconfig.cpp, 00-base-00.sql
	epatch "${FILESDIR}"/patches/stg-2.408-correct-paths.patch

	# Correct target install-data for stargazer, rscriptd, sgauth, remove debug symbols stripping
	epatch "${FILESDIR}"/patches/stg-2.408-makefile.patch

	# Remove make from script (for keeping symbols), always add variable to Makefile.conf for all projects
	epatch "${FILESDIR}"/patches/stg-2.408-build.patch

	# Remove static-libs if not needed
	use static-libs || epatch "${FILESDIR}"/patches/stg-2.408-static-libs.patch

	# Define which module to compile
	for module in ${!MODULES[@]} ; do
		if ! use $module ; then
			sed -i "s/${MODULES[$module]%:*}//" "${S}"/projects/stargazer/configure || die "sed for module configure failed"
		fi
	done

	# Correct Gentoo init script provided by upstream (TODO: Remove in further releases, already fixed in upstream's trunk)
	if use stargazer ; then
		sed -i 's/opts/extra_commands/' "${S}"/projects/stargazer/inst/linux/etc/init.d/stargazer.gentoo || die "sed for stargazer failed"
	fi

	# Correct Gentoo init script dependencies
	if use module_store_files ; then
		sed -i '11d' "${S}"/projects/stargazer/inst/linux/etc/init.d/stargazer.gentoo || die "sed for module_store_files failed"
	fi

	if use module_store_firebird ; then
		sed -i '11d;s/need net/need net firebird/' "${S}"/projects/stargazer/inst/linux/etc/init.d/stargazer.gentoo || die "sed for module_store_firebird failed"
	fi

	if use module_store_mysql ; then
		sed -i '11d;s/need net/need net mysql/' "${S}"/projects/stargazer/inst/linux/etc/init.d/stargazer.gentoo || die "sed for module_store_mysql failed"
	fi

	if use module_store_postgres ; then
		sed -i '11d;s/need net/need net postgresql/' "${S}"/projects/stargazer/inst/linux/etc/init.d/stargazer.gentoo || die "sed for module_store_postgres failed"
	fi

	# Check for IPQ subsystem availability
	( use module_capture_ipq && kernel_is ge 3 5 ) && die "IPQ subsystem is gone since Linux kernel 3.5. You can't compile module_capture_ipq with your current kernel."

	epatch_user
}

src_configure() {
	# Define local variables, strip '+' symbol for used by default USE flags
	local USEFLAGS=(${IUSE//+})
	local PROJECTS=($PROJECTS)

	for (( i = 0 ; i < ${#PROJECTS[@]} ; i++ )) ; do
		if use ${USEFLAGS[$i]} ; then
			cd "${S}"/projects/${PROJECTS[$i]} || die "cd to ${PROJECTS[$i]} failed"
			econf $(use_enable debug)
		fi
	done
}

src_compile() {
	# Define local variables, strip '+' symbol for used by default USE flags
	local USEFLAGS=(${IUSE//+})
	local PROJECTS=($PROJECTS)

	# Set jobs to 1 for debug build
	use debug && MAKEOPTS="-j1"

	# Build necessary libraries first
	touch "${S}"/Makefile.conf
	cd "${S}"/stglibs || die "cd to stglibs failed"
	emake STG_LIBS="ia.lib srvconf.lib"

	for (( i = 0 ; i < ${#PROJECTS[@]} ; i++ )) ; do
		if use ${USEFLAGS[$i]} ; then
			cd "${S}"/projects/${PROJECTS[$i]} || die "cd to ${PROJECTS[$i]} failed"
			emake
		fi
	done

	if use doc ; then
		cd "${S}"/doc/xmlrpc || die "cd to doc/xmlrpc failed"
		emake
	fi
}

src_install() {
	dodoc ChangeLog

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

	if use doc ; then
		# Install files into docs directory
		dodoc "${S}"/projects/stargazer/inst/var/base.dia
		dodoc "${S}"/doc/proto_client.gif
		dodoc "${S}"/doc/proto_server.gif

		# Install html documentation
		docinto html/xmlrpc
		dohtml -r "${S}"/doc/xmlrpc/book/
	fi

	if use examples ; then
		# Install files into specified directory
		insinto /usr/share/stargazer
		doins -r "${S}"/projects/stargazer/scripts
		doins "${S}"/doc/xmlrpc.php
	fi

	if use sgconv ; then
		cd "${S}"/projects/sgconv || die "cd to sgconv project failed"

		emake DESTDIR="${D}" PREFIX="${D}" install

		# Install files into specified directory
		insinto /etc/stargazer
		doins "${S}"/projects/sgconv/sgconv.conf

		# Install manual page
		doman "${FILESDIR}"/mans/sgconv.1
	fi

	if use radius ; then
		cd "${S}"/projects/rlm_stg || die "cd to rlm_stg project failed"

		emake DESTDIR="${D}" PREFIX="${D}" install
	fi

	if use rscriptd ; then
		cd "${S}"/projects/rscriptd || die "cd to rscriptd project failed"

		emake DESTDIR="${D}" PREFIX="${D}" install

		# Install Gentoo init script
		doinitd "${FILESDIR}"/rscriptd

		# Correct permissions for file
		fperms 0640 /etc/stargazer/rscriptd.conf

		# Install manual page
		doman "${FILESDIR}"/mans/rscriptd.8
	fi

	if use sgauth ; then
		cd "${S}"/projects/sgauth || die "cd to sgauth project failed"

		emake DESTDIR="${D}" PREFIX="${D}" install

		# Correct permissions for file
		fperms 0640 /etc/stargazer/sgauth.conf

		# Install manual page
		doman "${FILESDIR}"/mans/sgauth.8
	fi

	if use sgconf ; then
		cd "${S}"/projects/sgconf || die "cd to sgconf project failed"

		emake DESTDIR="${D}" PREFIX="${D}" install

		# Install manual page
		doman "${FILESDIR}"/mans/sgconf.1
	fi

	if use sgconf_xml ; then
		cd "${S}"/projects/sgconf_xml || die "cd to sgconf_xml project failed"

		emake DESTDIR="${D}" PREFIX="${D}" install

		# Install manual page
		doman "${FILESDIR}"/mans/sgconf_xml.1
	fi

	if use stargazer ; then
		cd "${S}"/projects/stargazer || die "cd to stargazer project failed"

		emake DESTDIR="${D}" PREFIX="${D}" install

		# Install docs
		dodoc BUGS CHANGES README TODO

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
			grep 192 "${S}"/projects/stargazer/inst/linux/etc/stargazer/conf-available.d/mod_remote_script.conf | sed 's/# //' > "${D}"/etc/stargazer/subnets

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

		for module in ${!MODULES[@]} ; do
			use $module && doins "${S}"/projects/stargazer/inst/linux/etc/stargazer/conf-available.d/${MODULES[$module]#*:}.conf
		done

		# Create symlinks of configs for selected modules
		for module in ${!MODULES[@]} ; do
			use $module && dosym /etc/stargazer/conf-available.d/${MODULES[$module]#*:}.conf /etc/stargazer/conf-enabled.d/${MODULES[$module]#*:}.conf
		done
	fi

	# Correct user and group for files and directories
	( use sgconv || use rscriptd || use sgauth || use stargazer ) && fowners -R stg:stg /etc/stargazer

	# Put the files in the right folder to support multilib
	if [ ! -e "${ED}"/usr/$(get_libdir) ] ; then
		mv "${ED}"/usr/lib/ "${ED}"/usr/$(get_libdir) || die "Failed to move library directory for multilib support"
	fi
}

pkg_setup() {
	# Add user and group to system only when necessary
	if use sgconv || use rscriptd || use sgauth || use stargazer ; then
		enewgroup stg

		# Add stg user to system (no home directory specified, because otherwise it will be result in stg:root ownership on it)
		enewuser stg -1 -1 -1 stg
	fi
}

pkg_postinst() {
	if use sgconv ; then
		einfo "\nSgconv:"
		einfo "----------"
		einfo "    For further use of sgconv please edit /etc/stargazer/sgconv.conf depending on your needs."
	fi

	if use radius ; then
		einfo "\nRadius:"
		einfo "-------"
		einfo "    For further use of radius, emerge net-dialup/freeradius.\n"

		einfo "    Example config:\n"

		einfo "        stg {"
		einfo "               local_port = 6667"
		einfo "               server = localhost"
		einfo "               port = 6666"
		einfo "               password = 123456"
		einfo "        }\n"

		einfo "    You should place 'stg' into section Instantiate, Authorize."
		einfo "    In section Authentificate 'stg' should go in sub-section Auth-Type before other authentifications modules:\n"

		einfo "        Auth-Type PAP {"
		einfo "                         stg"
		einfo "                         pap"
		einfo "        }\n"

		einfo "    It also may be used in section Accounting and Post-Auth."

		use module_auth_freeradius || einfo "\n    For use RADIUS data processing you should also enable USE-flag module_auth_freeradius."
	fi

	if use rscriptd ; then
		einfo "\nRemote Script Executer:"
		einfo "-----------------------"
		einfo "    For further use of rscriptd please edit /etc/stargazer/rscriptd.conf depending on your needs."
		einfo "    You have to change 'Password' field at least."
	fi

	if use sgauth ; then
		einfo "\nSgauth:"
		einfo "-------"
		einfo "    For further use of sgauth please edit /etc/stargazer/sgauth.conf depending on your needs."
		einfo "    You have to change 'ServerName', 'Login', 'Password' fields at least."
	fi

	if use sgconf ; then
		einfo "\nSgconf:"
		einfo "-------"
		use module_config_sgconfig || einfo "    For further use of sgconf utility you should also enable USE-flag module_config_sgconfig."
	fi

	if use sgconf_xml ; then
		einfo "\nSgconf_xml:"
		einfo "-----------"
		use module_config_rpcconfig || einfo "    For further use of sgconf_xml utility you should also enable USE-flag module_config_rpcconfig."
	fi

	if use stargazer ; then
		einfo "\nStargazer:"
		einfo "----------"
		einfo "    Modules availability:\n"

		if use module_auth_always_online ; then
			einfo "      * module_auth_always_online available."
		fi

		if use module_auth_internet_access ; then
			einfo "      * module_auth_internet_access available."
		fi

		if use module_auth_freeradius ; then
			einfo "      * module_auth_freeradius available.\n"
			einfo "           For further use of module, emerge net-dialup/freeradius.\n"
			use radius || einfo "\n           For use RADIUS data processing you should also enable use USE-flag radius."
		fi

		if use module_capture_ipq ; then
			einfo "      * module_capture_ipq available."
		fi

		if use module_capture_ether ; then
			einfo "      * module_capture_ether available."
		fi

		if use module_capture_netflow ; then
			einfo "      * module_capture_netflow available.\n"
			einfo "           For further use of module, emerge net-firewall/ipt_netflow or net-analyzer/softflowd.\n"
		fi

		if use module_config_sgconfig ; then
			einfo "      * module_config_sgconfig available."
		fi

		if use module_config_rpcconfig ; then
			einfo "      * module_config_rpcconfig available.\n"
			einfo "           KNOWN BUG: Sometimes you can't configure Stargazer through xml-based configurator,"
			einfo "                      because module is not responding."
			einfo "                      This bug is introduced by xmlrpc-c library. This bug proceeds very rare, but it still exists.\n"
		fi

		if use module_other_ping ; then
			einfo "      * module_other_ping available."
		fi

		if use module_other_smux ; then
			einfo "      * module_other_smux available.\n"
			einfo "           For further use of module emerge net-analyzer/net-snmp.\n"
		fi

		if use module_other_remote_script ; then
			einfo "      * module_other_remote_script available.\n"
			einfo "           Don't forget to edit /etc/stargazer/subnets file depending on your needs."
		fi

		if use module_store_files ; then
			einfo "      * module_store_files available.\n"
			einfo "           Necessary and sufficient rights to the directory /var/lib/stargazer for this backend is 0755."
			einfo "           You may fix it if needed.\n"
		fi

		if use module_store_firebird ; then
			einfo "      * module_store_firebird available.\n"
			einfo "           Necessary and sufficient rights to the directory /var/lib/stargazer for this backend is 0775."
			einfo "           Check that it was so, and fix it if needed."
			einfo "           You should add 'firebird' user to stg group:\n"
			einfo "             # usermod -a -G stg firebird\n"
			einfo "           and restart firebird:\n"
			einfo "             # /etc/init.d/firebird restart\n"
			einfo "           Stargazer DB schema for Firebird is here: /usr/share/stargazer/db/firebird"
			einfo "           For new setup you should execute 00-base-00.sql:\n"
			einfo "             # fbsql -q -i /usr/share/stargazer/db/firebird/00-base-00.sql\n"
			einfo "           For upgrade from version 2.406 you should execute 00-alter-01.sql:\n"
			einfo "             # fbsql -q -u <username> -p <password> -d <database> -i /usr/share/stargazer/db/firebird/00-alter-01.sql\n"
		fi

		if use module_store_mysql ; then
			einfo "      * module_store_mysql available.\n"
			einfo "           For upgrade from version 2.406 you should execute 00-mysql-01.sql:\n"
			einfo "             # mysql -h <hostname> -P <port> -u <username> -p <password> <database> < /usr/share/stargazer/db/mysql/00-mysql-01.sql\n"
		fi

		if use module_store_postgres ; then
			einfo "      * module_store_postgres available.\n"
			einfo "           Stargazer DB schema for PostgresSQL is here: /usr/share/stargazer/db/postgresql"
			einfo "           For new setup you should execute 00-base-00.postgresql.sql:\n"
			einfo "             # psql -h <hostname> -p <port> -U <username> -d <database> -W -f /usr/share/stargazer/db/postgresql/00-base-00.postgresql.sql\n"
			einfo "           For upgrade from version 2.406 you should execute 00-alter-01.sql:\n"
			einfo "             # psql -h <hostname> -p <port> -U <username> -d <database> -W -f /usr/share/stargazer/db/postgresql/00-alter-01.sql\n"
		fi

		einfo "\n    For all storage backends:\n"
		einfo "      * Default admin login - admin, default admin password - 123456."
		einfo "      * Default subscriber login - test, default subscriber password - 123456.\n"
		einfo "Don't run newer versions without reading their ChangeLog first,"
		einfo "it can be found in /usr/share/doc/${PF}"
	fi

	if use debug ; then
		ewarn "\nThis is a debug build. You should avoid to use it in production.\n"
	fi
}
