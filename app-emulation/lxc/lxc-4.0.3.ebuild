# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1 linux-info flag-o-matic pam readme.gentoo-r1 systemd

DESCRIPTION="LinuX Containers userspace utilities"
HOMEPAGE="https://linuxcontainers.org/ https://github.com/lxc/lxc"
SRC_URI="https://linuxcontainers.org/downloads/lxc/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

LICENSE="LGPL-3"
SLOT="0"
IUSE="apparmor +caps doc examples libressl pam seccomp selinux +ssl +templates +tools"

RDEPEND="app-misc/pax-utils
	sys-apps/util-linux
	sys-libs/libcap
	virtual/awk
	caps? ( sys-libs/libcap )
	pam? ( sys-libs/pam )
	seccomp? ( sys-libs/libseccomp )
	selinux? ( sys-libs/libselinux )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}
	>=app-text/docbook-sgml-utils-0.6.14-r2
	>=sys-kernel/linux-headers-3.2
	apparmor? ( sys-apps/apparmor )"
BDEPEND="doc? ( app-doc/doxygen )"
PDEPEND="templates? ( app-emulation/lxc-templates )"

CONFIG_CHECK="~CGROUPS ~CGROUP_DEVICE
	~CPUSETS ~CGROUP_CPUACCT
	~CGROUP_SCHED

	~NAMESPACES
	~IPC_NS ~USER_NS ~PID_NS

	~CGROUP_FREEZER
	~UTS_NS ~NET_NS
	~VETH ~MACVLAN

	~POSIX_MQUEUE
	~!NETPRIO_CGROUP"

ERROR_CGROUP_FREEZER="CONFIG_CGROUP_FREEZER:  needed to freeze containers"
ERROR_UTS_NS="CONFIG_UTS_NS:  needed to unshare hostnames and uname info"
ERROR_NET_NS="CONFIG_NET_NS:  needed for unshared network"
ERROR_VETH="CONFIG_VETH:  needed for internal (host-to-container) networking"
ERROR_MACVLAN="CONFIG_MACVLAN:  needed for internal (inter-container) networking"
ERROR_POSIX_MQUEUE="CONFIG_POSIX_MQUEUE:  needed for lxc-execute command"
ERROR_NETPRIO_CGROUP="CONFIG_NETPRIO_CGROUP:  as of kernel 3.3 and lxc 0.8.0_rc1 this causes LXCs to fail booting."

DOCS=( AUTHORS CONTRIBUTING MAINTAINERS NEWS README doc/FAQ.txt )

pkg_setup() {
	linux-info_pkg_setup
}

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.0-bash-completion.patch
	"${FILESDIR}"/${PN}-2.0.5-omit-sysconfig.patch # bug 558854
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing

	# --enable-doc is for manpages which is why we don't link it to a "doc"
	# USE flag. We always want man pages.
	local myeconfargs=(
		--bindir=/usr/bin
		--localstatedir=/var
		--sbindir=/usr/bin

		--with-config-path=/var/lib/lxc
		--with-distro=gentoo
		--with-init-script=systemd
		--with-rootfs-path=/var/lib/lxc/rootfs
		--with-runtime-path=/run
		--with-systemdsystemunitdir=$(systemd_get_systemunitdir)

		--disable-asan
		--disable-coverity-build
		--disable-dlog
		--disable-mutex-debugging
		--disable-rpath
		--disable-tests
		--disable-ubsan
		--disable-werror

		--enable-bash
		--enable-commands
		--enable-doc
		--enable-memfd-rexec
		--enable-thread-safety

		$(use_enable apparmor)
		$(use_enable caps capabilities)
		$(use_enable doc api-docs)
		$(use_enable examples)
		$(use_enable pam)
		$(use_enable seccomp)
		$(use_enable selinux)
		$(use_enable ssl openssl)
		$(use_enable tools)

		$(use_with pam pamdir $(getpam_mod_dir))
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	mv "${ED}"/usr/share/bash-completion/completions/${PN} "${ED}"/$(get_bashcompdir)/${PN}-start || die
	bashcomp_alias ${PN}-start \
		${PN}-{attach,cgroup,copy,console,create,destroy,device,execute,freeze,info,monitor,snapshot,stop,unfreeze,wait}

	keepdir /etc/lxc /var/lib/lxc/rootfs /var/log/lxc
	rmdir "${D}"/var/cache/lxc "${D}"/var/cache || die "rmdir failed"

	find "${D}" -name '*.la' -delete -o -name '*.a' -delete || die

	# Gentoo-specific additions!
	newinitd "${FILESDIR}/${PN}.initd.8" ${PN}

	# Remember to compare our systemd unit file with the upstream one
	# config/init/systemd/lxc.service.in
	systemd_newunit "${FILESDIR}"/${PN}_at.service.4.0.0 "lxc@.service"

	DOC_CONTENTS="
	For openrc, there is an init script provided with the package.
	You _should_ only need to symlink /etc/init.d/lxc to
	/etc/init.d/lxc.configname to start the container defined in
	/etc/lxc/configname.conf.

	Correspondingly, for systemd a service file lxc@.service is installed.
	Enable and start lxc@configname in order to start the container defined
	in /etc/lxc/configname.conf.

	If you want checkpoint/restore functionality, please install criu
	(sys-process/criu)."
	DISABLE_AUTOFORMATTING=true
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
