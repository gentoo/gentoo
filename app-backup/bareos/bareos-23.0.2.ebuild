# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
CMAKE_WARN_UNUSED_CLI=no

inherit python-any-r1 systemd cmake tmpfiles flag-o-matic

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/Release/${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/${PN}-Release-${PV}
fi

DESCRIPTION="Featureful client/server network backup suite"
HOMEPAGE="https://www.bareos.org/"

# some tests still fail propably due to missing bits in src_test -> TODO
RESTRICT="mirror test"
#RESTRICT="
#	mirror
#	!test? ( test )
#"

LICENSE="AGPL-3"
SLOT="0"
IUSE="X acl ceph clientonly cpu_flags_x86_avx +director glusterfs ipv6 lmdb
	logwatch ndmp readline scsi-crypto split-usr
	static +storage-daemon systemd tcpd test vim-syntax vmware xattr"

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
		dev-db/postgresql:*[threads(+)]
		director? (
			virtual/mta
		)
	)
	logwatch? ( sys-apps/logwatch )
	ndmp? ( net-libs/rpcsvc-proto )
	tcpd? ( sys-apps/tcp-wrappers )
	readline? ( sys-libs/readline:0 )
	static? (
		acl? ( virtual/acl[static-libs] )
		dev-libs/jansson:=[static-libs]
		dev-libs/lzo[static-libs]
		dev-libs/openssl:0=[static-libs]
		sys-libs/ncurses:=[static-libs]
		sys-libs/zlib[static-libs]
	)
	!static? (
		acl? ( virtual/acl )
		dev-libs/jansson:=
		dev-libs/lzo
		dev-libs/openssl:0=
		sys-libs/ncurses:=
		sys-libs/zlib
	)
	X? (
		dev-qt/qtwidgets:5=
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

BDEPEND="
	${PYTHON_DEPS}
	test? (
		dev-cpp/gtest
		dev-db/postgresql:*[server,threads(+)]
		dev-db/mariadb:*[server]
	)
"

REQUIRED_USE="
	static? ( clientonly )
	x86? ( !ceph )
"

PATCHES=(
	"${FILESDIR}/${PN}-21-cmake-gentoo.patch"
	"${FILESDIR}/${PN}-22.0.2-werror.patch"
	"${FILESDIR}/${PN}-21.1.2-no-automagic-ccache.patch"
)

pkg_pretend() {
	local active_removed_backend=""
	if has_version "<app-backup/bareos-21[director,mysql]"; then
		if grep -qhriE "dbdriver.*=.*mysql" /etc/bareos/; then
			active_removed_backend=MySQL
		fi
	elif has_version "<app-backup/bareos-21[director,sqlite]"; then
		if grep -qhriE "dbdriver.*=.*sqlite" /etc/bareos/; then
			active_removed_backend=SQLite
		fi
	fi
	if [[ -n $active_removed_backend ]]; then
		ewarn
		ewarn "You are currently using bareos with the $active_removed_backend"
		ewarn "catalog backend."
		ewarn
		ewarn "THIS IS NOT SUPPORTED ANYMORE"
		ewarn
		ewarn "Beginning with version 21.0.0 bareos has dropped support for"
		ewarn "MySQL and SQLite catalog backends."
		ewarn
		ewarn "To upgrade to bareos >=21.0.0 you need to migrate to PostgreSQL"
		ewarn "catalog backend using the 'bareos-dbcopy' tool of your current"
		ewarn "installation first."
		ewarn
		die "current catalog backend not supported anymore"
	fi
}

src_test() {
	# initialze catalog test database
	initdb -D "${T}"/pgsql || die
	pg_ctl -w -D "${T}"/pgsql start \
		-o "-h '' -k '${T}'" || die
	createuser -h "${T}" bareos || die
	createdb -h "${T}" --owner bareos bareos || die
	export PGHOST="${T}"

	# initiale mariadb database for backup tests
	# $USER must be set and != root
	export USER=portage

	default
	cmake_src_test

	pg_ctl -w -D "${T}"/pgsql stop || die
	rm -rvf "${T}"/pgsql
}

src_prepare() {
	# fix missing DESTDIR in symlink creation
	sed -i '/bareos-symlink-default-db-backend.cmake/d' "${S}/core/src/cats/CMakeLists.txt"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=()

	cmake_comment_add_subdirectory webui

	if use clientonly; then
		mycmakeargs+=(
			-Dclient-only=ON
			-Dstatic-cons=$(usex static)
			-Dstatic-fd=$(usex static)
		)
	fi

	for useflag in acl ipv6 ndmp scsi-crypto \
		systemd lmdb; do
		mycmakeargs+=( -D$useflag=$(usex $useflag) )
	done
	if use X; then
		mycmakeargs+=( -Dtraymonitor=yes )
	fi

	mycmakeargs+=(
		-DHAVE_PYTHON=0
		-Darchivedir=/var/lib/bareos/storage
		-Dbackenddir=/usr/$(get_libdir)/${PN}/backend
		-Dbasename="`hostname -s`"
		-Dbatch-insert=yes
		-Dbsrdir=/var/lib/bareos/bsr
		-Dconfdir=/etc/bareos
		-Dcoverage=no
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
		-Dopenssl=yes
		-Dpiddir=/run/bareos
		-Dplugindir=/usr/$(get_libdir)/${PN}/plugin
		-Dsbin-perm=0755
		-Dsbindir=/usr/sbin
		-Dscriptdir=/usr/libexec/bareos
		-Dsd-group=bareos
		-Dsd-password="`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`"
		-Dsd-user=root
		-Dsubsysdir=/run/lock/subsys
		-Dsysconfdir=/etc
		-Dworkingdir=/var/lib/bareos
		-Dx=$(usex X)
		)

		use cpu_flags_x86_avx && append-flags "-DXXH_X86DISPATCH_ALLOW_AVX"

		# disable droplet support for now as it does not build with gcc 10
		# ... and this is a bundled lib, which should have its own package
		cd core && cmake_comment_add_subdirectory "src/droplet"

		cmake_src_configure
}

src_install() {
	cmake_src_install

	# remove some scripts we don't need at all
	rm -f "${D}"/usr/libexec/bareos/{bareos,bareos-ctl-dir,bareos-ctl-fd,bareos-ctl-sd}
	rm -f "${D}"/usr/sbin/bareos

	# remove upstream init scripts and systemd units
	rm -f "${D}"/etc/init.d/bareos-* "${D}"/lib/systemd/system/bareos-*.service

	# remove misc stuff we do not need in production
	rm -f "${D}"/etc/bareos/bareos-regress.conf
	rm -f "${D}"/etc/logrotate.d/bareos-dir

	# remove duplicate binaries being installed in /usr/sbin and replace
	# them by symlinks to not break systems that still use split-usr
	if use split-usr; then
		for f in bwild bregex bsmtp bconsole; do
			rm -f "${D}/usr/sbin/$f" || die
			ln -s "../bin/$f" "${D}/usr/sbin/$f" || die
		done
	fi

	# get rid of py2 stuff
	rm -rf "$D"/usr/lib64/python2.7 || die
	rm -f "$D"/usr/lib64/bareos/plugin/python-fd.so || die
	if ! use vmware; then
		rm -f "$D"/usr/lib64/bareos/plugin/{BareosFdPluginVMware.py,bareos-fd-vmware.py}
	fi

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
		# install init script and config
		newinitd "${FILESDIR}/${script}-21-r1".initd "${script}"
		newconfd "${FILESDIR}/${script}-21".confd "${script}"
	done

	# install systemd unit files
	if use systemd; then
		if ! use clientonly; then
			use director && systemd_newunit "${FILESDIR}"/bareos-dir-21.service bareos-dir.service
			use storage-daemon && systemd_dounit "${FILESDIR}"/bareos-sd.service
		fi
		systemd_dounit "${FILESDIR}"/bareos-fd.service
	fi

	# make sure the working directory exists
	diropts -m0750
	keepdir /var/lib/bareos
	keepdir /var/lib/bareos/storage

	# set log directory ownership
	if ! use clientonly; then
		diropts -m0755 -o bareos -g bareos
	fi
	keepdir /var/log/bareos

	newtmpfiles "${FILESDIR}"/tmpfiles.d-bareos.conf bareos.conf

	# make sure bareos group can execute bareos libexec scripts
	fowners -R root:bareos /usr/libexec/bareos
}

pkg_postinst() {
	tmpfiles_process bareos.conf

	if use clientonly; then
		fowners root:bareos /var/lib/bareos
	else
		fowners bareos:bareos /var/lib/bareos
	fi

	if ! use clientonly && use director; then
		einfo
		einfo "If this is a new install, you must create the database:"
		einfo
		einfo "  su postgres -c '/usr/libexec/bareos/create_bareos_database'"
		einfo "  su postgres -c '/usr/libexec/bareos/make_bareos_tables'"
		einfo "  su postgres -c '/usr/libexec/bareos/grant_bareos_privileges'"
		einfo
		einfo "or run"
		einfo
		einfo " emerge --config app-backup/bareos"
		einfo
		einfo "to do this"
		einfo
		einfo "For major upgrades you may need to run:"
		einfo
		einfo "  su postgres -c '/usr/libexec/bareos/update_bareos_tables'"
		einfo
		einfo "Please see release notes for details."
		einfo "( https://docs.bareos.org/Appendix/ReleaseNotes.html )"
		einfo
	fi
}

pkg_config() {
	su postgres -c '/usr/libexec/bareos/create_bareos_database' || die "could not create bareos database"
	su postgres -c '/usr/libexec/bareos/make_bareos_tables' || die "could not create bareos database tables"
	su postgres -c '/usr/libexec/bareos/grant_bareos_privileges' || die "could not grant bareos database privileges"
}
