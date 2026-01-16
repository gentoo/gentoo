# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )
QA_PKGCONFIG_VERSION=$(ver_cut 1)

# Avoid QA warnings about these eclasses
TMPFILES_OPTIONAL=1
UDEV_OPTIONAL=1

inherit linux-info meson-multilib
inherit python-single-r1 secureboot shell-completion udev

DESCRIPTION="Utilities split out from systemd for OpenRC users"
HOMEPAGE="https://systemd.io/"

MY_P="systemd-${PV}"
SRC_URI="https://github.com/systemd/systemd/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+acl boot +kmod kernel-install selinux split-usr sysusers +tmpfiles test +udev ukify"
REQUIRED_USE="
	|| ( kernel-install tmpfiles sysusers udev )
	boot? ( kernel-install )
	ukify? ( boot )
	${PYTHON_REQUIRED_USE}
"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	virtual/libcrypt:=
	selinux? ( sys-libs/libselinux:0= )
	tmpfiles? (
		acl? ( sys-apps/acl:0= )
	)
	udev? (
		>=sys-apps/util-linux-2.30:0=
		acl? ( sys-apps/acl:0= )
		kmod? ( >=sys-apps/kmod-15:0= )
	)
"
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-3.11
"

PEFILE_DEPEND='dev-python/pefile[${PYTHON_USEDEP}]'

RDEPEND="${COMMON_DEPEND}
	boot? ( !<sys-boot/systemd-boot-250 )
	ukify? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep "${PEFILE_DEPEND}")
	)
	tmpfiles? ( !<sys-apps/systemd-tmpfiles-250 )
	udev? (
		acct-group/audio
		acct-group/cdrom
		acct-group/dialout
		acct-group/disk
		acct-group/floppy
		acct-group/input
		acct-group/kmem
		acct-group/kvm
		acct-group/lp
		acct-group/render
		acct-group/sgx
		acct-group/tape
		acct-group/tty
		acct-group/usb
		acct-group/video
		!sys-apps/gentoo-systemd-integration
		!<sys-fs/udev-250
		!sys-fs/eudev
	)
	!sys-apps/systemd
"
PDEPEND="
	udev? ( >=sys-fs/udev-init-scripts-34 )
