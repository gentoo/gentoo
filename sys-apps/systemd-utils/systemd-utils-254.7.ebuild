# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

QA_PKGCONFIG_VERSION=$(ver_cut 1)

inherit bash-completion-r1 flag-o-matic linux-info meson-multilib python-single-r1
inherit secureboot toolchain-funcs udev usr-ldscript

DESCRIPTION="Utilities split out from systemd for OpenRC users"
HOMEPAGE="https://systemd.io/"

if [[ ${PV} == *.* ]]; then
	MY_P="systemd-stable-${PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/systemd/systemd-stable/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz"
else
	MY_P="systemd-${PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/systemd/systemd/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz"
fi

MUSL_PATCHSET="systemd-musl-patches-254.3"
SRC_URI+=" elibc_musl? ( https://dev.gentoo.org/~floppym/dist/${MUSL_PATCHSET}.tar.gz )"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+acl boot +kmod kernel-install selinux split-usr sysusers +tmpfiles test +udev ukify"
REQUIRED_USE="
	|| ( kernel-install tmpfiles sysusers udev )
	boot? ( kernel-install )
	ukify? ( boot )
	${PYTHON_REQUIRED_USE}
"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	elibc_musl? ( >=sys-libs/musl-1.2.3 )
	selinux? ( sys-libs/libselinux:0= )
	tmpfiles? (
		acl? ( sys-apps/acl:0= )
	)
	udev? (
		>=sys-apps/util-linux-2.30:0=[${MULTILIB_USEDEP}]
		sys-libs/libcap:0=[${MULTILIB_USEDEP}]
		virtual/libcrypt:=[${MULTILIB_USEDEP}]
		acl? ( sys-apps/acl:0= )
		kmod? ( >=sys-apps/kmod-15:0= )
	)
	!udev? (
		>=sys-apps/util-linux-2.30:0=
		sys-libs/libcap:0=
		virtual/libcrypt:=
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
		!sys-apps/hwids[udev]
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
	>=sys-apps/coreutils-8.16
	sys-devel/gettext
	virtual/pkgconfig
	$(python_gen_cond_dep "
		dev-python/jinja[\${PYTHON_USEDEP}]
		dev-python/lxml[\${PYTHON_USEDEP}]
		boot? ( >=dev-python/pyelftools-0.30[\${PYTHON_USEDEP}] )
		ukify? ( test? ( ${PEFILE_DEPEND} ) )
	")
"

TMPFILES_OPTIONAL=1
UDEV_OPTIONAL=1

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

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/${PN}-254.3-add-link-kernel-install-shared-option.patch"
	)

	if use elibc_musl; then
		PATCHES+=(
			"${WORKDIR}/${MUSL_PATCHSET}"
		)
	fi
	default

	# Remove install_rpath; we link statically
	local rpath_pattern="install_rpath : rootpkglibdir,"
	grep -q -e "${rpath_pattern}" meson.build || die
	sed -i -e "/${rpath_pattern}/d" meson.build || die
}

src_configure() {
	python_setup
	meson-multilib_src_configure
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_use split-usr)
		$(meson_use split-usr split-bin)
		-Drootprefix="$(usex split-usr "${EPREFIX:-/}" "${EPREFIX}/usr")"
		-Drootlibdir="${EPREFIX}/usr/$(get_libdir)"
		-Dsysvinit-path=
		$(meson_native_use_bool boot bootloader)
		$(meson_native_use_bool kernel-install)
		$(meson_native_use_bool selinux)
		$(meson_native_use_bool sysusers)
		$(meson_use test tests)
		$(meson_native_use_bool tmpfiles)
		$(meson_use udev hwdb)
		$(meson_native_use_bool ukify)

		# Link staticly with libsystemd-shared
		-Dlink-boot-shared=false
		-Dlink-kernel-install-shared=false
		-Dlink-udev-shared=false

		# systemd-tmpfiles has a separate "systemd-tmpfiles.standalone" target
		-Dstandalone-binaries=true

		# Disable all optional features
		-Dadm-group=false
		-Danalyze=false
		-Dapparmor=false
		-Daudit=false
		-Dbacklight=false
		-Dbinfmt=false
		-Dbpf-framework=false
		-Dbzip2=false
		-Dcoredump=false
		-Ddbus=false
		-Delfutils=false
		-Denvironment-d=false
		-Dfdisk=false
		-Dgcrypt=false
		-Dglib=false
		-Dgshadow=false
		-Dgnutls=false
		-Dhibernate=false
		-Dhostnamed=false
		-Didn=false
		-Dima=false
		-Dinitrd=false
		-Dfirstboot=false
		-Dldconfig=false
		-Dlibcryptsetup=false
		-Dlibcurl=false
		-Dlibfido2=false
		-Dlibidn=false
		-Dlibidn2=false
		-Dlibiptc=false
		-Dlocaled=false
		-Dlogind=false
		-Dlz4=false
		-Dmachined=false
		-Dmicrohttpd=false
		-Dnetworkd=false
		-Dnscd=false
		-Dnss-myhostname=false
		-Dnss-resolve=false
		-Dnss-systemd=false
		-Doomd=false
		-Dopenssl=false
		-Dp11kit=false
		-Dpam=false
		-Dpcre2=false
		-Dpolkit=false
		-Dportabled=false
		-Dpstore=false
		-Dpwquality=false
		-Drandomseed=false
		-Dresolve=false
		-Drfkill=false
		-Dseccomp=false
		-Dsmack=false
		-Dsysext=false
		-Dtimedated=false
		-Dtimesyncd=false
		-Dtpm=false
		-Dqrencode=false
		-Dquotacheck=false
		-Duserdb=false
		-Dutmp=false
		-Dvconsole=false
		-Dwheel-group=false
		-Dxdg-autostart=false
		-Dxkbcommon=false
		-Dxz=false
		-Dzlib=false
		-Dzstd=false
	)

	if use tmpfiles || use udev; then
		emesonargs+=( $(meson_native_use_bool acl) )
	else
		emesonargs+=( -Dacl=false )
	fi

	if use udev; then
		emesonargs+=( $(meson_native_use_bool kmod) )
	else
		emesonargs+=( -Dkmod=false )
	fi

	if use elibc_musl; then
		# Avoid redefinition of struct ethhdr.
		append-cppflags -D__UAPI_DEF_ETHHDR=0
	fi

	if multilib_is_native_abi || use udev; then
		meson_src_configure
	fi
}

