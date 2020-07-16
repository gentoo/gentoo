# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit python-single-r1 systemd

DESCRIPTION="Featureful client/server network backup suite"
HOMEPAGE="http://www.bareos.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/Release/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X acl cephfs clientonly +director fastlz glusterfs gnutls ipv6 jansson lmdb libressl
	logwatch mysql ndmp +postgres python rados rados-striper readline scsi-crypto
	sql-pooling sqlite ssl static +storage-daemon tcpd vim-syntax"
REQUIRED_USE="!clientonly? ( || ( mysql postgres sqlite ) )"

DEPEND="
	!app-backup/bacula
	acct-group/${PN}
	cephfs? ( sys-cluster/ceph )
	rados? ( sys-cluster/ceph )
	rados-striper? ( >=sys-cluster/ceph-0.94.2 )
	glusterfs? ( sys-cluster/glusterfs )
	lmdb? ( dev-db/lmdb )
	dev-libs/gmp:0
	!clientonly? (
		acct-user/${PN}
		postgres? ( dev-db/postgresql:*[threads] )
		mysql? ( dev-db/mysql-connector-c:0= )
		sqlite? ( dev-db/sqlite:3 )
		director? (
			virtual/mta
			jansson? ( dev-libs/jansson )
		)
	)
	fastlz? ( dev-libs/bareos-fastlzlib )
	logwatch? ( sys-apps/logwatch )
	tcpd? ( sys-apps/tcp-wrappers )
	readline? ( sys-libs/readline:0 )
	static? (
		acl? ( virtual/acl[static-libs] )
		sys-libs/zlib[static-libs]
		dev-libs/lzo[static-libs]
		sys-libs/ncurses:=[static-libs]
		ssl? (
			!gnutls? (
				!libressl? ( dev-libs/openssl:0=[static-libs] )
				libressl? ( dev-libs/libressl:0=[static-libs] )
			)
			gnutls? ( net-libs/gnutls[static-libs] )
		)
	)
	!static? (
		acl? ( virtual/acl )
		dev-libs/lzo
		ssl? (
			!gnutls? (
				!libressl? ( dev-libs/openssl:0= )
				libressl? ( dev-libs/libressl:0= )
			)
			gnutls? ( net-libs/gnutls )
		)
		sys-libs/ncurses:=
		sys-libs/zlib
	)
	python? ( ${PYTHON_DEPS} )
	"
RDEPEND="${DEPEND}
	!clientonly? (
		storage-daemon? (
			sys-block/mtx
			app-arch/mt-st
		)
	)
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"

REQUIRED_USE="static? ( clientonly )
	python? ( ${PYTHON_REQUIRED_USE} )"

S=${WORKDIR}/${PN}-Release-${PV}

pkg_setup() {
	use mysql && export mydbtypes+="mysql"
	use postgres && export mydbtypes+=" postgresql"
	use sqlite && export mydbtypes+=" sqlite"
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# adjusts default configuration files for several binaries
	# to /etc/bareos/<config> instead of ./<config>
	pushd src >&/dev/null || die
	for f in console/console.c dird/dird.c filed/filed.c \
		stored/bcopy.c stored/bextract.c stored/bls.c \
		stored/bscan.c stored/btape.c stored/stored.c; do
		sed -i -e 's|^\(#define CONFIG_FILE "\)|\1/etc/bareos/|g' "${f}" \
			|| die "sed on ${f} failed"
	done
	popd >&/dev/null || die

	# enables default database driver in catalog
	pushd src/defaultconfigs/bareos-dir.d/catalog >&/dev/null || die
		sed -i -e 's/#dbdriver/dbdriver/' -e '/XXX_REPLACE/d' MyCatalog.conf.in \
			|| die "sed on MyCatalog.conf.in failed"
	popd >&/dev/null || die

	# bug 466690 Use CXXFLAGS instead of CFLAGS
	sed -i -e 's/@CFLAGS@/@CXXFLAGS@/' autoconf/Make.common.in || die

	# do not strip binaries
	for d in filed console dird stored; do
		sed -i -e "s/strip /# strip /" src/$d/Makefile.in || die
	done

	eapply_user
}

