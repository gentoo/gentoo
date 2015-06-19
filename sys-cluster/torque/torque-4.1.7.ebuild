# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/torque/torque-4.1.7.ebuild,v 1.12 2014/12/26 09:28:35 ago Exp $

EAPI=5

inherit flag-o-matic eutils linux-info

DESCRIPTION="Resource manager and queuing system based on OpenPBS"
HOMEPAGE="http://www.adaptivecomputing.com/products/open-source/torque"
# TODO:  hopefully moving to github tags soon
# http://www.supercluster.org/pipermail/torquedev/2013-May/004519.html
SRC_URI="http://www.adaptivecomputing.com/index.php?wpfb_dl=1690 -> ${P}.tar.gz"

LICENSE="torque-2.5"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="cpusets +crypt doc drmaa kernel_linux munge nvidia server +syslog tk"

DEPEND_COMMON="
	sys-libs/ncurses
	sys-libs/readline
	cpusets? ( sys-apps/hwloc )
	munge? ( sys-auth/munge )
	nvidia? ( >=x11-drivers/nvidia-drivers-275 )
	tk? ( dev-lang/tk )
	syslog? ( virtual/logger )
	!games-util/qstat"

DEPEND="${DEPEND_COMMON}
	!sys-cluster/slurm"

RDEPEND="${DEPEND_COMMON}
	crypt? ( net-misc/openssh )
	!crypt? ( net-misc/netkit-rsh )
	!dev-libs/uthash"

# Torque should depend on dev-libs/uthash but that's pretty much impossible
# to patch in as they ship with a broken configure such that files referenced
# by the configure.ac and Makefile.am are missing.
# http://www.supercluster.org/pipermail/torquedev/2014-October/004773.html

pkg_setup() {
	PBS_SERVER_HOME="${PBS_SERVER_HOME:-/var/spool/${PN}}"

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
	# Unused and causes breakage when switching from glibc to tirpc.
	# https://github.com/adaptivecomputing/torque/pull/148
	sed -i '/rpc\/rpc\.h/d' src/lib/Libnet/net_client.c || die

	# We install to a valid location, no need to muck with ld.so.conf
	# --without-loadlibfile is supposed to do this for us...
	sed -i '/mk_default_ld_lib_file || return 1/d' buildutils/pbs_mkdirs.in || die

	epatch "${FILESDIR}"/${PN}-4.1.5.1-tcl8.6.patch

	# 491270
	epatch "${FILESDIR}"/CVE-2013-4495.4.1.patch
}

src_configure() {
	local myconf="--with-rcp=mom_rcp"

	use crypt && myconf="--with-rcp=scp"

	econf \
		$(use_enable tk gui) \
		$(use_enable syslog) \
		$(use_enable server) \
		$(use_enable drmaa) \
		$(use_enable munge munge-auth) \
		$(use_enable nvidia nvidia-gpus) \
		--with-server-home=${PBS_SERVER_HOME} \
		--with-environ=/etc/pbs_environment \
		--with-default-server=${PBS_SERVER_NAME} \
		--disable-gcc-warnings \
		--with-tcp-retry-limit=2 \
		--without-loadlibfile \
		${USE_CPUSETS} \
		${myconf}
}

src_install() {
	local dir

	DOCS=( CHANGELOG README.* Release_Notes )
	use doc && DOCS+=( doc/admin_guide.ps doc/*.pdf )

	default

	# The build script isn't alternative install location friendly,
	# So we have to fix some hard-coded paths in tclIndex for xpbs* to work
	for file in $(find "${ED}" -iname tclIndex); do
		sed \
			-e "s/${ED//\// }/ /" \
			-i "${file}" || die
	done

	for dir in $(find "${ED}/${PBS_SERVER_HOME}" -type d); do
		keepdir "${dir#${ED}}"
	done

	if use server; then
		newinitd "${FILESDIR}"/pbs_server-init.d-munge pbs_server
		newinitd "${FILESDIR}"/pbs_sched-init.d pbs_sched
	fi
	newinitd "${FILESDIR}"/pbs_mom-init.d-munge pbs_mom
	newconfd "${FILESDIR}"/${PN}-conf.d-munge ${PN}
	newinitd "${FILESDIR}"/trqauthd-init.d trqauthd
	newenvd "${FILESDIR}"/${PN}-env.d 25${PN}
}

pkg_preinst() {
	if [[ -f "${ROOT}etc/pbs_environment" ]]; then
		cp "${ROOT}etc/pbs_environment" "${ED}"/etc/pbs_environment || die
	fi

	if use server && [[ -f "${ROOT}${PBS_SERVER_HOME}/server_priv/nodes" ]]; then
		cp \
			"${EROOT}${PBS_SERVER_HOME}/server_priv/nodes" \
			"${ED}/${PBS_SERVER_HOME}/server_priv/nodes" || die
	fi

	echo "${PBS_SERVER_NAME}" > "${ED}${PBS_SERVER_HOME}/server_name" || die

	# Fix up the env.d file to use our set server home.
	sed \
		-e "s:/var/spool/${PN}:${PBS_SERVER_HOME}:g" \
		-i "${ED}"/etc/env.d/25${PN} || die

	if use munge; then
		sed -i 's,\(PBS_USE_MUNGE=\).*,\11,' "${ED}"/etc/conf.d/${PN} || die
	fi
}

pkg_postinst() {
	elog "    If this is the first time torque has been installed, then you are not"
	elog "ready to start the server.  Please refer to the documentation located at:"
	elog "http://www.clusterresources.com/wiki/doku.php?id=torque:torque_wiki"
	echo ""
	elog "    For a basic setup, you may use emerge --config ${PN}"
	echo ""
	if [[ -z "${REPLACING_VERSIONS}" ]] || [[ ${REPLACING_VERSIONS} < 4 ]]; then
		elog "Important 4.0+ updates"
		elog "  - The on-wire protocol version has been changed."
		elog "    Versions of Torque before 4.0.0 are no longer able to communicate."
		elog "  - pbs_iff has been replaced by trqauthd, you will now need to add"
		elog "    trqauthd to your default runlevel."
	fi
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
		local qmgr="${EROOT}/usr/bin/qmgr -c"
		# pbs_server bails on repeated backslashes.
		if ! "${EROOT}"/usr/sbin/pbs_server -f -d "${h}" -t create; then
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

			"${EROOT}"/usr/bin/qterm -t quick ${PBS_SERVER_NAME} || rc=1

			# Add the local machine as a node.
			echo "$(hostname -f) np=1" > "${h}/server_priv/nodes" || die
		fi
	fi
	eend ${rc}
}
