# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools-utils eutils flag-o-matic linux-info

DESCRIPTION="Resource manager and queuing system based on OpenPBS"
HOMEPAGE="http://www.adaptivecomputing.com/products/open-source/torque"
SRC_URI="http://www.adaptivecomputing.com/index.php?wpfb_dl=1643 -> ${P}.tar.gz"

LICENSE="torque-2.5"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="cpusets +crypt doc drmaa kernel_linux munge server static-libs +syslog threads tk xml"

# ed is used by makedepend-sh
DEPEND_COMMON="sys-libs/ncurses
	sys-libs/readline
	munge? ( sys-auth/munge )
	tk? ( dev-lang/tk )
	syslog? ( virtual/logger )
	!games-util/qstat"

DEPEND="${DEPEND_COMMON}
	sys-apps/ed
	!sys-cluster/slurm"

RDEPEND="${DEPEND_COMMON}
	crypt? ( net-misc/openssh )
	!crypt? ( net-misc/netkit-rsh )"

DOCS=( Release_Notes )

AUTOTOOLS_IN_SOURCE_BUILD=1

pkg_setup() {
	PBS_SERVER_HOME="${PBS_SERVER_HOME:-/var/spool/torque}"

	# Find a Torque server to use.  Check environment, then
	# current setup (if any), and fall back on current hostname.
	if [ -z "${PBS_SERVER_NAME}" ]; then
		if [ -f "${ROOT}${PBS_SERVER_HOME}/server_name" ]; then
			PBS_SERVER_NAME="$(<${ROOT}${PBS_SERVER_HOME}/server_name)"
		else
			PBS_SERVER_NAME=$(hostname -f)
		fi
	fi

	USE_CPUSETS="--disable-cpuset"
	if use cpusets; then
		if ! use kernel_linux; then
			einfo
			elog "    Torque currently only has support for cpusets in linux."
			elog "Assuming you didn't really want this USE flag."
			einfo
		else
			linux-info_pkg_setup
			einfo
			elog "    Torque support for cpusets is still in development, you may"
			elog "wish to disable it for production use."
			einfo
			if ! linux_config_exists || ! linux_chkconfig_present CPUSETS; then
				einfo
				elog "    Torque support for cpusets will require that you recompile"
				elog "your kernel with CONFIG_CPUSETS enabled."
				einfo
			fi
			USE_CPUSETS="--enable-cpuset"
		fi
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/CVE-2013-4319-2.x-root-submit-fix.patch
	epatch "${FILESDIR}"/tcl8.6.patch

	# 510726
	epatch "${FILESDIR}"/CVE-2014-0749.patch

	# 491270
	epatch "${FILESDIR}"/CVE-2013-4495.patch

	# Unused and causes breakage when switching from glibc to tirpc.
	# https://github.com/adaptivecomputing/torque/pull/148
	sed -i '/rpc\/rpc\.h/d' src/lib/Libnet/net_client.c || die
}

src_configure() {
	local myeconfargs=( --with-rcp=mom_rcp )

	use crypt && myeconfargs=( --with-rcp=scp )

	myeconfargs+=(
		$(use_enable tk gui)
		$(use_enable tk tcl-qstat)
		$(use_enable syslog)
		$(use_enable server)
		$(use_enable drmaa)
		$(use_enable threads high-availability)
		$(use_enable xml server-xml)
		$(use_enable munge munge-library)
		--with-server-home=${PBS_SERVER_HOME}
		--with-environ=/etc/pbs_environment
		--with-default-server=${PBS_SERVER_NAME}
		--disable-gcc-warnings
		--with-tcp-retry-limit=2
		${USE_CPUSETS}
		)
	autotools-utils_src_configure
}

# WARNING
# OpenPBS is extremely stubborn about directory permissions. Sometimes it will
# just fall over with the error message, but in some spots it will just ignore
# you and fail strangely. Likewise it also barfs on our .keep files!
pbs_createspool() {
	local root="$1"
	local s="$(dirname "${PBS_SERVER_HOME}")"
	local h="${PBS_SERVER_HOME}"
	local sp="${h}/server_priv"
	einfo "Building spool directory under ${D}${h}"
	local a d m
	local dir_spec="
			0755:${h}/aux 0700:${h}/checkpoint
			0755:${h}/mom_logs 0751:${h}/mom_priv 0751:${h}/mom_priv/jobs
			1777:${h}/spool 1777:${h}/undelivered"

	if use server; then
		dir_spec="${dir_spec} 0755:${h}/sched_logs
			0755:${h}/sched_priv/accounting 0755:${h}/server_logs
			0750:${h}/server_priv 0755:${h}/server_priv/accounting
			0750:${h}/server_priv/acl_groups 0750:${h}/server_priv/acl_hosts
			0750:${h}/server_priv/acl_svr 0750:${h}/server_priv/acl_users
			0750:${h}/server_priv/jobs 0750:${h}/server_priv/queues"
	fi

	for a in ${dir_spec}; do
		d="${a/*:}"
		m="${a/:*}"
		if [[ ! -d "${root}${d}" ]]; then
			install -d -m${m} "${root}${d}" || die
		else
			chmod ${m} "${root}${d}" || die
		fi
		# (#149226) If we're running in src_*, then keepdir
		if [[ "${root}" = "${D}" ]]; then
			keepdir ${d}
		fi
	done
}