src_configure() {
	local myconf=''

	addpredict /var/lib/logrotate.status

	if use clientonly; then
		myconf="${myconf} \
			$(use_enable clientonly client-only) \
			$(use_enable !static libtool) \
			$(use_enable static static-cons) \
			$(use_enable static static-fd)"
	fi

	myconf="${myconf} \
		$(use_with X x) \
		$(use_enable acl) \
		$(use_enable ipv6) \
		$(use_enable ndmp) \
		$(use_enable readline) \
		$(use_enable !readline conio) \
		$(use_enable scsi-crypto) \
		$(use_enable sql-pooling) \
		$(use_with fastlz) \
		$(use_with mysql) \
		$(use_with postgres postgresql) \
		$(use_with python) \
		$(use_with readline) \
		$(use_with sqlite sqlite3) \
		$(use sqlite || echo "--without-sqlite3") \
		$(use_with ssl openssl) \
		$(use_with tcpd tcp-wrappers) \
		$(use_enable lmdb) \
		$(use_with glusterfs) \
		$(use_with rados) \
		$(use_with rados-striper) \
		$(use_with cephfs) \
		$(use_with jansson) \
		"

	econf \
		--with-pid-dir=/run/bareos \
		--with-subsys-dir=/run/lock/subsys \
		--with-working-dir=/var/lib/bareos \
		--with-logdir=/var/log/bareos \
		--with-scriptdir=/usr/libexec/bareos \
		--with-plugindir=/usr/$(get_libdir)/${PN}/plugin \
		--with-backenddir=/usr/$(get_libdir)/${PN}/backend \
		--with-dir-user=bareos \
		--with-dir-group=bareos \
		--with-sd-user=root \
		--with-sd-group=bareos \
		--with-fd-user=root \
		--with-fd-group=bareos \
		--with-sbin-perm=0755 \
		--with-systemd \
		--with-db-password=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1` \
		--enable-dynamic-cats-backends \
		--enable-dynamic-storage-backends \
		--enable-batch-insert \
		--disable-afs \
		--host=${CHOST} \
		${myconf}
}

src_compile() {
	# Make build log verbose (bug #447806)
	emake NO_ECHO=""
}

src_install() {
	emake DESTDIR="${D}" install
	newicon src/images/bareos_logo_shadow.png bareos.png

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
		newins "${S}"/scripts/logrotate bareos

		# the logwatch scripts
		if use logwatch; then
			diropts -m0750
			dodir /etc/log.d/scripts/services
			dodir /etc/log.d/scripts/shared
			dodir /etc/log.d/conf/logfiles
			dodir /etc/log.d/conf/services
			pushd "${S}"/scripts/logwatch >&/dev/null || die
			emake DESTDIR="${D}" install
			popd >&/dev/null || die
		fi
	fi

	rm -vf "${D}"/usr/share/man/man1/bareos-bwxconsole.1*
	if use clientonly || ! use director; then
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
	use ndmp && dodoc README.NDMP
	use scsi-crypto && dodoc README.scsicrypto

	# vim-files
	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins scripts/bareos.vim
		insinto /usr/share/vim/vimfiles/ftdetect
		newins scripts/filetype.vim bareos_ft.vim
	fi

	# setup init scripts
	myscripts="bareos-fd"
	if ! use clientonly; then
		if use director; then
			myscripts="${myscripts} bareos-dir"
		fi
		if use storage-daemon; then
			myscripts="${myscripts} bareos-sd"
		fi
	fi
	for script in ${myscripts}; do
		# copy over init script and config to a temporary location
		# so we can modify them as needed
		cp "${FILESDIR}/${script}".confd-16 "${T}/${script}".confd || die "failed to copy ${script}.confd"
		cp "${FILESDIR}/${script}".initd "${T}/${script}".initd || die "failed to copy ${script}.initd"

		# now set the database dependency for the director init script
		case "${script}" in
			bareos-dir)
				sed -i -e "s:%databasetypes%:${mydbtypes}:" "${T}/${script}".confd || die
				;;
			*)
				;;
		esac

		# install init script and config
		newinitd "${T}/${script}".initd "${script}"
		newconfd "${T}/${script}".confd "${script}"
	done

	# install systemd unit files
	use director && systemd_dounit "${FILESDIR}"/bareos-dir.service
	use storage-daemon && systemd_dounit "${FILESDIR}"/bareos-sd.service
	systemd_dounit "${FILESDIR}"/bareos-fd.service

	# make sure the working directory exists
	diropts -m0750
	keepdir /var/lib/bareos

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
