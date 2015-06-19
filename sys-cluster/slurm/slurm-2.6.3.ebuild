# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/slurm/slurm-2.6.3.ebuild,v 1.4 2014/12/28 16:58:09 titanofold Exp $

EAPI=5

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://github.com/SchedMD/slurm.git"
	INHERIT_GIT="git-2"
	SRC_URI=""
	KEYWORDS=""
else
	inherit versionator
	if [[ ${PV} == *pre* || ${PV} == *rc* ]]; then
		MY_PV=$(replace_version_separator 3 '-0.') # pre-releases or release-candidate
	else
		MY_PV=$(replace_version_separator 3 '-') # stable releases
	fi
	MY_P="${PN}-${MY_PV}"
	INHERIT_GIT=""
	SRC_URI="http://www.schedmd.com/download/total/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

inherit autotools base eutils pam perl-module user ${INHERIT_GIT}

DESCRIPTION="SLURM: A Highly Scalable Resource Manager"
HOMEPAGE="http://www.schedmd.com"

LICENSE="GPL-2"
SLOT="0"
IUSE="lua maui multiple-slurmd +munge mysql pam perl postgres ssl static-libs torque ypbind"

DEPEND="
	!sys-cluster/torque
	!net-analyzer/slurm
	!net-analyzer/sinfo
	mysql? ( virtual/mysql )
	munge? ( sys-auth/munge )
	ypbind? ( net-nds/ypbind )
	pam? ( virtual/pam )
	postgres? ( dev-db/postgresql )
	ssl? ( dev-libs/openssl )
	lua? ( dev-lang/lua )
	!lua? ( !dev-lang/lua )
	>=sys-apps/hwloc-1.1.1-r1"
RDEPEND="${DEPEND}
	dev-libs/libcgroup
	maui? ( sys-cluster/maui[slurm] )"

REQUIRED_USE="torque? ( perl )"

LIBSLURM_PERL_S="${WORKDIR}/${P}/contribs/perlapi/libslurm/perl"
LIBSLURMDB_PERL_S="${WORKDIR}/${P}/contribs/perlapi/libslurmdb/perl"

RESTRICT="primaryuri"

PATCHES=(
	"${FILESDIR}/${PN}-2.5.4-nogtk.patch"
)

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-2_src_unpack
	else
		default
	fi
}

pkg_setup() {
	enewgroup slurm 500
	enewuser slurm 500 -1 /var/spool/slurm slurm
}

src_prepare() {
	# Gentoo uses /sys/fs/cgroup instead of /cgroup
	# FIXME: Can the "^/cgroup" and "\([ =\"]\)/cgroup" patterns be merged?
	sed \
		-e 's|\([ =\"]\)/cgroup|\1/sys/fs/cgroup|g' \
		-e "s|^/cgroup|/sys/fs/cgroup|g" \
		-i "${S}/doc/man/man5/cgroup.conf.5" \
		-i "${S}/etc/cgroup.release_common.example" \
		-i "${S}/src/common/xcgroup_read_config.c" \
			|| die "Can't sed /cgroup for /sys/fs/cgroup"
	# and pids should go to /var/run/slurm
	sed -e 's:/var/run/slurmctld.pid:/var/run/slurm/slurmctld.pid:g' \
		-e 's:/var/run/slurmd.pid:/var/run/slurm/slurmd.pid:g' \
		-i "${S}/etc/slurm.conf.example" \
			|| die "Can't sed for /var/run/slurmctld.pid"
	# also state dirs are in /var/spool/slurm
	sed -e 's:StateSaveLocation=*.:StateSaveLocation=/var/spool/slurm:g' \
		-e 's:SlurmdSpoolDir=*.:SlurmdSpoolDir=/var/spool/slurm/slurmd:g' \
		-i "${S}/etc/slurm.conf.example" \
			|| die "Can't sed ${S}/etc/slurm.conf.example for StateSaveLocation=*. or SlurmdSpoolDir=*"
	# and tmp should go to /var/tmp/slurm
	sed -e 's:/tmp:/var/tmp:g' \
		-i "${S}/etc/slurm.conf.example" \
			|| die "Can't sed for StateSaveLocation=*./tmp"
	# disable sview since it need gtk+
	sed -e '/sview/d' \
		-i configure.ac
	sed -e 's:sview::g' \
		-i src/Makefile.am
	# apply patches
	epatch "${PATCHES[@]}"
	elibtoolize
	eautoreconf
}

src_configure() {
	local myconf=(
			--sysconfdir="${EPREFIX}/etc/${PN}"
			--with-hwloc="${EPREFIX}/usr"
			--docdir="${EPREFIX}/usr/share/doc/${P}"
			--htmldir="${EPREFIX}/usr/share/doc/${P}"
			)
	use pam && myconf+=( --with-pam_dir=$(getpam_mod_dir) )
	use mysql || myconf+=( --without-mysql_config )
	use postgres || myconf+=( --without-pg_config )
	econf "${myconf[@]}" \
		$(use_enable pam) \
		$(use_with ssl) \
		$(use_with munge) \
		$(use_enable static-libs static) \
		$(use_enable multiple-slurmd)

	# --htmldir does not seems to propagate... Documentations are installed
	# in /usr/share/doc/slurm-2.3.0/html
	# instead of /usr/share/doc/slurm-2.3.0.2/html
	sed -e "s|htmldir = .*/html|htmldir = \${prefix}/share/doc/slurm-${PVR}/html|g" -i doc/html/Makefile || die
	if use perl ; then
		# small hack to make it compile
		mkdir -p "${S}/src/api/.libs"
		mkdir -p "${S}/src/db_api/.libs"
		touch "${S}/src/api/.libs/libslurm.so"
		touch "${S}/src/db_api/.libs/libslurmdb.so"
		cd "${LIBSLURM_PERL_S}"
		S="${LIBSLURM_PERL_S}" SRC_PREP="no" perl-module_src_configure
		cd "${LIBSLURMDB_PERL_S}"
		S="${LIBSLURMDB_PERL_S}" SRC_PREP="no" perl-module_src_configure
		cd "${S}"
		rm -rf "${S}/src/api/.libs" "${S}/src/db_api/.libs"
	fi
}