src_install() {
	# Make directories first
	pbs_createspool "${D}"

	autotools-utils_src_install

	use doc && dodoc doc/admin_guide.ps doc/*.pdf

	# The build script isn't alternative install location friendly,
	# So we have to fix some hard-coded paths in tclIndex for xpbs* to work
	for file in `find "${D}" -iname tclIndex`; do
		sed -e "s/${D//\// }/ /" "${file}" > "${file}.new"
		mv "${file}.new" "${file}" || die
	done

	if use server; then
		newinitd "${FILESDIR}"/pbs_server-init.d-munge pbs_server
		newinitd "${FILESDIR}"/pbs_sched-init.d pbs_sched
	fi
	newinitd "${FILESDIR}"/pbs_mom-init.d-munge pbs_mom
	newconfd "${FILESDIR}"/torque-conf.d-munge torque
	newenvd "${FILESDIR}"/torque-env.d 25torque
}

pkg_preinst() {
	if [[ -f "${ROOT}etc/pbs_environment" ]]; then
		cp "${ROOT}etc/pbs_environment" "${D}"/etc/pbs_environment || die
	fi

	echo "${PBS_SERVER_NAME}" > "${D}${PBS_SERVER_HOME}/server_name" || die

	# Fix up the env.d file to use our set server home.
	sed -i \
		"s:/var/spool/torque:${PBS_SERVER_HOME}:g" "${D}"/etc/env.d/25torque \
		|| die

	if use munge; then
		sed -i 's,\(PBS_USE_MUNGE=\).*,\11,' "${D}"etc/conf.d/torque || die
	fi
}

pkg_postinst() {
	pbs_createspool "${ROOT}"
	elog "    If this is the first time torque has been installed, then you are not"
	elog "ready to start the server.  Please refer to the documentation located at:"
	elog "http://www.clusterresources.com/wiki/doku.php?id=torque:torque_wiki"
	echo
	elog "    For a basic setup, you may use emerge --config ${PN}"
}

# root will be setup as the primary operator/manager, the local machine
# will be added as a node and we'll create a simple queue, batch.
pkg_config() {
	local h="$(echo "${ROOT}/${PBS_SERVER_HOME}" | sed 's:///*:/:g')"
	local rc=0

	ebegin "Configuring Torque"
	einfo "Using ${h} as the pbs homedir"
	einfo "Using ${PBS_SERVER_NAME} as the pbs_server"

	# Check for previous configuration and bail if found.
	if [ -e "${h}/server_priv/acl_svr/operators" ] \
		|| [ -e "${h}/server_priv/nodes" ] \
		|| [ -e "${h}/mom_priv/config" ]; then
		ewarn "Previous Torque configuration detected.  Press Enter to"
		ewarn "continue or Control-C to abort now"
		read
	fi

	# pbs_mom configuration.
	echo "\$pbsserver ${PBS_SERVER_NAME}" > "${h}/mom_priv/config" || die
	echo "\$logevent 255" >> "${h}/mom_priv/config" || die

	if use server; then
		local qmgr="${ROOT}/usr/bin/qmgr -c"
		# pbs_server bails on repeated backslashes.
		if ! "${ROOT}"/usr/sbin/pbs_server -f -d "${h}" -t create; then
			eerror "Failed to start pbs_server"
			rc=1
		else
			${qmgr} "set server operators = root@$(hostname -f)" ${PBS_SERVER_NAME} \
				&& ${qmgr} "create queue batch" ${PBS_SERVER_NAME} \
				&& ${qmgr} "set queue batch queue_type = Execution" ${PBS_SERVER_NAME} \
				&& ${qmgr} "set queue batch started = True" ${PBS_SERVER_NAME} \
				&& ${qmgr} "set queue batch enabled = True" ${PBS_SERVER_NAME} \
				&& ${qmgr} "set server default_queue = batch" ${PBS_SERVER_NAME} \
				&& ${qmgr} "set server resources_default.nodes = 1" ${PBS_SERVER_NAME} \
				&& ${qmgr} "set server scheduling = True" ${PBS_SERVER_NAME} \
				|| die

			"${ROOT}"/usr/bin/qterm -t quick ${PBS_SERVER_NAME} || rc=1

			# Add the local machine as a node.
			echo "$(hostname -f) np=1" > "${h}/server_priv/nodes" || die
		fi
	fi
	eend ${rc}
}
