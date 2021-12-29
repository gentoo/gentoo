# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )

inherit bash-completion-r1 meson-multilib python-any-r1 toolchain-funcs usr-ldscript

DESCRIPTION="Utilities taken from systemd"
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

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+boot selinux +tmpfiles test +udev"
REQUIRED_USE="|| ( boot tmpfiles udev )"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	sys-apps/acl:0=
	>=sys-apps/kmod-15:0=
	selinux? ( sys-libs/libselinux:0= )
	udev? (
		>=sys-apps/util-linux-2.30:0=[${MULTILIB_USEDEP}]
		sys-libs/libcap:0=[${MULTILIB_USEDEP}]
		virtual/libcrypt:=[${MULTILIB_USEDEP}]
	)
	!udev? (
		>=sys-apps/util-linux-2.30:0=
		sys-libs/libcap:0=
		virtual/libcrypt:=
	)
"
DEPEND="${COMMON_DEPEND}
	boot? (
		>=sys-boot/gnu-efi-3.0.2
	)
	>=sys-kernel/linux-headers-3.11
"
RDEPEND="${COMMON_DEPEND}
	boot? ( !sys-boot/systemd-boot )
	tmpfiles? ( !sys-apps/systemd-tmpfiles )
	udev? (
		acct-group/audio
		acct-group/cdrom
		acct-group/dialout
		acct-group/disk
		acct-group/input
		acct-group/kmem
		acct-group/kvm
		acct-group/lp
		acct-group/render
		acct-group/sgx
		acct-group/tape
		acct-group/tty
		acct-group/video
		!sys-apps/gentoo-systemd-integration
		!sys-apps/hwids[udev]
		!sys-fs/udev
	)
	!sys-apps/systemd
"
PDEPEND="
	udev? ( >=sys-fs/udev-init-scripts-34 )
"
BDEPEND="
	$(python_gen_any_dep 'dev-python/jinja[${PYTHON_USEDEP}]')
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/gperf
	>=sys-apps/coreutils-8.16
	sys-devel/gettext
	virtual/pkgconfig
"

python_check_deps() {
	has_version -b "dev-python/jinja[${PYTHON_USEDEP}]"
}

QA_EXECSTACK="usr/lib/systemd/boot/efi/*"
QA_FLAGS_IGNORED="usr/lib/systemd/boot/efi/.*"

src_prepare() {
	default
	sed -i -e '/install_rpath : rootlibexecdir,/d' meson.build || die
}

multilib_src_configure() {
	local disable_options=(
		adm-group
		analyze
		apparmor
		audit
		backlight
		binfmt
		bzip2
		coredump
		dbus
		elfutils
		environment-d
		fdisk
		gcrypt
		glib
		gshadow
		gnutls
		hibernate
		hostnamed
		idn
		ima
		initrd
		firstboot
		kernel-install
		kmod
		ldconfig
		libcryptsetup
		libcurl
		libfido2
		libidn
		libidn2
		libiptc
		link-boot-shared
		link-networkd-shared
		link-systemctl-shared
		link-timesyncd-shared
		link-udev-shared
		localed
		logind
		lz4
		machined
		microhttpd
		networkd
		nscd
		nss-myhostname
		nss-resolve
		nss-systemd
		oomd
		openssl
		p11kit
		pam
		pcre2
		polkit
		portabled
		pstore
		pwquality
		randomseed
		resolve
		rfkill
		seccomp
		smack
		sysext
		sysusers
		timedated
		timesyncd
		tpm
		qrencode
		quotacheck
		userdb
		utmp
		vconsole
		wheel-group
		xdg-autostart
		xkbcommon
		xz
		zlib
		zstd
	)

	local emesonargs=(
		-Drootprefix="${EPREFIX:-/}"
		-Dstandalone-binaries=true
		-Dsysvinit-path=
		$(meson_native_true acl)
		$(meson_native_use_bool boot efi)
		$(meson_native_use_bool boot gnu-efi)
		$(meson_native_use_bool selinux)
		$(meson_use test tests)
		$(meson_native_use_bool tmpfiles)
		$(meson_use udev hwdb)
	)

	local opt
	for opt in "${disable_options[@]}"; do
		emesonargs+=( "-D${opt}=false" )
	done

	if multilib_is_native_abi || use udev; then
		use boot && emesonargs+=(
			-Defi-libdir="/usr/$(get_libdir)"
		)

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
				man/kernel-install.8
				src/boot/efi/linux$(efi_arch).{efi,elf}.stub
				src/boot/efi/systemd-boot$(efi_arch).efi
			)
		fi
		if use tmpfiles; then
			targets+=(
				systemd-tmpfiles.standalone
				man/tmpfiles.d.5
				man/systemd-tmpfiles.8
			)
			if use test; then
				targets+=( test-tmpfiles )
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
				hwdb.d/60-autosuspend-chromiumos.hwdb
				rules.d/50-udev-default.rules
				rules.d/64-btrfs.rules
			)
			if use test; then
				targets+=(
					# Used by udev-test.pl
					systemd-detect-virt
					test/sys
					test-udev

					test-fido-id-desc
					test-udev-builtin
					test-udev-event
					test-udev-netlink
					test-udev-node
					test-udev-util
				)
			fi
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
		if use tmpfiles; then
			tests+=(
				test-systmed-tmpfiles
				test-tmpfiles
			)
		fi
		if use udev; then
			tests+=(
				rule-syntax-check
				test-fido-id-desc
				test-udev-builtin
				test-udev-event
				test-udev-netlink
				test-udev-node
				test-udev-util
			)
			if [[ -w /dev ]]; then
				tests+=( udev-test )
			else
				ewarn "Skipping udev-test (needs write access to /dev)"
			fi
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

