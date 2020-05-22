# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils linux-info

DESCRIPTION="Resource manager and queuing system based on OpenPBS"
HOMEPAGE="http://www.adaptivecomputing.com/products/open-source/torque"
# TODO:  hopefully moving to github tags soon
# http://www.supercluster.org/pipermail/torquedev/2013-May/004519.html
#SRC_URI="http://www.adaptivecomputing.com/index.php?wpfb_dl=2849 -> ${P}.tar.gz"
SRC_URI="https://github.com/adaptivecomputing/torque/archive/ddf5c4f40091b6157164a8846e5b60f42a5ae7f6.tar.gz -> ${P}-gh-20150517.tar.gz"

LICENSE="torque-2.5"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="cpusets +crypt doc drmaa kernel_linux libressl munge nvidia server +syslog tk"

DEPEND_COMMON="
	sys-libs/zlib
	sys-libs/readline:0=
	dev-libs/libxml2
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	cpusets? ( sys-apps/hwloc )
	munge? ( sys-auth/munge )
	nvidia? ( >=x11-drivers/nvidia-drivers-275 )
	tk? (
		dev-lang/tk:0=
		dev-lang/tcl:0=
	)
	syslog? ( virtual/logger )
	!!games-util/qstat"

# libncurses.so is only needed for configure check on readline
DEPEND="${DEPEND_COMMON}
	sys-libs/ncurses:*
	!!sys-cluster/slurm"

RDEPEND="${DEPEND_COMMON}
	crypt? ( net-misc/openssh )
	!crypt? ( net-misc/netkit-rsh )
	!dev-libs/uthash"

S="${WORKDIR}"/${PN}-ddf5c4f40091b6157164a8846e5b60f42a5ae7f6

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

	if use cpusets; then
		if ! use kernel_linux; then
			einfo
			elog "    Torque currently only has support for cpusets in linux."
			elog "Assuming you didn't really want this USE flag and ignoring its state."
			einfo
		else
			linux-info_pkg_setup
			if ! linux_config_exists || ! linux_chkconfig_present CPUSETS; then
				einfo
				elog "    Torque support for cpusets will require that you recompile"
				elog "your kernel with CONFIG_CPUSETS enabled."
				einfo
			fi
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

	eapply "${FILESDIR}"/${PN}-4.2.9-tcl8.6.patch
	eapply "${FILESDIR}"/${PN}-4.2-dont-mess-with-cflags.patch
	eapply "${FILESDIR}"/${PN}-4.2-use-NULL-instead-of-char0.patch
	eapply_user
	mkdir -p "${S}"/m4
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable tk gui) \
		$(use_enable syslog) \
		$(use_enable server) \
		$(use_enable drmaa) \
		$(use_enable munge munge-auth) \
		$(use_enable nvidia nvidia-gpus) \
		$(usex kernel_linux $(use_enable cpusets cpuset) --disable-cpuset) \
		$(usex crypt --with-rcp=scp --with-rcp=mom_rcp) \
		--with-server-home=${PBS_SERVER_HOME} \
		--with-environ=/etc/pbs_environment \
		--with-default-server=${PBS_SERVER_NAME} \
		--disable-gcc-warnings \
		--with-tcp-retry-limit=2 \
		--without-loadlibfile
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
	local showmessage=1
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		showmessage=0;
		elog "If this is the first time torque has been installed, then you are not"
		elog "ready to start the server.  Please refer to the documentation located at:"
		elog "http://docs.adaptivecomputing.com/torque/${PN//./-}/help.htm#topics/1-installConfig/initializeConfigOnServer.htm"
		elog
	else
		for i in ${REPLACING_VERSIONS} ; do
			if [[ ${i} == 4* ]]; then
				showmessage=0; break;
			fi
		done
	fi
	if [[ ${showmessage} -gt 0 ]]; then
		elog "Important v4.x changes:"
		elog "  - The on-wire protocol version has been changed."
		elog "    Versions of Torque before 4.0.0 are no longer able to communicate."
		elog "  - pbs_iff has been replaced by trqauthd, you will now need to add"
		elog "    trqauthd to your default runlevel."
	fi
}
