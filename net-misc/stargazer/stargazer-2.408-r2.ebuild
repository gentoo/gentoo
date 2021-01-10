# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PROJECTS="sgconv rlm_stg rscriptd sgauth sgconf sgconf_xml stargazer"

STG_MODULES_AUTH="always-online internet-access freeradius"
STG_MODULES_CAPTURE="ether netflow"
STG_MODULES_CONFIG="sgconfig rpcconfig"
STG_MODULES_OTHER="ping smux remote-script"
STG_MODULES_STORE="files firebird mysql postgres"

declare -A MODULES
MODULES=( [module-auth-always-online]="authorization\\/ao:mod_ao"
	[module-auth-internet-access]="authorization\\/inetaccess:mod_ia"
	[module-auth-freeradius]="other\\/radius:mod_radius"
	[module-capture-ether]="capture\\/ether_linux:mod_cap_ether"
	[module-capture-netflow]="capture\\/cap_nf:mod_cap_nf"
	[module-config-sgconfig]="configuration\\/sgconfig:mod_sg"
	[module-config-rpcconfig]="configuration\\/rpcconfig:mod_rpc"
	[module-other-ping]="other\\/ping:mod_ping"
	[module-other-smux]="other\\/smux:mod_smux"
	[module-other-remote-script]="other\\/rscript:mod_remote_script"
	[module-store-files]="store\\/files:store_files"
	[module-store-firebird]="store\\/firebird:store_firebird"
	[module-store-mysql]="store\\/mysql:store_mysql"
	[module-store-postgres]="store\\/postgresql:store_postgresql"
)

declare -A INIT
INIT=(	[module-store-files]="11d"
	[module-store-firebird]="11d;s/need net/need net firebird/"
	[module-store-mysql]="11d;s/need net/need net mysql/"
	[module-store-postgres]="11d;s/need net/need net postgresql/"
)

MY_P="stg-${PV}"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Billing system for small home and office networks"
HOMEPAGE="http://stg.net.ua"
SRC_URI="http://stg.dp.ua/download/server/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="acct-user/stg
	${DEPEND}"
DEPEND="module-config-rpcconfig? (
		dev-libs/expat
		dev-libs/xmlrpc-c[abyss,cxx]
	)
	module-config-sgconfig? ( dev-libs/expat )
	module-store-firebird? ( dev-db/firebird )
	module-store-mysql? ( dev-db/mysql-connector-c:0= )
	module-store-postgres? ( dev-db/postgresql:= )
	sgconf? ( dev-libs/expat )
	sgconf-xml? ( dev-libs/expat )"

S="${WORKDIR}/${MY_P}"

REQUIRED_USE="stargazer? ( ^^ ( module-store-files module-store-firebird module-store-mysql module-store-postgres ) )"

# Patches are already in upstream's trunk
PATCHES=(
	# Fix dependency on fbclient for module-store-firebird
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

IUSE="sgconv radius rscriptd sgauth sgconf sgconf-xml +stargazer debug"

for module in ${STG_MODULES_AUTH} ; do IUSE="${IUSE} module-auth-${module}" ; done
for module in ${STG_MODULES_CAPTURE} ; do IUSE="${IUSE} module-capture-${module}" ; done
for module in ${STG_MODULES_CONFIG} ; do IUSE="${IUSE} module-config-${module}" ; done
for module in ${STG_MODULES_OTHER} ; do IUSE="${IUSE} module-other-${module}" ; done
for module in ${STG_MODULES_STORE} ; do IUSE="${IUSE} module-store-${module}" ; done

IUSE=${IUSE/module-store-files/+module-store-files}

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
		mv projects/"$project"/build projects/"$project"/configure \
			|| die "Couldn't move build folder for $project"
		# Change check for debug build
		sed -i 's/if \[ "$1" = "debug" \]/if \[ "${10}" = "--enable-debug" \]/' \
			projects/"$project"/configure || die "sed for debug check failed"
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

	# wrt 740792
	eapply "${FILESDIR}"/patches/stg-2.408-static_cast.patch

	# Populate global arrays, strip '+' symbol for used by default USE flags
	IFS=" " read -r -a PROJECTS <<<"$PROJECTS"
	IFS=" " read -r -a USEFLAGS <<<"${IUSE//+}"

	# Define which module to compile
	local module
	for module in "${!MODULES[@]}" ; do
		if ! use "$module" ; then
			sed -i "s/${MODULES[$module]%:*}//" \
				projects/stargazer/configure \
				|| die "sed for module configure failed"
		fi
	done

	# Correct Gentoo init script
	sed -i  -e 's/opts/extra_commands/' \
		-e 's/runscript/openrc-run/' \
		projects/stargazer/inst/linux/etc/init.d/stargazer.gentoo \
		|| die "sed for init-script failed"
	local init
	for init in "${!INIT[@]}" ; do
		if use "$init" ; then
			sed -i "${INIT[$init]}" \
				projects/stargazer/inst/linux/etc/init.d/stargazer.gentoo \
				|| die "sed for $init failed"
		fi
	done

	# Don't build unsupported capture plugin
	sed -i 's|capture/ipq_linux||' projects/stargazer/configure \
		|| die "sed failed for stargazer/configure"
}

