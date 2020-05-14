# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
CMAKE_WARN_UNUSED_CLI=no
#CMAKE_REMOVE_MODULES=yes

inherit python-any-r1 systemd cmake-utils

DESCRIPTION="Featureful client/server network backup suite"
HOMEPAGE="https://www.bareos.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/Release/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X acl ceph clientonly +director glusterfs ipv6 jansson lmdb libressl
	logwatch mysql ndmp +postgres readline scsi-crypto
	sqlite static +storage-daemon systemd tcpd vim-syntax xattr"

# get cmake variables from core/cmake/BareosSetVariableDefaults.cmake
DEPEND="
	!app-backup/bacula
	acct-group/${PN}
	!x86? (
		ceph? ( sys-cluster/ceph )
	)
	glusterfs? ( sys-cluster/glusterfs )
	lmdb? ( dev-db/lmdb )
	dev-libs/gmp:0
	!clientonly? (
		acct-user/${PN}
		postgres? ( dev-db/postgresql:*[threads] )
		mysql? ( virtual/mysql )
		sqlite? ( dev-db/sqlite:3 )
		director? (
			virtual/mta
			jansson? ( dev-libs/jansson )
		)
	)
	logwatch? ( sys-apps/logwatch )
	tcpd? ( sys-apps/tcp-wrappers )
	readline? ( sys-libs/readline:0 )
	static? (
		acl? ( virtual/acl[static-libs] )
		sys-libs/zlib[static-libs]
		dev-libs/lzo[static-libs]
		sys-libs/ncurses:=[static-libs]
		!libressl? ( dev-libs/openssl:0=[static-libs] )
		libressl? ( dev-libs/libressl:0=[static-libs] )
	)
	!static? (
		acl? ( virtual/acl )
		dev-libs/lzo
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
		sys-libs/ncurses:=
		sys-libs/zlib
	)
	"
RDEPEND="${DEPEND}
	!clientonly? (
		storage-daemon? (
			sys-block/mtx
			app-arch/mt-st
		)
	)
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
	"
BDEPEND="${PYTHON_DEPS}"

REQUIRED_USE="
	!clientonly? ( || ( mysql postgres sqlite ) )
	static? ( clientonly )
	x86? ( !ceph )
"

S=${WORKDIR}/${PN}-Release-${PV}

