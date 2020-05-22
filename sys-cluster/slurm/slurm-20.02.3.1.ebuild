# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/SchedMD/slurm.git"
	INHERIT_GIT="git-r3"
	MY_P="${P}"
else
	if [[ ${PV} == *pre* || ${PV} == *rc* ]]; then
		MY_PV=$(ver_rs '-0.') # pre-releases or release-candidate
	else
		MY_PV=$(ver_rs 1-4 '-') # stable releases
	fi
	MY_P="${PN}-${MY_PV}"
	INHERIT_GIT=""
	SRC_URI="https://github.com/SchedMD/slurm/archive/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit autotools bash-completion-r1 pam perl-module prefix toolchain-funcs systemd ${INHERIT_GIT}

DESCRIPTION="A Highly Scalable Resource Manager"
HOMEPAGE="https://www.schedmd.com https://github.com/SchedMD/slurm"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug hdf5 html ipmi json lua multiple-slurmd +munge mysql netloc numa ofed pam perl slurmdbd static-libs ucx torque X"

COMMON_DEPEND="
	!sys-cluster/torque
	!net-analyzer/slurm
	!net-analyzer/sinfo
	|| ( sys-cluster/pmix[-pmi] >=sys-cluster/openmpi-2.0.0 )
	mysql? (
		|| ( dev-db/mariadb-connector-c dev-db/mysql-connector-c )
		slurmdbd? ( || ( dev-db/mariadb dev-db/mysql ) )
		)
	munge? ( sys-auth/munge )
	pam? ( sys-libs/pam )
	lua? ( dev-lang/lua:0= )
	!lua? ( !dev-lang/lua )
	ipmi? ( sys-libs/freeipmi )
	json? ( dev-libs/json-c:= )
	amd64? ( netloc? ( || ( sys-apps/netloc >=sys-apps/hwloc-2.1.0[netloc] ) ) )
	hdf5? ( sci-libs/hdf5:= )
	numa? ( sys-process/numactl )
	ofed? ( sys-fabric/ofed )
	ucx? ( sys-cluster/ucx )
	X? ( net-libs/libssh2 )
	>=sys-apps/hwloc-1.1.1-r1
	sys-libs/ncurses:0=
	app-arch/lz4:0=
	sys-libs/readline:0="

DEPEND="${COMMON_DEPEND}
	html? ( sys-apps/man2html )"

RDEPEND="${OMMON_DEPEND}
	acct-user/slurm
	acct-group/slurm
	dev-libs/libcgroup"

REQUIRED_USE="torque? ( perl )"

S="${WORKDIR}/${PN}-${MY_P}"

LIBSLURM_PERL_S="${S}/contribs/perlapi/libslurm/perl"
LIBSLURMDB_PERL_S="${S}/contribs/perlapi/libslurmdb/perl"

RESTRICT="test"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
	else
		default
	fi
}

src_prepare() {
	tc-ld-disable-gold
	default

	# pids should go to /var/run/slurm
	sed \
		-e 's:/tmp:/var/tmp:g' \
		-e "s:/var/run/slurmctld.pid:${EPREFIX}/run/slurm/slurmctld.pid:g" \
		-e "s:/var/run/slurmd.pid:${EPREFIX}/run/slurm/slurmd.pid:g" \
		-e "s:StateSaveLocation=.*:StateSaveLocation=${EPREFIX}/var/spool/slurm:g" \
		-e "s:SlurmdSpoolDir=.*:SlurmdSpoolDir=${EPREFIX}/var/spool/slurm/slurmd:g" \
		-i "${S}/etc/slurm.conf.example" \
		|| die "Can't sed for /var/run/slurmctld.pid"
	sed \
		-e "s:/var/run/slurmdbd.pid:${EPREFIX}/run/slurm/slurmdbd.pid:g" \
		-i "${S}/etc/slurmdbd.conf.example" \
		|| die "Can't sed for /var/run/slurmdbd.pid"
	# gentooify systemd services
	sed \
		-e 's:sysconfig/.*:conf.d/slurm:g' \
		-e 's:var/run/:run/slurm/:g' \
		-e '/^EnvironmentFile=.*/d' \
		-i "${S}/etc"/*.service.in \
		|| die "Can't sed systemd services for sysconfig or var/run/"

	sed -e '/AM_PATH_GTK_2_0/d' -i configure.ac || die

	hprefixify auxdir/{ax_check_zlib,x_ac_{lz4,ofed,munge}}.m4
	eautoreconf
}

src_configure() {
	local myconf=(
		--sysconfdir="${EPREFIX}/etc/${PN}"
		--with-hwloc="${EPREFIX}/usr"
		--htmldir="${EPREFIX}/usr/share/doc/${PF}"
	)
	use pam && myconf+=( --with-pam_dir=$(getpam_mod_dir) )
	use mysql || myconf+=( --without-mysql_config )
	use amd64 && myconf+=( $(use_with netloc) )
	econf "${myconf[@]}" \
		$(use_enable debug) \
		$(use_enable pam) \
		$(use_enable X x11) \
		$(use_with munge) \
		$(use_with json) \
		$(use_with hdf5) \
		$(use_with ofed) \
		$(use_with ucx) \
		$(use_enable static-libs static) \
		$(use_enable multiple-slurmd)

	# --htmldir does not seems to propagate... Documentations are installed
	# in /usr/share/doc/slurm-2.3.0/html
	# instead of /usr/share/doc/slurm-2.3.0.2/html
	sed \
		-e "s|htmldir = .*/html|htmldir = \${prefix}/share/doc/slurm-${PVR}/html|g" \
		-i doc/html/Makefile || die
	if use perl ; then
		# small hack to make it compile
		mkdir -p "${S}/src/api/.libs" || die
		mkdir -p "${S}/src/db_api/.libs" || die
		touch "${S}/src/api/.libs/libslurm.so" || die
		touch "${S}/src/db_api/.libs/libslurmdb.so" || die
		cd "${LIBSLURM_PERL_S}" || die
		S="${LIBSLURM_PERL_S}" SRC_PREP="no" perl-module_src_configure
		cd "${LIBSLURMDB_PERL_S}" || die
		S="${LIBSLURMDB_PERL_S}" SRC_PREP="no" perl-module_src_configure
		cd "${S}" || die
		rm -rf "${S}/src/api/.libs" "${S}/src/db_api/.libs" || die
	fi
}