efi_arch() {
	case "$(tc-arch)" in
		amd64) echo x64 ;;
		arm)   echo arm ;;
		arm64) echo aa64 ;;
		x86)   echo x86 ;;
	esac
}

multilib_src_compile() {
	local targets=()
	if multilib_is_native_abi; then
		if use boot; then
			targets+=(
				bootctl
				man/bootctl.1
				src/boot/efi/linux$(efi_arch).efi.stub
				src/boot/efi/systemd-boot$(efi_arch).efi
			)
		fi
		if use kernel-install; then
			targets+=(
				kernel-install
				90-loaderentry.install
				man/kernel-install.8
			)
		fi
		if use sysusers; then
			targets+=(
				systemd-sysusers.standalone
				man/sysusers.d.5
				man/systemd-sysusers.8
			)
			if use test; then
				targets+=(
					systemd-runtest.env
				)
			fi
		fi
		if use tmpfiles; then
			targets+=(
				systemd-tmpfiles.standalone
				man/tmpfiles.d.5
				man/systemd-tmpfiles.8
				tmpfiles.d/{etc,static-nodes-permissions,var}.conf
			)
			if use test; then
				targets+=( test-tmpfile-util )
			fi
		fi
		if use udev; then
			targets+=(
				udevadm
				systemd-hwdb
				src/udev/ata_id
				src/udev/cdrom_id
				src/udev/fido_id
				src/udev/mtd_probe
				src/udev/scsi_id
				src/udev/udev.pc
				src/udev/v4l_id
				man/udev.conf.5
				man/systemd.link.5
				man/hwdb.7
				man/udev.7
				man/systemd-hwdb.8
				man/systemd-udevd.service.8
				man/udevadm.8
				man/libudev.3
				man/udev_device_get_syspath.3
				man/udev_device_has_tag.3
				man/udev_device_new_from_syspath.3
				man/udev_enumerate_add_match_subsystem.3
				man/udev_enumerate_new.3
				man/udev_enumerate_scan_devices.3
				man/udev_list_entry.3
				man/udev_monitor_filter_update.3
				man/udev_monitor_new_from_netlink.3
				man/udev_monitor_receive_device.3
				man/udev_new.3
				hwdb.d/60-autosuspend-chromiumos.hwdb
				rules.d/50-udev-default.rules
				rules.d/60-persistent-storage.rules
				rules.d/64-btrfs.rules
			)
			if use test; then
				targets+=(
					test-fido-id-desc
					test-udev-builtin
					test-udev-event
					test-udev-node
					test-udev-util
					udev-rule-runner
				)
			fi
		fi
		if use ukify; then
			targets+=(
				ukify
				60-ukify.install
				man/ukify.1
			)
		fi
	fi
	if use udev; then
		targets+=(
			udev:shared_library
			src/libudev/libudev.pc
		)
		if use test; then
			targets+=(
				test-libudev
				test-libudev-sym
				test-udev-device-thread
			)
		fi
	fi
	if multilib_is_native_abi || use udev; then
		meson_src_compile "${targets[@]}"
	fi
}

