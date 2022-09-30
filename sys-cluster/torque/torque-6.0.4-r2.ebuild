# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_COMMIT="6a0b37f85c7d644e9217cbab1542792d646f59a6"
inherit autotools flag-o-matic linux-info toolchain-funcs

DESCRIPTION="Resource manager and queuing system based on OpenPBS"
HOMEPAGE="http://www.adaptivecomputing.com/products/open-source/torque"
SRC_URI="https://github.com/adaptivecomputing/torque/archive/${MY_COMMIT}.tar.gz -> ${P}-gh-20170829.tar.gz
	https://dev.gentoo.org/~juippis/distfiles/tmp/torque-6.0.4-gcc7.patch
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-6.0.4-glibc-2.34-pthread.patch.bz2"

LICENSE="torque-2.5"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="autorun cgroups cpusets +crypt doc munge nvidia quickcommit server +syslog tk"

DEPEND_COMMON="
	sys-libs/zlib
	sys-libs/readline:0=
	dev-libs/libxml2
	dev-libs/boost
	cpusets? ( sys-apps/hwloc:= )
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

# Torque should depend on dev-libs/uthash but that's pretty much impossible
# to patch in as they ship with a broken configure such that files referenced
# by the configure.ac and Makefile.am are missing.
# http://www.supercluster.org/pipermail/torquedev/2014-October/004773.html

S="${WORKDIR}"/${PN}-6a0b37f85c7d644e9217cbab1542792d646f59a6

PATCHES=(
	"${DISTDIR}"/${P}-gcc7.patch
	"${FILESDIR}"/${PN}-6.0.3-fix-emptystring-comparison.patch
	"${FILESDIR}"/${P}-no-openssl.patch
	"${FILESDIR}"/${P}-error_buf_overflow_prevent.patch
	"${WORKDIR}"/${P}-glibc-2.34-pthread.patch
	"${FILESDIR}"/${P}-pthreads-deux.patch
)

pkg_setup() {
	PBS_SERVER_HOME="${PBS_SERVER_HOME:-/var/spool/${PN}}"

	# Find a Torque server to use.  Check environment, then
	# current setup (if any), and fall back on current hostname.
	if [[ -z "${PBS_SERVER_NAME}" ]]; then
		if [ -f "${EROOT}/${PBS_SERVER_HOME}/server_name" ]; then
			PBS_SERVER_NAME="$(<${EROOT}/${PBS_SERVER_HOME}/server_name)"
		else
			PBS_SERVER_NAME=$(hostname -f)
		fi
	fi

	if use cpusets || use cgroups; then
		if ! use kernel_linux; then
			einfo
			elog "    Torque currently only has support for cpusets and cgroups in linux."
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
	default
	# We install to a valid location, no need to muck with ld.so.conf
	# --without-loadlibfile is supposed to do this for us...
	sed -i '/mk_default_ld_lib_file || return 1/d' buildutils/pbs_mkdirs.in || die
	eautoreconf
}

src_configure() {
	append-cflags "-fpermissive"

	# Force Bash for configure as there's a lot of issues with configure.ac and such here
	CONFIG_SHELL="${BROOT}/bin/bash" econf \
		$(use_enable tk gui) \
		$(use_enable tk tcl-qstat) \
		$(use_enable syslog) \
		$(use_enable server) \
		--disable-drmaa \
		$(use_enable munge munge-auth) \
		$(use_enable nvidia nvidia-gpus) \
		$(usex crypt "--with-rcp=scp" "--with-rcp=mom_rcp") \
		$(usex kernel_linux $(use_enable cpusets cpuset) --disable-cpuset) \
		$(usex kernel_linux $(use_enable cgroups) --disable-cgroups) \
		$(use_enable autorun) \
		$(use_enable quickcommit) \
		--with-server-home=${PBS_SERVER_HOME} \
		--with-environ=/etc/pbs_environment \
		--with-default-server=${PBS_SERVER_NAME} \
		--disable-gcc-warnings \
		--disable-silent-rules \
		--with-tcp-retry-limit=2 \
		--without-loadlibfile
}

src_compile() {
	# The .c files are C++, and $(CC) is misused.
	emake CC="$(tc-getCXX)"
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
	if [[ -f "${EROOT}/etc/pbs_environment" ]]; then
		cp "${EROOT}/etc/pbs_environment" "${ED}"/etc/pbs_environment || die
	fi

	if use server && [[ -f "${EROOT}/${PBS_SERVER_HOME}/server_priv/nodes" ]]; then
		cp \
			"${EROOT}/${PBS_SERVER_HOME}/server_priv/nodes" \
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
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog "If this is the first time torque has been installed, then you are not"
		elog "ready to start the server.  Please refer to the documentation located at:"
		elog "http://docs.adaptivecomputing.com/torque/${PV//./-}/adminGuide/torquehelp.htm#topics/torque/1-installConfig/initializeConfigOnServer.htm"
	fi
}