src_compile() {
	default
	use pam && emake -C contribs/pam
	if use perl ; then
		cd "${LIBSLURM_PERL_S}" || die
		S="${LIBSLURM_PERL_S}" perl-module_src_compile
		cd "${LIBSLURMDB_PERL_S}" || die
		S="${LIBSLURMDB_PERL_S}" perl-module_src_compile
		cd "${S}" || die
	fi
	use torque && emake -C contribs/torque
}

src_install() {
	default
	use pam && emake DESTDIR="${D}" -C contribs/pam install
	if use perl; then
		cd "${LIBSLURM_PERL_S}" || die
		S="${LIBSLURM_PERL_S}" perl-module_src_install
		cd "${LIBSLURMDB_PERL_S}" || die
		S="${LIBSLURMDB_PERL_S}" perl-module_src_install
		cd "${S}" || die
	fi
	if use torque; then
		emake DESTDIR="${D}" -C contribs/torque
		rm -f "${D}"/usr/bin/mpiexec || die
	fi
	use static-libs || find "${ED}" -name '*.la' -exec rm {} +
	# install sample configs
	keepdir /etc/slurm
	insinto /etc/slurm
	doins \
		etc/prolog.example \
		etc/cgroup.conf.example \
		etc/slurm.conf.example \
		etc/slurmdbd.conf.example
	exeinto /etc/slurm
	keepdir /etc/slurm/layouts.d
	insinto /etc/slurm/layouts.d
	newins etc/layouts.d.power.conf.example power.conf.example
	newins etc/layouts.d.power_cpufreq.conf.example power_cpufreq.conf.example
	newins etc/layouts.d.unit.conf.example unit.conf.example
	# install init.d files
	newinitd "$(prefixify_ro "${FILESDIR}/slurmd.initd")" slurmd
	newinitd "$(prefixify_ro "${FILESDIR}/slurmctld.initd")" slurmctld
	newinitd "$(prefixify_ro "${FILESDIR}/slurmdbd.initd")" slurmdbd
	# install conf.d files
	newconfd "${FILESDIR}/slurm.confd" slurm
	# install logrotate file
	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotate" slurm
	# install bashcomp
	newbashcomp contribs/slurm_completion_help/slurm_completion.sh scontrol
	bashcomp_alias scontrol \
		sreport sacctmgr squeue scancel sshare sbcast sinfo \
		sprio sacct salloc sbatch srun sattach sdiag sstat
	# install systemd files
	systemd_newtmpfilesd "${FILESDIR}/slurm.tmpfiles" slurm.conf
	systemd_dounit etc/slurmd.service etc/slurmctld.service etc/slurmdbd.service
}

pkg_preinst() {
	if use munge; then
		sed -i 's,\(SLURM_USE_MUNGE=\).*,\11,' "${D}"/etc/conf.d/slurm || die
	fi
}

create_folders_and_fix_permissions() {
	einfo "Fixing permissions in ${@}"
	mkdir -p ${@} || die
	chown -R ${PN}:${PN} ${@} || die
}

pkg_postinst() {
	paths=(
		"${EROOT}"/var/${PN}/checkpoint
		"${EROOT}"/var/${PN}
		"${EROOT}"/var/spool/${PN}/slurmd
		"${EROOT}"/var/spool/${PN}
		"${EROOT}"/var/log/${PN}
		/var/tmp/${PN}/${PN}d
		/var/tmp/${PN}
		/run/${PN}
	)
	local folder_path
	for folder_path in ${paths[@]}; do
		create_folders_and_fix_permissions $folder_path
	done
	echo

	elog "Please visit the file '/usr/share/doc/${P}/html/configurator.html"
	elog "through a (javascript enabled) browser to create a configureation file."
	elog "Copy that file to /etc/slurm/slurm.conf on all nodes (including the headnode) of your cluster."
	echo
	elog "For cgroup support, please see https://www.schedmd.com/slurmdocs/cgroup.conf.html"
	elog "Your kernel must be compiled with the wanted cgroup feature:"
	elog "    For the proctrack plugin:"
	elog "        freezer"
	elog "    For the task plugin:"
	elog "        cpuset, memory, devices"
	elog "    For the accounting plugin:"
	elog "        cpuacct, memory, blkio"
	elog "Then, set these options in /etc/slurm/slurm.conf:"
	elog "    ProctrackType=proctrack/cgroup"
	elog "    TaskPlugin=task/cgroup"
	einfo
	ewarn "Paths were created for slurm. Please use these paths in /etc/slurm/slurm.conf:"
	for folder_path in ${paths[@]}; do
		ewarn "    ${folder_path}"
	done
}