src_prepare() {
	use mysql    && export mydbtypes+=( mysql )
	use postgres && export mydbtypes+=( postgresql )
	use sqlite   && export mydbtypes+=( sqlite )

	# enables default database driver in catalog
	pushd core/src/defaultconfigs >&/dev/null || die
		sed -i -e 's/#dbdriver/dbdriver/' -e '/XXX_REPLACE_WITH_DATABASE_DRIVER_XXX/d' $(grep -rl XXX_REPLACE_WITH_DATABASE_DRIVER_XXX) \
			|| die "sed on MyCatalog.conf.in failed"
	popd >&/dev/null || die

	# fix gentoo version detection
	eapply -p0 "${FILESDIR}/${PN}-cmake-gentoo.patch"

	# fix missing DESTDIR in symlink creation
	sed -i '/bareos-symlink-default-db-backend.cmake/d' "${S}/core/src/cats/CMakeLists.txt"

	CMAKE_USE_DIR="$S/core"
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=()

	CMAKE_USE_DIR="$S/core"

	pushd core/platforms >&/dev/null || die
	cmake_comment_add_subdirectory '${DISTNAME}'
	popd >&/dev/null || die

	if use clientonly; then
		mycmakeargs+=(
			-Dclient-only=ON
			-Dstatic-cons=$(usex static)
			-Dstatic-fd=$(usex static)
		)
	fi

	for useflag in acl ipv6 ndmp scsi-crypto \
		systemd mysql lmdb; do
		mycmakeargs+=( -D$useflag=$(usex $useflag) )
	done

	mycmakeargs+=(
		-DDEFAULT_DB_TYPE=${mydbtypes[0]}
		-Darchivedir=/var/lib/bareos/storage
		-Dbackenddir=/usr/$(get_libdir)/${PN}/backend
		-Dbasename="`hostname -s`"
		-Dbatch-insert=yes
		-Dbsrdir=/var/lib/bareos/bsr
		-Dconfdir=/etc/bareos
		-Dcoverage=yes
		-Ddb_password=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1`
		-Ddir-group=bareos
		-Ddir-password="`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`"
		-Ddir-user=bareos
		-Ddocdir=/usr/share/doc/${PF}
		-Ddynamic-cats-backends=yes
		-Ddynamic-storage-backends=yes
		-Dfd-group=bareos
		-Dfd-password="`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`"
		-Dfd-user=root
		-Dhost=${CHOST}
		-Dhostname="`hostname -s`"
		-Dhtmldir=/usr/share/doc/${PF}/html
		-Dlibdir=/usr/$(get_libdir)
		-Dlogdir=/var/log/bareos
		-Dmandir=/usr/share/man
		-Dmon-dir-password="`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`"
		-Dmon-fd-password="`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`"
		-Dmon-sd-password="`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`"
		-Dmysql=$(usex mysql)
		-Dopenssl=yes
		-Dpiddir=/run/bareos
		-Dplugindir=/usr/$(get_libdir)/${PN}/plugin
		-Dpostgresql=$(usex postgres)
		-Dsbin-perm=0755
		-Dsbindir=/usr/sbin
		-Dscriptdir=/usr/libexec/bareos
		-Dsd-group=bareos
		-Dsd-password="`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`"
		-Dsd-user=root
		-Dsqlite3=$(usex sqlite)
		-Dsubsysdir=/run/lock/subsys
		-Dsysconfdir=/etc
		-Dworkingdir=/var/lib/bareos
		-Dx=$(usex X)
		)

		cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# remove some scripts we don't need at all
	rm -f "${D}"/usr/libexec/bareos/{bareos,bareos-ctl-dir,bareos-ctl-fd,bareos-ctl-sd,startmysql,stopmysql}
	rm -f "${D}"/usr/sbin/bareos

	# remove upstream init scripts
	rm -f "${D}"/etc/init.d/bareos-*

	# rename statically linked apps
	if use clientonly && use static ; then
		pushd "${D}"/usr/sbin || die
		mv static-bareos-fd bareos-fd || die
		mv static-bconsole bconsole || die
		popd || die
	fi

	# extra files which 'make install' doesn't cover
	if ! use clientonly; then
		# the logrotate configuration
		# (now unconditional wrt bug #258187)
		diropts -m0755
		insinto /etc/logrotate.d
		insopts -m0644
		newins "${S}"/core/scripts/logrotate bareos

		# the logwatch scripts
		if use logwatch; then
			diropts -m0750
			dodir /etc/log.d/scripts/services
			dodir /etc/log.d/scripts/shared
			dodir /etc/log.d/conf/logfiles
			dodir /etc/log.d/conf/services
			pushd "${S}"/core/scripts/logwatch >&/dev/null || die

			into /etc/log.d/scripts/services
			dobin bareos

			into /etc/log.d/scripts/shared
			dobin applybareosdate

			insinto /etc/log.d/conf/logfiles
			newins logfile.bareos.conf bareos.conf

			insinto /etc/log.d/conf/services
			newins services.bareos.conf bareos.conf

			popd >&/dev/null || die
		fi
	fi

	rm -vf "${D}"/usr/share/man/man1/bareos-bwxconsole.1*
	if use clientonly || ! use director; then
		if use systemd; then
			rm -vf "${D}"/lib/systemd/system/bareos-dir.service
		fi
		rm -vf "${D}"/usr/share/man/man8/bareos-dir.8*
		rm -vf "${D}"/usr/share/man/man8/bareos-dbcheck.8*
		rm -vf "${D}"/usr/share/man/man1/bsmtp.1*
		rm -vf "${D}"/usr/share/man/man8/bwild.8*
		rm -vf "${D}"/usr/share/man/man8/bregex.8*
		rm -vf "${D}"/usr/share/man/man8/bpluginfo.8*
		rm -vf "${D}"/usr/libexec/bareos/create_*_database
		rm -vf "${D}"/usr/libexec/bareos/drop_*_database
		rm -vf "${D}"/usr/libexec/bareos/make_*_tables
		rm -vf "${D}"/usr/libexec/bareos/update_*_tables
		rm -vf "${D}"/usr/libexec/bareos/drop_*_tables
		rm -vf "${D}"/usr/libexec/bareos/grant_*_privileges
		rm -vf "${D}"/usr/libexec/bareos/*_catalog_backup
	fi
	if use clientonly || ! use storage-daemon; then
		if use systemd; then
			rm -vf "${D}"/lib/systemd/system/bareos-sd.service
		fi
		rm -vf "${D}"/usr/share/man/man8/bareos-sd.8*
		rm -vf "${D}"/usr/share/man/man8/bcopy.8*
		rm -vf "${D}"/usr/share/man/man8/bextract.8*
		rm -vf "${D}"/usr/share/man/man8/bls.8*
		rm -vf "${D}"/usr/share/man/man8/bscan.8*
		rm -vf "${D}"/usr/share/man/man8/btape.8*
		rm -vf "${D}"/usr/libexec/bareos/disk-changer
		rm -vf "${D}"/usr/libexec/bareos/mtx-changer
		rm -vf "${D}"/usr/libexec/bareos/dvd-handler
		rm -vf "${D}"/etc/bareos/mtx-changer.conf
	fi
	if ! use scsi-crypto; then
		rm -vf "${D}"/usr/share/man/man8/bscrypto.8*
	fi

	# documentation
	dodoc README.md
	dodoc core/README.configsubdirectories
	use glusterfs dodoc core/README.glusterfs
	use ndmp && dodoc core/README.NDMP
	use scsi-crypto && dodoc core/README.scsicrypto

	# vim-files
	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins core/scripts/bareos.vim
		insinto /usr/share/vim/vimfiles/ftdetect
		newins core/scripts/filetype.vim bareos_ft.vim
	fi

	# setup init scripts
	myscripts="bareos-fd"
	if ! use clientonly; then
		if use director; then
			myscripts+=" bareos-dir"
		fi
		if use storage-daemon; then
			myscripts+=" bareos-sd"
		fi
	fi
	for script in ${myscripts}; do
		# copy over init script and config to a temporary location
		# so we can modify them as needed
		cp "${FILESDIR}/${script}".confd "${T}/${script}".confd || die "failed to copy ${script}.confd"
		cp "${FILESDIR}/${script}".initd "${T}/${script}".initd || die "failed to copy ${script}.initd"

		# now set the database dependency for the director init script
		case "${script}" in
			bareos-dir)
				sed -i -e "s:%databasetypes%:${mydbtypes[*]}:" "${T}/${script}".confd || die
				;;
			*)
				;;
		esac

		# install init script and config
		newinitd "${T}/${script}".initd "${script}"
		newconfd "${T}/${script}".confd "${script}"
	done

	# install systemd unit files
	if use systemd; then
		if ! use clientonly; then
			use director && systemd_dounit core/platforms/systemd/bareos-dir.service
			use storage-daemon && systemd_dounit core/platforms/systemd/bareos-sd.service
		fi
		systemd_dounit core/platforms/systemd/bareos-fd.service
	fi

	# make sure the working directory exists
	diropts -m0750
	keepdir /var/lib/bareos
	keepdir /var/lib/bareos/storage

	diropts -m0755
	keepdir /var/log/bareos

	# make sure bareos group can execute bareos libexec scripts
	fowners -R root:bareos /usr/libexec/bareos
}

pkg_postinst() {
	if use clientonly; then
		fowners root:bareos /var/lib/bareos
	else
		fowners bareos:bareos /var/lib/bareos
	fi

	if ! use clientonly && use director; then
		einfo
		einfo "If this is a new install, you must create the database:"
		if use postgres; then
			einfo
			einfo "For postgresql:"
			einfo "  su postgres -c '/usr/libexec/bareos/create_bareos_database postgresql'"
			einfo "  su postgres -c '/usr/libexec/bareos/make_bareos_tables postgresql'"
			einfo "  su postgres -c '/usr/libexec/bareos/grant_bareos_privileges postgresql'"
		fi
		if use mysql; then
			einfo
			einfo "For mysql:"
			einfo
			einfo "  Make sure root has direct access to your mysql server. You may want to"
			einfo "  create a /root/.my.cnf file with"
			einfo "    [client]"
			einfo "    user=root"
			einfo "    password=YourPasswordForAccessingMysqlAsRoot"
			einfo "  before running:"
			einfo "  /usr/libexec/bareos/create_bareos_database mysql"
			einfo "  /usr/libexec/bareos/make_bareos_tables mysql"
			einfo "  /usr/libexec/bareos/grant_bareos_privileges mysql"
		fi
		einfo
	fi

	if use sqlite; then
		einfo
		einfo "Be aware that Bareos does not officially support SQLite database."
		einfo "Best use it only for a client-only installation. See Bug #445540."
		einfo
		einfo "It is strongly recommended to use either postgresql or mysql as"
		einfo "catalog database backend."
		einfo
	fi
}