multilib_src_install() {
	if multilib_is_native_abi; then
		if use boot; then
			into /usr
			dobin bootctl
			doman man/{bootctl.1,kernel-install.8}
			insinto usr/lib/systemd/boot/efi
			doins src/boot/efi/{linux$(efi_arch).{efi,elf}.stub,systemd-boot$(efi_arch).efi}
		fi
		if use tmpfiles; then
			into /
			newbin systemd-tmpfiles.standalone systemd-tmpfiles
			doman man/{systemd-tmpfiles.8,tmpfiles.d.5}
		fi
		if use udev; then
			into /
			dobin udevadm systemd-hwdb
			dosym ../../bin/udevadm /lib/systemd/systemd-udevd
			exeinto /lib/udev
			doexe src/udev/{ata_id,cdrom_id,fido_id,mtd_probe,scsi_id,v4l_id}
			insinto /lib/udev/rules.d
			doins rules.d/*.rules
			insinto /lib/udev/hwdb.d
			doins hwdb.d/*.hwdb
			insinto /usr/share/pkgconfig
			doins src/udev/udev.pc
			doman man/{udev.conf.5,systemd.link.5,hwdb.7,systemd-hwdb.8,udev.7,udevadm.8}
			newman man/systemd-udevd.service.8 systemd-udevd.8

		fi
	fi
	if use udev; then
		into /usr
		dolib.so "$(readlink libudev.so.1)" libudev.so{.1,}
		gen_usr_ldscript -a udev
	fi
}

multilib_src_install_all() {
	einstalldocs
	if use boot; then
		into /usr
		dobin src/kernel-install/kernel-install
		exeinto usr/lib/kernel/install.d
		doexe src/kernel-install/*.install
		dobashcomp shell-completion/bash/bootctl
		insinto /usr/share/zsh/site-functions
		doins shell-completion/zsh/{_bootctl,_kernel-install}
	fi
	if use tmpfiles; then
		newinitd "${FILESDIR}"/stmpfiles-dev.initd stmpfiles-dev
		newinitd "${FILESDIR}"/stmpfiles-setup.initd stmpfiles-setup
		newconfd "${FILESDIR}"/stmpfiles.confd stmpfiles-dev
		newconfd "${FILESDIR}"/stmpfiles.confd stmpfiles-setup
		insinto /usr/share/zsh/site-functions
		doins shell-completion/zsh/_systemd-tmpfiles
	fi
	if use udev; then
		doheader src/libudev/libudev.h
		insinto /etc/udev
		doins src/udev/udev.conf
		keepdir /etc/udev/{hwdb.d,rules.d}
		insinto /lib/systemd/network
		doins network/99-default.link
		insinto /lib/udev/rules.d
		doins rules.d/*.rules
		doins "${FILESDIR}"/40-gentoo.rules
		insinto /lib/udev/hwdb.d
		doins hwdb.d/*.hwdb
		dobashcomp shell-completion/bash/udevadm
		insinto /usr/share/zsh/site-functions
		doins shell-completion/zsh/_udevadm
	fi
}

add_service() {
	local initd=$1
	local runlevel=$2

	elog "Auto-adding '${initd}' service to your ${runlevel} runlevel"
	mkdir -p "${EROOT}/etc/runlevels/${runlevel}"
	ln -snf "${EPREFIX}/etc/init.d/${initd}" "${EROOT}/etc/runlevels/${runlevel}/${initd}"
}

pkg_preinst() {
	add_tmpfiles_service=no
	use tmpfiles && ! has_version 'sys-apps/systemd-utils[tmpfiles]' &&
		! has_version 'sys-apps/systemd-tmpfiles' && add_tmpfiles_service=yes
}

pkg_postinst() {
	if [[ ${add_tmpfiles_service} == yes ]]; then
		add_service stmpfiles-dev sysinit
		add_service stmpfiles-setup boot
	fi
	if use udev; then
		ebegin "Updating hwdb"
		systemd-hwdb --root="${ROOT}" update
		eend $?
	fi
}