multilib_src_test() {
	local tests=()
	if multilib_is_native_abi; then
		if use sysusers; then
			tests+=(
				test-sysusers.standalone
			)
		fi
		if use tmpfiles; then
			tests+=(
				test-systemd-tmpfiles.standalone
				test-tmpfile-util
			)
		fi
		if use udev; then
			tests+=(
				rule-syntax-check
				test-fido-id-desc
				test-udev
				test-udev-builtin
				test-udev-event
				test-udev-node
				test-udev-util
			)
		fi
	fi
	if use udev; then
		tests+=(
			test-libudev
			test-libudev-sym
			test-udev-device-thread
		)
	fi
	if [[ ${#tests[@]} -ne 0 ]]; then
		meson_src_test "${tests[@]}"
	fi
}

src_install() {
	local rootprefix="$(usex split-usr '' /usr)"
	meson-multilib_src_install
}

multilib_src_install() {
	if multilib_is_native_abi; then
		if use boot; then
			into /usr
			dobin bootctl
			doman man/bootctl.1
			insinto usr/lib/systemd/boot/efi
			doins src/boot/efi/{linux$(efi_arch).{efi,elf}.stub,systemd-boot$(efi_arch).efi}
		fi
		if use kernel-install; then
			dobin kernel-install
			doman man/kernel-install.8
			# copy the default set of plugins
			cp "${S}/src/kernel-install/"*.install src/kernel-install || die
			exeinto usr/lib/kernel/install.d
			doexe src/kernel-install/*.install
		fi
		if use sysusers; then
			into "${rootprefix:-/}"
			newbin systemd-sysusers{.standalone,}
			doman man/{systemd-sysusers.8,sysusers.d.5}
		fi
		if use tmpfiles; then
			into "${rootprefix:-/}"
			newbin systemd-tmpfiles{.standalone,}
			doman man/{systemd-tmpfiles.8,tmpfiles.d.5}
			insinto /usr/lib/tmpfiles.d
			doins tmpfiles.d/{etc,static-nodes-permissions,var}.conf
		fi
		if use udev; then
			into "${rootprefix:-/}"
			dobin udevadm systemd-hwdb
			dosym ../../bin/udevadm "${rootprefix}"/lib/systemd/systemd-udevd

			exeinto "${rootprefix}"/lib/udev
			doexe src/udev/{ata_id,cdrom_id,fido_id,mtd_probe,scsi_id,v4l_id}

			rm -f rules.d/99-systemd.rules
			insinto "${rootprefix}"/lib/udev/rules.d
			doins rules.d/*.rules

			insinto "${rootprefix}"/lib/udev/hwdb.d
			doins hwdb.d/*.hwdb

			insinto /usr/share/pkgconfig
			doins src/udev/udev.pc

			doman man/{udev.conf.5,systemd.link.5,hwdb.7,systemd-hwdb.8,udev.7,udevadm.8}
			newman man/systemd-udevd.service.8 systemd-udevd.8
			doman man/libudev.3
			doman man/udev_*.3
		fi
		if use ukify; then
			exeinto "${rootprefix}"/lib/systemd/
			doexe ukify
			doman man/ukify.1
		fi
	fi
	if use udev; then
		meson_install --no-rebuild --tags libudev
		gen_usr_ldscript -a udev
		insinto "/usr/$(get_libdir)/pkgconfig"
		doins src/libudev/libudev.pc
	fi
}

multilib_src_install_all() {
	einstalldocs
	if use boot; then
		into /usr
		exeinto usr/lib/kernel/install.d
		doexe src/kernel-install/*.install
		dobashcomp shell-completion/bash/bootctl
		insinto /usr/share/zsh/site-functions
		doins shell-completion/zsh/{_bootctl,_kernel-install}
	fi
	if use tmpfiles; then
		doinitd "${FILESDIR}"/systemd-tmpfiles-setup
		doinitd "${FILESDIR}"/systemd-tmpfiles-setup-dev
		exeinto /etc/cron.daily
		doexe "${FILESDIR}"/systemd-tmpfiles-clean
		insinto /usr/share/zsh/site-functions
		doins shell-completion/zsh/_systemd-tmpfiles
		insinto /usr/lib/tmpfiles.d
		doins tmpfiles.d/{tmp,x11}.conf
		doins "${FILESDIR}"/legacy.conf
	fi
	if use udev; then
		doheader src/libudev/libudev.h

		insinto /etc/udev
		doins src/udev/udev.conf
		keepdir /etc/udev/{hwdb.d,rules.d}

		insinto "${rootprefix}"/lib/systemd/network
		doins network/99-default.link

		# Remove to avoid conflict with elogind
		# https://bugs.gentoo.org/856433
		rm rules.d/70-power-switch.rules || die
		insinto "${rootprefix}"/lib/udev/rules.d
		doins rules.d/*.rules
		doins "${FILESDIR}"/40-gentoo.rules

		insinto "${rootprefix}"/lib/udev/hwdb.d
		doins hwdb.d/*.hwdb

		dobashcomp shell-completion/bash/udevadm

		insinto /usr/share/zsh/site-functions
		doins shell-completion/zsh/_udevadm
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
