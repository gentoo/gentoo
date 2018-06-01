# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/SchedMD/slurm.git"
	INHERIT_GIT="git-r3"
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
	SRC_URI="https://download.schedmd.com/slurm/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

inherit autotools bash-completion-r1 eutils pam perl-module prefix user ${INHERIT_GIT}

DESCRIPTION="A Highly Scalable Resource Manager"
HOMEPAGE="https://www.schedmd.com"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug lua multiple-slurmd +munge mysql pam perl ssl static-libs torque X"

DEPEND="
	!sys-cluster/torque
	!net-analyzer/slurm
	!net-analyzer/sinfo
	sys-cluster/pmix[-pmi]
	mysql? ( virtual/mysql )
	munge? ( sys-auth/munge )
	pam? ( virtual/pam )
	ssl? ( dev-libs/openssl:0= )
	lua? ( dev-lang/lua:0= )
	!lua? ( !dev-lang/lua )
	X? ( net-libs/libssh2 )
	>=sys-apps/hwloc-1.1.1-r1"
RDEPEND="${DEPEND}
	dev-libs/libcgroup"

REQUIRED_USE="torque? ( perl )"

LIBSLURM_PERL_S="${WORKDIR}/${P}/contribs/perlapi/libslurm/perl"
LIBSLURMDB_PERL_S="${WORKDIR}/${P}/contribs/perlapi/libslurmdb/perl"

RESTRICT="primaryuri test"

PATCHES=(
	"${FILESDIR}"/${P}-disable-sview.patch
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
	default

	# pids should go to /var/run/slurm
	sed -e "s:/var/run/slurmctld.pid:${EPREFIX}/var/run/slurm/slurmctld.pid:g" \
		-e "s:/var/run/slurmd.pid:${EPREFIX}/var/run/slurm/slurmd.pid:g" \
		-i "${S}/etc/slurm.conf.example" \
			|| die "Can't sed for /var/run/slurmctld.pid"
	# also state dirs are in /var/spool/slurm
	sed -e "s:StateSaveLocation=*.:StateSaveLocation=${EPREFIX}/var/spool/slurm:g" \
		-e "s:SlurmdSpoolDir=*.:SlurmdSpoolDir=${EPREFIX}/var/spool/slurm/slurmd:g" \
		-i "${S}/etc/slurm.conf.example" \
			|| die "Can't sed ${S}/etc/slurm.conf.example for StateSaveLocation=*. or SlurmdSpoolDir=*"
	# and tmp should go to /var/tmp/slurm
	sed -e 's:/tmp:/var/tmp:g' \
		-i "${S}/etc/slurm.conf.example" \
			|| die "Can't sed for StateSaveLocation=*./tmp"

	hprefixify auxdir/{ax_check_zlib,x_ac_{lz4,ofed,munge}}.m4
	eautoreconf
}

src_configure() {
	local myconf=(
			--sysconfdir="${EPREFIX}/etc/${PN}"
			--with-hwloc="${EPREFIX}/usr"
			--docdir="${EPREFIX}/usr/share/doc/${P}"
			--htmldir="${EPREFIX}/usr/share/doc/${P}"
			)
	use debug || myconf+=( --disable-debug )
	use pam && myconf+=( --with-pam_dir=$(getpam_mod_dir) )
	use mysql || myconf+=( --without-mysql_config )
	econf "${myconf[@]}" \
		$(use_enable pam) \
		$(use_enable X x11) \
		$(use_with ssl) \
		$(use_with munge) \
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
		rm -f "${ED}/usr/bin/mpiexec" || die
	fi
	use static-libs || find "${ED}" -name '*.la' -exec rm {} +
	# install sample configs
	keepdir /etc/slurm
	insinto /etc/slurm
	doins \
		etc/bluegene.conf.example \
		etc/cgroup.conf.example \
		etc/cgroup_allowed_devices_file.conf.example \
		etc/slurm.conf.example \
		etc/slurmdbd.conf.example
	exeinto /etc/slurm
	doexe \
		etc/slurm.epilog.clean
	# install init.d files
	newinitd "$(prefixify_ro ${FILESDIR}/slurmd.initd)" slurmd
	newinitd "$(prefixify_ro ${FILESDIR}/slurmctld.initd)" slurmctld
	newinitd "$(prefixify_ro ${FILESDIR}/slurmdbd.initd)" slurmdbd
	# install conf.d files
	newconfd "${FILESDIR}/slurm.confd" slurm
	# Install logrotate file
	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotate" slurm

	newbashcomp contribs/slurm_completion_help/slurm_completion.sh scontrol
	bashcomp_alias scontrol \
		sreport sacctmgr squeue scancel sshare sbcast sinfo \
		sprio sacct salloc sbatch srun sattach sdiag sstat
}

pkg_preinst() {
	if use munge; then
		sed -i 's,\(SLURM_USE_MUNGE=\).*,\11,' "${ED}"etc/conf.d/slurm || die
	fi
}

create_folders_and_fix_permissions() {
	einfo "Fixing permissions in ${@}"
	mkdir -p ${@}
	chown -R ${PN}:${PN} ${@}
}

pkg_postinst() {
	paths=(
		"${EROOT}"var/${PN}/checkpoint
		"${EROOT}"var/${PN}
		"${EROOT}"var/spool/${PN}/slurmd
		"${EROOT}"var/spool/${PN}
		"${EROOT}"var/run/${PN}
		"${EROOT}"var/log/${PN}
		/var/tmp/${PN}/${PN}d
		/var/tmp/${PN}
		)
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
