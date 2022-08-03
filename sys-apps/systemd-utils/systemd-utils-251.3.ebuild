# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

QA_PKGCONFIG_VERSION=$(ver_cut 1)

inherit bash-completion-r1 flag-o-matic meson-multilib python-any-r1 toolchain-funcs udev usr-ldscript

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

MUSL_PATCHSET="systemd-musl-patches-251.2"
SRC_URI+=" elibc_musl? ( https://dev.gentoo.org/~floppym/dist/${MUSL_PATCHSET}.tar.gz )"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+acl boot +kmod selinux sysusers +tmpfiles test +udev"
REQUIRED_USE="|| ( boot tmpfiles sysusers udev )"
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
	boot? ( >=sys-boot/gnu-efi-3.0.2 )
"
RDEPEND="${COMMON_DEPEND}
	boot? ( !<sys-boot/systemd-boot-250 )
	tmpfiles? ( !<sys-apps/systemd-tmpfiles-250 )
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
		!<sys-fs/udev-250
		!sys-fs/eudev
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

TMPFILES_OPTIONAL=1
UDEV_OPTIONAL=1

python_check_deps() {
	has_version -b "dev-python/jinja[${PYTHON_USEDEP}]"
}

QA_EXECSTACK="usr/lib/systemd/boot/efi/*"
QA_FLAGS_IGNORED="usr/lib/systemd/boot/efi/.*"

src_prepare() {
	local PATCHES=(
		# bug #863218
		"${FILESDIR}/251-glibc-2.36.patch"
	)

	if use elibc_musl; then
		PATCHES+=( "${WORKDIR}/${MUSL_PATCHSET}" )
		# Applied upstream in 251.3
		rm "${WORKDIR}/${MUSL_PATCHSET}/0001-Add-sys-file.h-for-LOCK_.patch" || die
	fi
	default

	# Remove install_rpath; we link statically
	local rpath_pattern="install_rpath : rootlibexecdir,"
	grep -q -e "${rpath_pattern}" meson.build || die
	sed -i -e "/${rpath_pattern}/d" meson.build || die
}

multilib_src_configure() {
	# When bumping to 251, please keep this, but add the revert patch
	# like in sys-apps/systemd!
	#
	# Broken with FORTIFY_SOURCE=3 without a patch. And the patch
	# wasn't backported to 250.x, but it turns out to break Clang
	# anyway:  bug #841770.
	#
	# Our toolchain sets F_S=2 by default w/ >= -O2, so we need
	# to unset F_S first, then explicitly set 2, to negate any default
	# and anything set by the user if they're choosing 3 (or if they've
	# modified GCC to set 3).
	#
	if is-flagq '-O[23]' || is-flagq '-Ofast' ; then
		# We can't unconditionally do this b/c we fortify needs
		# some level of optimisation.
		filter-flags -D_FORTIFY_SOURCE=3
		append-cppflags -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
	fi

	local emesonargs=(
		-Drootprefix="${EPREFIX:-/}"
		-Drootlibdir="${EPREFIX}/usr/$(get_libdir)"
		-Dsysvinit-path=
		$(meson_native_use_bool boot efi)
		$(meson_native_use_bool boot gnu-efi)
		$(meson_native_use_bool boot kernel-install)
		$(meson_native_use_bool selinux)
		$(meson_native_use_bool sysusers)
		$(meson_use test tests)
		$(meson_native_use_bool tmpfiles)
		$(meson_use udev hwdb)

		-Defi-libdir="${ESYSROOT}/usr/$(get_libdir)"

		# Link staticly with libsystemd-shared
		-Dlink-boot-shared=false
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
				kernel-install
				man/bootctl.1
				man/kernel-install.8
				src/boot/efi/linux$(efi_arch).{efi,elf}.stub
				src/boot/efi/systemd-boot$(efi_arch).efi
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
		if use sysusers; then
			tests+=(
				test-sysusers.standalone
			)
		fi
		if use tmpfiles; then
			tests+=(
				test-systemd-tmpfiles.standalone
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
			dobin bootctl kernel-install
			doman man/{bootctl.1,kernel-install.8}
			insinto usr/lib/systemd/boot/efi
			doins src/boot/efi/{linux$(efi_arch).{efi,elf}.stub,systemd-boot$(efi_arch).efi}
		fi
		if use sysusers; then
			into /
			newbin systemd-sysusers{.standalone,}
			doman man/{systemd-sysusers.8,sysusers.d.5}
		fi
		if use tmpfiles; then
			into /
			newbin systemd-tmpfiles{.standalone,}
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

		# Remove to avoid conflict with elogind
		# https://bugs.gentoo.org/856433
		rm rules.d/70-power-switch.rules || die
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
