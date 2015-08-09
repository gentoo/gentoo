# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit eutils multilib python-single-r1 qt4-r2 user

DESCRIPTION="Featureful client/server network backup suite"
HOMEPAGE="http://www.bareos.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/Release/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acl clientonly +director fastlz ipv6 logwatch mysql ndmp postgres python qt4
		readline scsi-crypto sql-pooling +sqlite ssl static +storage-daemon tcpd
		vim-syntax X cephfs glusterfs lmdb rados"

DEPEND="
	!app-backup/bacula
	cephfs? ( sys-cluster/ceph )
	rados? ( sys-cluster/ceph )
	glusterfs? ( sys-cluster/glusterfs )
	lmdb? ( dev-db/lmdb )
	dev-libs/gmp:0
	!clientonly? (
		postgres? ( dev-db/postgresql:*[threads] )
		mysql? ( virtual/mysql )
		sqlite? ( dev-db/sqlite:3 )
		director? ( virtual/mta )
	)
	qt4? (
		dev-qt/qtsvg:4
		x11-libs/qwt:5
	)
	fastlz? ( dev-libs/bareos-fastlzlib )
	logwatch? ( sys-apps/logwatch )
	tcpd? ( sys-apps/tcp-wrappers )
	readline? ( sys-libs/readline:0 )
	static? (
		acl? ( virtual/acl[static-libs] )
		sys-libs/zlib[static-libs]
		dev-libs/lzo[static-libs]
		sys-libs/ncurses[static-libs]
		ssl? ( dev-libs/openssl:0[static-libs] )
	)
	!static? (
		acl? ( virtual/acl )
		dev-libs/lzo
		ssl? ( dev-libs/openssl:0 )
		sys-libs/ncurses
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

	# create the daemon group and user
	if [ -z "$(egetent group bareos 2>/dev/null)" ]; then
		enewgroup bareos
		einfo
		einfo "The group 'bareos' has been created. Any users you add to this"
		einfo "group have access to files created by the daemons."
		einfo
	fi

	if use clientonly && use static && use qt4; then
		ewarn
		ewarn "Building statically linked 'bat' is not supported. Ignorig 'qt4' useflag."
		ewarn
	fi

	if ! use clientonly; then
		if [ -z "$(egetent passwd bareos 2>/dev/null)" ]; then
			enewuser bareos -1 -1 /var/lib/bareos bareos,disk,tape,cdrom,cdrw
			einfo
			einfo "The user 'bareos' has been created.  Please see the bareos manual"
			einfo "for information about running bareos as a non-root user."
			einfo
		fi
	fi

	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# adjusts default configuration files for several binaries
	# to /etc/bareos/<config> instead of ./<config>
	pushd src >&/dev/null || die
	for f in console/console.c dird/dird.c filed/filed.c \
		stored/bcopy.c stored/bextract.c stored/bls.c \
		stored/bscan.c stored/btape.c stored/stored.c \
		qt-console/main.cpp; do
		sed -i -e 's|^\(#define CONFIG_FILE "\)|\1/etc/bareos/|g' "${f}" \
			|| die "sed on ${f} failed"
	done
	popd >&/dev/null || die

	# bug 466690 Use CXXFLAGS instead of CFLAGS
	sed -i -e 's/@CFLAGS@/@CXXFLAGS@/' autoconf/Make.common.in || die

	# stop build for errors in subdirs
	epatch "${FILESDIR}"/${PN}-12.4.5-Makefile.patch

	# bat needs to respect LDFLAGS
	epatch "${FILESDIR}"/${PN}-12.4.5-bat-ldflags.patch

	# do not strip binaries
	for d in filed console dird stored; do
		sed -i -e "s/strip /# strip /" src/$d/Makefile.in || die
	done
}

src_configure() {
	local myconf=''

	if use clientonly; then
		myconf="${myconf} \
			$(use_enable clientonly client-only) \
			$(use_enable !static libtool) \
			$(use_enable static static-cons) \
			$(use_enable static static-fd)"
	fi

	# do not build bat and traymonitor if 'static' clientonly
	if ! use clientonly || ! use static; then
		myconf="${myconf} \
			$(use_enable qt4 bat) \
			$(use_enable qt4 traymonitor)"
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
		$(use_with cephfs) \
		"

	econf \
		--libdir=/usr/$(get_libdir) \
		--docdir=/usr/share/doc/${PF} \
		--htmldir=/usr/share/doc/${PF}/html \
		--with-pid-dir=/run/bareos \
		--sysconfdir=/etc/bareos \
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
		--enable-smartalloc \
		--enable-dynamic-cats-backends \
		--enable-dynamic-storage-backends \
		--enable-batch-insert \
		--disable-afs \
		--host=${CHOST} \
		${myconf}
	# correct configuration for QT based bat
	if use qt4 ; then
		pushd src/qt-console
		eqmake4
		popd
		pushd src/qt-tray-monitor
		eqmake4
		popd
	fi
}

src_compile() {
	# workaround for build failing with high -j values
	# if ndmp is enabled
	use ndmp && MAKEOPTS="$MAKEOPTS -j1"

	# Make build log verbose (bug #447806)
	emake NO_ECHO=""
}

src_install() {
	emake DESTDIR="${D}" install
	doicon scripts/bareos.png

	# install bat icon and desktop file when enabled
	# (for some reason ./configure doesn't pick this up)
	if use qt4 && ! use static ; then
		doicon src/images/bat.png
		domenu scripts/bat.desktop
	fi

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
	if ! use qt4; then
		rm -vf "${D}"/usr/share/man/man1/bat.1*
	fi
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
	if ! use qt4; then
		rm -vf "${D}"/usr/share/man/man1/bareos-tray-monitor.1*
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
		cp "${FILESDIR}/${script}".confd "${T}/${script}".confd || die "failed to copy ${script}.confd"
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
		einfo "If this is a new install, you must create the databases with:"
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

	einfo "Please note that 'bconsole' will always be installed. To compile 'bat'"
	einfo "you have to enable 'USE=qt4'."
	einfo
}