src_configure() {
	use debug && filter-flags '-O?'

	local i
	for (( i = 0 ; i < ${#PROJECTS[@]} ; i++ )) ; do
		if use "${USEFLAGS[$i]}" ; then
			cd "${S}"/projects/"${PROJECTS[$i]}" \
				|| die "cd to ${PROJECTS[$i]} failed"
			econf "$(use_enable debug)"
		fi
	done
}

src_compile() {
	use debug && MAKEOPTS="-j1"

	# Build necessary libraries first
	touch Makefile.conf
	cd stglibs || die "cd to stglibs failed"
	emake STG_LIBS="ia.lib srvconf.lib" CC="$(tc-getCC)" CXX="$(tc-getCXX)"

	local i
	for (( i = 0 ; i < ${#PROJECTS[@]} ; i++ )) ; do
		if use "${USEFLAGS[$i]}" ; then
			cd "${S}"/projects/"${PROJECTS[$i]}" \
				|| die "cd to ${PROJECTS[$i]} failed"
			emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
		fi
	done
}

src_install() {
	if use rscriptd || use stargazer ; then
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
		insinto /etc/stargazer
		doins "${S}"/projects/sgconv/sgconv.conf
		doman "${FILESDIR}"/mans/sgconv.1
	fi

	if use radius ; then
		dolib.so "${S}"/projects/rlm_stg/rlm_stg.so
	fi

	if use rscriptd ; then
		cd "${S}"/projects/rscriptd || die "cd to rscriptd failed"
		emake DESTDIR="${D}" PREFIX="${D}" install
		doinitd "${FILESDIR}"/rscriptd
		fperms 0640 /etc/stargazer/rscriptd.conf
		doman "${FILESDIR}"/mans/rscriptd.8
	fi

	if use sgauth ; then
		cd "${S}"/projects/sgauth || die "cd to sgauth failed"
		emake DESTDIR="${D}" PREFIX="${D}" install
		fperms 0640 /etc/stargazer/sgauth.conf
		doman "${FILESDIR}"/mans/sgauth.8
	fi

	if use sgconf ; then
		cd "${S}"/projects/sgconf || die "cd to sgconf failed"
		emake DESTDIR="${D}" PREFIX="${D}" install
		doman "${FILESDIR}"/mans/sgconf.1
	fi

	if use sgconf-xml ; then
		cd "${S}"/projects/sgconf_xml || die "cd to sgconf_xml failed"
		emake DESTDIR="${D}" PREFIX="${D}" install
		doman "${FILESDIR}"/mans/sgconf_xml.1
	fi

	if use stargazer ; then
		cd "${S}"/projects/stargazer || die "cd to stargazer failed"
		emake DESTDIR="${D}" PREFIX="${D}" install

		newinitd "${S}"/projects/stargazer/inst/linux/etc/init.d/stargazer.gentoo stargazer
		doman "${FILESDIR}"/mans/stargazer.8

		if use module-store-files ; then
			insinto /var/lib
			doins -r "${S}"/projects/stargazer/inst/var/stargazer
			fowners -R stg:stg /var/lib/stargazer
		fi

		if use module-store-firebird ; then
			insinto /usr/share/stargazer/db/firebird
			doins \
				"${S}"/projects/stargazer/inst/var/00-base-00.sql \
				"${S}"/projects/stargazer/inst/var/00-alter-01.sql
		fi

		if use module-store-mysql ; then
			insinto /usr/share/stargazer/db/mysql
			doins "${S}"/projects/stargazer/inst/var/00-mysql-01.sql
		fi

		if use module-store-postgres ; then
			insinto /usr/share/stargazer/db/postgresql
			doins \
				"${S}"/projects/stargazer/inst/var/00-base-00.postgresql.sql \
				"${S}"/projects/stargazer/inst/var/00-alter-01.postgresql.sql
		fi

		if use module-other-smux ; then
			insinto /usr/share/snmp/mibs
			doins "${S}"/projects/stargazer/plugins/other/smux/STG-MIB.mib
		fi

		if use module-other-remote-script ; then
			# Create subnets file based on example from mod_remote_script.conf
			grep 192 "${S}"/projects/stargazer/inst/linux/etc/stargazer/conf-available.d/mod_remote_script.conf \
				| sed 's/# //' > "${ED}"/etc/stargazer/subnets || die "sed for subnets failed"
			fperms 0640 /etc/stargazer/subnets
		fi

		fperms 0640 /etc/stargazer/rules /etc/stargazer/stargazer.conf

		insinto /etc/stargazer/conf-available.d
		insopts -m 0640

		local module
		for module in "${!MODULES[@]}" ; do
			use "$module" && doins "${S}"/projects/stargazer/inst/linux/etc/stargazer/conf-available.d/"${MODULES[$module]#*:}".conf
		done

		# Create symlinks of configs for selected modules
		for module in "${!MODULES[@]}" ; do
			use "$module" \
				&& dosym \
				/etc/stargazer/conf-available.d/"${MODULES[$module]#*:}".conf \
				/etc/stargazer/conf-enabled.d/"${MODULES[$module]#*:}".conf
		done
	fi

	# Correct user and group for files and directories
	if use sgconv || use rscriptd || use sgauth || use stargazer ; then
		fowners -R stg:stg /etc/stargazer
	fi

	# Put the files in the right folder to support multilib
	if [ ! -e "${ED}"/usr/"$(get_libdir)" ] ; then
		mv "${ED}"/usr/lib/ "${ED}"/usr/"$(get_libdir)" \
			|| die "Failed to move library directory for multilib support"
	fi
}

pkg_postinst() {
	if use sgconv ; then
		einfo "\\nSgconv:"
		einfo "----------"
		einfo "For further use edit /etc/stargazer/sgconv.conf."
	fi

	if use radius ; then
		einfo "\\nRadius:"
		einfo "-------"
		einfo "For further use emerge net-dialup/freeradius.\\n"

		einfo "Example config:\\n"

		einfo "stg {"
		einfo "      local_port = 6667"
		einfo "      server = localhost"
		einfo "      port = 6666"
		einfo "      password = 123456"
		einfo "    }\\n"

		einfo "You should place 'stg' into section Instantiate, Authorize."
		einfo "In section Authentificate 'stg' should go in sub-section"
		einfo "Auth-Type before other authentifications modules:\\n"

		einfo "Auth-Type PAP {"
		einfo "                stg"
		einfo "                pap"
		einfo "}\\n"

		einfo "It also may be used in section Accounting and Post-Auth."

		use module-auth-freeradius || einfo "\\nFor use RADIUS enable USE-flag module-auth-freeradius."
	fi

	if use rscriptd ; then
		einfo "\\nRemote Script Executer:"
		einfo "-----------------------"
		einfo "For further use edit /etc/stargazer/rscriptd.conf."
		einfo "You have to change 'Password' field at least."
	fi

	if use sgauth ; then
		einfo "\\nSgauth:"
		einfo "-------"
		einfo "For further use edit /etc/stargazer/sgauth.conf."
		einfo "You have to change 'ServerName', 'Login', 'Password' fields at least."
	fi

	if use sgconf ; then
		einfo "\\nSgconf:"
		einfo "-------"
		use module-config-sgconfig \
			|| einfo "For further use enable USE-flag module-config-sgconfig."
	fi

	if use sgconf-xml ; then
		einfo "\\nSgconf_xml:"
		einfo "-----------"
		use module-config-rpcconfig \
			|| einfo "For further use enable USE-flag module-config-rpcconfig."
	fi

	if use stargazer ; then
		einfo "\\nStargazer:"
		einfo "----------"
		einfo "Modules availability:\\n"
		if use module-auth-always-online ; then
			einfo "* module-auth-always-online available."
		fi
		if use module-auth-internet-access ; then
			einfo "* module-auth-internet-access available."
		fi
		if use module-auth-freeradius ; then
			einfo "* module-auth-freeradius available.\\n"
			einfo "For further use emerge net-dialup/freeradius.\\n"
			use radius || einfo "\\n           For use RADIUS enable use USE-flag radius."
		fi
		if use module-capture-ether ; then
			einfo "* module-capture-ether available."
		fi
		if use module-capture-netflow ; then
			einfo "* module-capture-netflow available.\\n"
			einfo "For further use emerge any netflow sensor:\\n"
			einfo "net-firewall/ipt_netflow or net-analyzer/softflowd.\\n"
		fi
		if use module-config-sgconfig ; then
			einfo "* module-config-sgconfig available."
		fi
		if use module-config-rpcconfig ; then
			einfo "* module-config-rpcconfig available.\\n"
			einfo "KNOWN BUG: Sometimes you can't configure Stargazer"
			einfo "through xml-based configurator, because module is not responding."
			einfo "This bug is introduced by xmlrpc-c library."
			einfo "This bug proceeds very rare, but it still exists.\\n"
		fi
		if use module-other-ping ; then
			einfo "* module-other-ping available."
		fi
		if use module-other-smux ; then
			einfo "* module-other-smux available.\\n"
			einfo "For further use emerge net-analyzer/net-snmp.\\n"
		fi
		if use module-other-remote-script ; then
			einfo "* module-other-remote-script available.\\n"
			einfo "For further use edit /etc/stargazer/subnets.\\n"
		fi
		if use module-store-files ; then
			einfo "* module-store-files available."
		fi
		if use module-store-firebird ; then
			einfo "* module-store-firebird available.\\n"
			einfo "You should add 'firebird' user to stg group:\\n"
			einfo "# usermod -a -G stg firebird\\n"
			einfo "and restart firebird:\\n"
			einfo "# /etc/init.d/firebird restart\\n"
			einfo "Stargazer DB schema for Firebird is here: /usr/share/stargazer/db/firebird"
			einfo "For new setup you should execute 00-base-00.sql:\\n"
			einfo "# fbsql -q -i /usr/share/stargazer/db/firebird/00-base-00.sql\\n"
			einfo "For upgrade from version 2.406 you should execute 00-alter-01.sql:\\n"
			einfo "# fbsql -i /usr/share/stargazer/db/firebird/00-alter-01.sql\\n"
		fi
		if use module-store-mysql ; then
			einfo "* module-store-mysql available.\\n"
			einfo "For upgrade from version 2.406 you should execute 00-mysql-01.sql:\\n"
			einfo "# mysql < /usr/share/stargazer/db/mysql/00-mysql-01.sql\\n"
		fi
		if use module-store-postgres ; then
			einfo "* module-store-postgres available.\\n"
			einfo "DB schema for PostgresSQL is here: /usr/share/stargazer/db/postgresql"
			einfo "For new setup you should execute 00-base-00.postgresql.sql:\\n"
			einfo "# psql -f /usr/share/stargazer/db/postgresql/00-base-00.postgresql.sql\\n"
			einfo "For upgrade from version 2.406 you should execute 00-alter-01.sql:\\n"
			einfo "# psql -f /usr/share/stargazer/db/postgresql/00-alter-01.sql\\n"
		fi
		einfo "\\n    For all storage backends:\\n"
		einfo "* Default admin login - admin, default admin password - 123456."
		einfo "* Default subscriber login - test, default subscriber password - 123456.\\n"
		einfo "Don't run newer versions without reading their ChangeLog first,"
		einfo "it can be found in /usr/share/doc/${PF}"
	fi
	if use debug ; then
		ewarn "\\nThis is a debug build, avoid to use it in production."
	fi
}