src_compile() {
	default
	use pam && emake -C contribs/pam || die
	if use perl ; then
		cd "${LIBSLURM_PERL_S}"
		S="${LIBSLURM_PERL_S}" perl-module_src_compile
		cd "${LIBSLURMDB_PERL_S}"
		S="${LIBSLURMDB_PERL_S}" perl-module_src_compile
		cd "${S}"
	fi
	if use torque ; then
		emake -C contribs/torque || die
	fi
}

src_install() {
	default
	use pam && emake DESTDIR="${D}" -C contribs/pam install || die
	if use perl; then
		cd "${LIBSLURM_PERL_S}"
		S="${LIBSLURM_PERL_S}" perl-module_src_install
		cd "${LIBSLURMDB_PERL_S}"
		S="${LIBSLURMDB_PERL_S}" perl-module_src_install
		cd "${S}"
	fi
	if use torque; then
		emake DESTDIR="${D}" -C contribs/torque || die
		rm -f "${ED}/usr/bin/mpiexec" || die
	fi
	use static-libs || find "${ED}" -name '*.la' -exec rm {} +
	# install sample configs
	keepdir /etc/slurm
	insinto /etc/slurm
	doins etc/bluegene.conf.example
	doins etc/cgroup.conf.example
	doins etc/cgroup_allowed_devices_file.conf.example
	doins etc/slurm.conf.example
	doins etc/slurmdbd.conf.example
	exeinto /etc/slurm
	doexe etc/cgroup.release_common.example
	doexe etc/slurm.epilog.clean
	# install init.d files
	newinitd "${FILESDIR}/slurmd.initd" slurmd
	newinitd "${FILESDIR}/slurmctld.initd" slurmctld
	newinitd "${FILESDIR}/slurmdbd.initd" slurmdbd
	# install conf.d files
	newconfd "${FILESDIR}/slurm.confd" slurm
	# Install logrotate file
	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotate" slurm || die
	# cgroups support
	exeinto /etc/slurm/cgroup
	doexe etc/cgroup.release_common.example
	mv "${D}"/etc/slurm/cgroup/cgroup.release_common.example "${D}"/etc/slurm/cgroup/release_common || die "Can't move cgroup.release_common.example"
	ln -s release_common "${D}"/etc/slurm/cgroup/release_cpuset  || die "Can't create symbolic link release_cpuset"
	ln -s release_common "${D}"/etc/slurm/cgroup/release_devices || die "Can't create symbolic link release_devices"
	ln -s release_common "${D}"/etc/slurm/cgroup/release_freezer || die "Can't create symbolic link release_freezer"
}

pkg_preinst() {
	if use munge; then
		sed -i 's,\(SLURM_USE_MUNGE=\).*,\11,' "${D}"etc/conf.d/slurm || die
	fi
	if use ypbind; then
		sed -i 's,\(SLURM_USE_YPBIND=\).*,\11,' "${D}"etc/conf.d/slurm || die
	fi
}

create_folders_and_fix_permissions() {
	einfo "Fixing permissions in ${@}"
	mkdir -p ${@}
	chown -R ${PN}:${PN} ${@}
}

pkg_postinst() {
	paths=(
		/var/${PN}/checkpoint
		/var/${PN}
		/var/spool/${PN}/slurmd
		/var/spool/${PN}
		/var/run/${PN}
		/var/log/${PN}
		/var/tmp/${PN}/${PN}d
		/var/tmp/${PN}
		)
	for folder_path in ${paths[@]}; do
		create_folders_and_fix_permissions $folder_path
	done
	einfo

	elog "Please visit the file '/usr/share/doc/${P}/html/configurator.html"
	elog "through a (javascript enabled) browser to create a configureation file."
	elog "Copy that file to /etc/slurm/slurm.conf on all nodes (including the headnode) of your cluster."
	einfo
	elog "For cgroup support, please see http://www.schedmd.com/slurmdocs/cgroup.conf.html"
	elog "Your kernel must be compiled with the wanted cgroup feature:"
	elog "    General setup  --->"
	elog "        [*] Control Group support  --->"
	elog "            [*]   Freezer cgroup subsystem"
	elog "            [*]   Device controller for cgroups"
	elog "            [*]   Cpuset support"
	elog "            [*]   Simple CPU accounting cgroup subsystem"
	elog "            [*]   Resource counters"
	elog "            [*]     Memory Resource Controller for Control Groups"
	elog "            [*]   Group CPU scheduler  --->"
	elog "                [*]   Group scheduling for SCHED_OTHER"
	elog "Then, set these options in /etc/slurm/slurm.conf:"
	elog "    ProctrackType=proctrack/cgroup"
	elog "    TaskPlugin=task/cgroup"
	einfo
	ewarn "Paths were created for slurm. Please use these paths in /etc/slurm/slurm.conf:"
	for folder_path in ${paths[@]}; do
		ewarn "    ${folder_path}"
	done
}