"
BDEPEND="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/gperf
	dev-util/patchelf
	>=sys-apps/coreutils-8.16
	sys-devel/gettext
	virtual/pkgconfig
	$(python_gen_cond_dep "
		dev-python/jinja2[\${PYTHON_USEDEP}]
		dev-python/lxml[\${PYTHON_USEDEP}]
		boot? (
			>=dev-python/pyelftools-0.30[\${PYTHON_USEDEP}]
			test? ( ${PEFILE_DEPEND} )
		)
	")
"

QA_EXECSTACK="usr/lib/systemd/boot/efi/*"
QA_FLAGS_IGNORED="usr/lib/systemd/boot/efi/.*"

CONFIG_CHECK="~BLK_DEV_BSG ~DEVTMPFS ~!IDE ~INOTIFY_USER ~!SYSFS_DEPRECATED
	~!SYSFS_DEPRECATED_V2 ~SIGNALFD ~EPOLL ~FHANDLE ~NET ~UNIX"

pkg_setup() {
	if [[ ${MERGE_TYPE} != buildonly ]] && use udev; then
		linux-info_pkg_setup
	fi
	use boot && secureboot_pkg_setup
}

src_configure() {
	python_setup
	meson-multilib_src_configure
}

multilib_src_configure() {
	local emesonargs=(
		--auto-features=disabled
		--localstatedir="${EPREFIX}/var"
		-Ddocdir="share/doc/${PF}"

		# default is developer, bug 918671
		-Dmode=release
		-Dlibc=$(usex elibc_musl musl glibc)
		-Dsysvinit-path=

		$(meson_native_use_feature boot bootloader)
		$(meson_native_use_bool kernel-install)
		$(meson_native_enabled man)
		$(meson_native_use_feature selinux)
		$(meson_use split-usr split-bin)
		$(meson_native_use_bool sysusers)
		$(meson_use test tests)
		$(meson_native_use_bool tmpfiles)
		$(meson_native_use_feature udev blkid)
		$(meson_native_use_feature udev libmount)
		$(meson_use udev hwdb)
		$(meson_native_use_feature ukify)

		-Dadm-group=false
		-Danalyze=false
		-Dbacklight=false
		-Dbinfmt=false
		-Dcreate-log-dirs=false
		-Dcoredump=false
		-Ddns-over-tls=false
		-Denvironment-d=false
		-Dhibernate=false
		-Dhostnamed=false
		-Didn=false
		-Dima=false
		-Dinitrd=false
		-Dipe=false
		-Dfirstboot=false
		-Dldconfig=false
		-Dlocaled=false
		-Dlogind=false
		-Dmachined=false
		-Dmountfsd=false
		-Dnetworkd=false
		-Dnsresourced=false
		-Dnss-myhostname=false
		-Dnss-systemd=false
		-Doomd=false
		-Dportabled=false
		-Dpstore=false
		-Dquotacheck=false
		-Drandomseed=false
		-Dresolve=false
		-Drfkill=false
		-Dsmack=false
		-Dstoragetm=false
		-Dsysext=false
		-Dtimedated=false
		-Dtimesyncd=false
		-Dtpm=false
		-Durlify=false
		-Duserdb=false
		-Dutmp=false
		-Dvconsole=false
		-Dwheel-group=false
		-Dxdg-autostart=false
		-Dxenctrl=false

		-Dbashcompletiondir=no
		-Drpmmacrosdir=no
		-Dshellprofiledir=no
		-Dsshconfdir=no
		-Dsshdconfdir=no
		-Dsshdprivsepdir=no
		-Dzshcompletiondir=no
	)

	if use tmpfiles || use udev; then
		emesonargs+=( $(meson_native_use_feature acl) )
	fi

	if use udev; then
		emesonargs+=( $(meson_native_use_feature kmod) )
	fi

	meson_src_configure
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		meson_src_compile
	elif use udev; then
		local targets=( libudev src/libudev/libudev.pc )
		if use test; then
			targets+=( test-libudev test-libudev-sym test-udev-device-thread )
		fi
		meson_src_compile "${targets[@]}"
	fi
}

multilib_src_test() {
	local tests=()
	if use udev; then
		tests+=( --suite libudev )
	fi
	if multilib_is_native_abi; then
		if use boot; then
			tests+=( --suite boot )
		fi
		if use kernel-install; then
			tests+=( --suite kernel-install )
		fi
		if use sysusers; then
			tests+=( --suite sysusers )
		fi
		if use tmpfiles; then
			tests+=( --suite tmpfiles )
		fi
		if use udev; then
			tests+=( --suite udev )
		fi
	fi
	if [[ ${#tests[@]} -ne 0 ]]; then
		meson_src_test --no-rebuild "${tests[@]}"
	fi
}

installx() {
	local dir f
	for f in "$@"; do
		dir="${f%/*}"
		dir="/${dir#/}"
		dodir "${dir}"
		mv -v "${ed}"/${f#/} "${ED}${dir}/" || die
	done
}

multilib_src_install() {
	local d="${WORKDIR}/install"
	local ed="${d}${EPREFIX}"

	if use udev; then
		meson_install --no-rebuild --tags libudev
		insinto "/usr/$(get_libdir)/pkgconfig"
		doins src/libudev/libudev.pc
	fi

	multilib_is_native_abi || return

	meson_install --no-rebuild --destdir "${d}"

	installx "usr/$(get_libdir)/systemd/libsystemd-shared-${PV%%.*}.so"
	installx usr/share/locale
	installx usr/lib/sysctl.d

	if use boot; then
		installx usr/bin/bootctl
		installx usr/share/man/man1/bootctl.1
		installx usr/lib/systemd/boot
	fi

	if use kernel-install; then
		installx usr/bin/kernel-install
		installx usr/share/man/man8/kernel-install.8
		installx usr/lib/kernel
	fi

	if use sysusers; then
		installx usr/bin/systemd-sysusers
		installx usr/share/man/{man5/sysusers.d.5,man8/systemd-sysusers.8}
	fi

	if use tmpfiles; then
		installx usr/bin/systemd-tmpfiles
		installx usr/lib/tmpfiles.d/{etc,home,static-nodes-permissions,var}.conf
		installx usr/share/man/{man5/tmpfiles.d.5,man8/systemd-tmpfiles.8}
	fi

	if use udev; then
		installx etc/udev
		installx usr/bin/systemd-hwdb
		installx usr/bin/udevadm
		if use split-usr; then
			# elogind installs udev rules that hard-code /bin/udevadm
			dosym ../usr/bin/udevadm /bin/udevadm
		fi
		installx usr/lib/systemd/systemd-sysctl
		installx usr/lib/systemd/systemd-udevd
		installx usr/lib/systemd/network/99-default.link
		installx usr/lib/udev
		installx usr/share/pkgconfig/udev.pc
		installx usr/share/man/man5/{iocost.conf.5,systemd.link.5,udev.conf.5}
		installx usr/share/man/man7/{hwdb.7,udev.7}
		installx usr/share/man/man8/{systemd-hwdb.8,udevadm.8}
		mv -v "${ed}"/usr/share/man/man8/systemd-udevd.service.8 \
			"${ED}"/usr/share/man/man8/systemd-udevd.8 || die
		installx usr/share/man/man3/libudev.3 "usr/share/man/man3/udev_*"
	fi

	if use ukify; then
		installx usr/bin/ukify usr/lib/systemd/ukify
		installx usr/share/man/man1/ukify.1
	fi
}

multilib_src_install_all() {
	einstalldocs

	if use boot; then
		dobashcomp shell-completion/bash/bootctl
		dozshcomp shell-completion/zsh/_bootctl
	fi

	if use kernel-install; then
		dobashcomp shell-completion/bash/kernel-install
		dozshcomp shell-completion/zsh/_kernel-install
	fi

	if use tmpfiles; then
		#dobashcomp shell-completion/zsh/systemd-tmpfiles
		dozshcomp shell-completion/zsh/_systemd-tmpfiles
		insinto /usr/lib/tmpfiles.d
		doins "${FILESDIR}"/{legacy,tmp}.conf
		doinitd "${FILESDIR}"/systemd-tmpfiles-setup
		doinitd "${FILESDIR}"/systemd-tmpfiles-setup-dev
		exeinto /etc/cron.daily
		doexe "${FILESDIR}"/systemd-tmpfiles-clean
	fi

	if use udev; then
		doheader src/libudev/libudev.h
		dobashcomp shell-completion/bash/udevadm
		dozshcomp shell-completion/zsh/_udevadm
		udev_dorules "${FILESDIR}"/40-gentoo.rules
	fi

	use ukify && python_fix_shebang "${ED}"
	use boot && secureboot_auto_sign
}

add_service() {
	local initd=$1
	local runlevel=$2

	ebegin "Adding '${initd}' service to the '${runlevel}' runlevel"
	mkdir -p "${EROOT}/etc/runlevels/${runlevel}" &&
	ln -snf "${EPREFIX}/etc/init.d/${initd}" "${EROOT}/etc/runlevels/${runlevel}/${initd}"
	eend $?
}

pkg_preinst() {
	# Migrate /lib/{systemd,udev} to /usr/lib
	if use split-usr; then
		local d
		for d in systemd udev; do
			dosym ../usr/lib/${d} /lib/${d}
			if [[ -e ${EROOT}/lib/${d} && ! -L ${EROOT}/lib/${d} ]]; then
				einfo "Copying files from '${EROOT}/lib/${d}' to '${EROOT}/usr/lib/${d}'"
				cp -rpPT "${EROOT}/lib/${d}" "${EROOT}/usr/lib/${d}" || die
				einfo "Removing '${EROOT}/lib/${d}'"
				rm -r "${EROOT}/lib/${d}" || die
			fi
		done
	fi
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		add_service systemd-tmpfiles-setup-dev sysinit
		add_service systemd-tmpfiles-setup boot
	fi
	if use udev; then
		ebegin "Updating hwdb"
		systemd-hwdb --root="${ROOT}" update
		eend $?
		udev_reload
	fi
}
