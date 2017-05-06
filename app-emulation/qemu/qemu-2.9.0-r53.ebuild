# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ncurses,readline"

PLOCALES="bg de_DE fr_FR hu it tr zh_CN"

FIRMWARE_ABI_VERSION="2.9.0-r52"

inherit eutils flag-o-matic linux-info toolchain-funcs multilib python-r1 \
	user udev fcaps readme.gentoo-r1 pax-utils l10n

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://git.qemu.org/qemu.git"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="http://wiki.qemu-project.org/download/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
fi

DESCRIPTION="QEMU + Kernel-based Virtual Machine userland tools"
HOMEPAGE="http://www.qemu.org http://www.linux-kvm.org"

LICENSE="GPL-2 LGPL-2 BSD-2"
SLOT="0"
IUSE="accessibility +aio alsa bluetooth bzip2 +caps +curl debug +fdt
	glusterfs gnutls gtk gtk2 infiniband iscsi +jpeg kernel_linux
	kernel_FreeBSD lzo ncurses nfs nls numa opengl +pin-upstream-blobs +png
	pulseaudio python rbd sasl +seccomp sdl sdl2 selinux smartcard snappy
	spice ssh static static-user systemtap tci test usb usbredir vde
	+vhost-net virgl virtfs +vnc vte xattr xen xfs"

COMMON_TARGETS="aarch64 alpha arm cris i386 m68k microblaze microblazeel
	mips mips64 mips64el mipsel nios2 or1k ppc ppc64 s390x sh4 sh4eb sparc
	sparc64 x86_64"
IUSE_SOFTMMU_TARGETS="${COMMON_TARGETS}
	lm32 moxie ppcemb tricore unicore32 xtensa xtensaeb"
IUSE_USER_TARGETS="${COMMON_TARGETS}
	armeb hppa mipsn32 mipsn32el ppc64abi32 ppc64le sparc32plus tilegx"

use_softmmu_targets=$(printf ' qemu_softmmu_targets_%s' ${IUSE_SOFTMMU_TARGETS})
use_user_targets=$(printf ' qemu_user_targets_%s' ${IUSE_USER_TARGETS})
IUSE+=" ${use_softmmu_targets} ${use_user_targets}"

# Allow no targets to be built so that people can get a tools-only build.
# Block USE flag configurations known to not work.
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	gtk2? ( gtk )
	qemu_softmmu_targets_arm? ( fdt )
	qemu_softmmu_targets_microblaze? ( fdt )
	qemu_softmmu_targets_mips64el? ( fdt )
	qemu_softmmu_targets_ppc? ( fdt )
	qemu_softmmu_targets_ppc64? ( fdt )
	sdl2? ( sdl )
	static? ( static-user !alsa !bluetooth !gtk !gtk2 !opengl !pulseaudio )
	virtfs? ( xattr )
	vte? ( gtk )"

# Dependencies required for qemu tools (qemu-nbd, qemu-img, qemu-io, ...)
# and user/softmmu targets (qemu-*, qemu-system-*).
#
# Yep, you need both libcap and libcap-ng since virtfs only uses libcap.
#
# The attr lib isn't always linked in (although the USE flag is always
# respected).  This is because qemu supports using the C library's API
# when available rather than always using the extranl library.
ALL_DEPEND="
	>=dev-libs/glib-2.0[static-libs(+)]
	sys-libs/zlib[static-libs(+)]
	python? ( ${PYTHON_DEPS} )
	systemtap? ( dev-util/systemtap )
	xattr? ( sys-apps/attr[static-libs(+)] )"

# Dependencies required for qemu tools (qemu-nbd, qemu-img, qemu-io, ...)
# softmmu targets (qemu-system-*).
SOFTMMU_TOOLS_DEPEND="
	>=x11-libs/pixman-0.28.0[static-libs(+)]
	accessibility? (
		app-accessibility/brltty[api]
		app-accessibility/brltty[static-libs(+)]
	)
	aio? ( dev-libs/libaio[static-libs(+)] )
	alsa? ( >=media-libs/alsa-lib-1.0.13 )
	bluetooth? ( net-wireless/bluez )
	bzip2? ( app-arch/bzip2[static-libs(+)] )
	caps? ( sys-libs/libcap-ng[static-libs(+)] )
	curl? ( >=net-misc/curl-7.15.4[static-libs(+)] )
	fdt? ( >=sys-apps/dtc-1.4.0[static-libs(+)] )
	glusterfs? ( >=sys-cluster/glusterfs-3.4.0[static-libs(+)] )
	gnutls? (
		dev-libs/nettle:=[static-libs(+)]
		>=net-libs/gnutls-3.0:=[static-libs(+)]
	)
	gtk? (
		gtk2? (
			x11-libs/gtk+:2
			vte? ( x11-libs/vte:0 )
		)
		!gtk2? (
			x11-libs/gtk+:3
			vte? ( x11-libs/vte:2.91 )
		)
	)
	infiniband? ( sys-fabric/librdmacm:=[static-libs(+)] )
	iscsi? ( net-libs/libiscsi )
	jpeg? ( virtual/jpeg:0=[static-libs(+)] )
	lzo? ( dev-libs/lzo:2[static-libs(+)] )
	ncurses? (
		sys-libs/ncurses:0=[unicode]
		sys-libs/ncurses:0=[static-libs(+)]
	)
	nfs? ( >=net-fs/libnfs-1.9.3[static-libs(+)] )
	numa? ( sys-process/numactl[static-libs(+)] )
	opengl? (
		virtual/opengl
		media-libs/libepoxy[static-libs(+)]
		media-libs/mesa[static-libs(+)]
		media-libs/mesa[egl,gbm]
	)
	png? ( media-libs/libpng:0=[static-libs(+)] )
	pulseaudio? ( media-sound/pulseaudio )
	rbd? ( sys-cluster/ceph[static-libs(+)] )
	sasl? ( dev-libs/cyrus-sasl[static-libs(+)] )
	sdl? (
		!sdl2? (
			media-libs/libsdl[X]
			>=media-libs/libsdl-1.2.11[static-libs(+)]
		)
		sdl2? (
			media-libs/libsdl2[X]
			media-libs/libsdl2[static-libs(+)]
		)
	)
	seccomp? ( >=sys-libs/libseccomp-2.1.0[static-libs(+)] )
	smartcard? ( >=app-emulation/libcacard-2.5.0[static-libs(+)] )
	snappy? ( app-arch/snappy[static-libs(+)] )
	spice? (
		>=app-emulation/spice-protocol-0.12.3
		>=app-emulation/spice-0.12.0[static-libs(+)]
	)
	ssh? ( >=net-libs/libssh2-1.2.8[static-libs(+)] )
	usb? ( >=virtual/libusb-1-r2[static-libs(+)] )
	usbredir? ( >=sys-apps/usbredir-0.6[static-libs(+)] )
	vde? ( net-misc/vde[static-libs(+)] )
	virgl? ( media-libs/virglrenderer[static-libs(+)] )
	virtfs? ( sys-libs/libcap )
	xen? ( app-emulation/xen-tools:= )
	xfs? ( sys-fs/xfsprogs[static-libs(+)] )"

X86_FIRMWARE_DEPEND="
	pin-upstream-blobs? (
		~sys-firmware/edk2-ovmf-2017_pre20170505[binary]
		~sys-firmware/ipxe-1.0.0_p20160620
		~sys-firmware/seabios-1.10.2[binary,seavgabios]
		~sys-firmware/sgabios-0.1_pre8
	)
	!pin-upstream-blobs? (
		sys-firmware/edk2-ovmf
		sys-firmware/ipxe
		>=sys-firmware/seabios-1.10.2[seavgabios]
		sys-firmware/sgabios
	)"

CDEPEND="
	!static? (
		${ALL_DEPEND//\[static-libs(+)]}
		${SOFTMMU_TOOLS_DEPEND//\[static-libs(+)]}
	)
	qemu_softmmu_targets_i386? ( ${X86_FIRMWARE_DEPEND} )
	qemu_softmmu_targets_x86_64? ( ${X86_FIRMWARE_DEPEND} )"
DEPEND="${CDEPEND}
	dev-lang/perl
	=dev-lang/python-2*
	sys-apps/texinfo
	virtual/pkgconfig
	kernel_linux? ( >=sys-kernel/linux-headers-2.6.35 )
	gtk? ( nls? ( sys-devel/gettext ) )
	static? (
		${ALL_DEPEND}
		${SOFTMMU_TOOLS_DEPEND}
	)
	static-user? ( ${ALL_DEPEND} )
	test? (
		dev-libs/glib[utils]
		sys-devel/bc
	)"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-qemu )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.0-cflags.patch
	"${FILESDIR}"/${PN}-2.5.0-sysmacros.patch
	"${FILESDIR}"/${PN}-2.9.0-bug616870.patch
	"${FILESDIR}"/${PN}-2.9.0-bug616872.patch
	"${FILESDIR}"/${PN}-2.9.0-bug616874.patch
	"${FILESDIR}"/${PN}-2.9.0-CVE-2017-8112.patch
)

STRIP_MASK="/usr/share/qemu/palcode-clipper"

QA_PREBUILT="
	usr/share/qemu/openbios-ppc
	usr/share/qemu/openbios-sparc64
	usr/share/qemu/openbios-sparc32
	usr/share/qemu/palcode-clipper
	usr/share/qemu/s390-ccw.img
	usr/share/qemu/u-boot.e500"

QA_WX_LOAD="usr/bin/qemu-i386
	usr/bin/qemu-x86_64
	usr/bin/qemu-alpha
	usr/bin/qemu-arm
	usr/bin/qemu-cris
	usr/bin/qemu-m68k
	usr/bin/qemu-microblaze
	usr/bin/qemu-microblazeel
	usr/bin/qemu-mips
	usr/bin/qemu-mipsel
	usr/bin/qemu-or1k
	usr/bin/qemu-ppc
	usr/bin/qemu-ppc64
	usr/bin/qemu-ppc64abi32
	usr/bin/qemu-sh4
	usr/bin/qemu-sh4eb
	usr/bin/qemu-sparc
	usr/bin/qemu-sparc64
	usr/bin/qemu-armeb
	usr/bin/qemu-sparc32plus
	usr/bin/qemu-s390x
	usr/bin/qemu-unicore32"

DOC_CONTENTS="If you don't have kvm compiled into the kernel, make sure you have the
kernel module loaded before running kvm. The easiest way to ensure that the
kernel module is loaded is to load it on boot.
	For AMD CPUs the module is called 'kvm-amd'.
	For Intel CPUs the module is called 'kvm-intel'.
Please review /etc/conf.d/modules for how to load these.

Make sure your user is in the 'kvm' group. Just run
	$ gpasswd -a <USER> kvm
then have <USER> re-login.

For brand new installs, the default permissions on /dev/kvm might not let
you access it.  You can tell udev to reset ownership/perms:
	$ udevadm trigger -c add /dev/kvm

If you want to register binfmt handlers for qemu user targets:
For openrc:
	# rc-update add qemu-binfmt
For systemd:
	# ln -s /usr/share/qemu/binfmt.d/qemu.conf /etc/binfmt.d/qemu.conf"

pkg_pretend() {
	if use kernel_linux && kernel_is lt 2 6 25; then
		eerror "This version of KVM requres a host kernel of 2.6.25 or higher."
	elif use kernel_linux; then
		if ! linux_config_exists; then
			eerror "Unable to check your kernel for KVM support"
		else
			CONFIG_CHECK="~KVM ~TUN ~BRIDGE"
			ERROR_KVM="You must enable KVM in your kernel to continue"
			ERROR_KVM_AMD="If you have an AMD CPU, you must enable KVM_AMD in"
			ERROR_KVM_AMD+=" your kernel configuration."
			ERROR_KVM_INTEL="If you have an Intel CPU, you must enable"
			ERROR_KVM_INTEL+=" KVM_INTEL in your kernel configuration."
			ERROR_TUN="You will need the Universal TUN/TAP driver compiled"
			ERROR_TUN+=" into your kernel or loaded as a module to use the"
			ERROR_TUN+=" virtual network device if using -net tap."
			ERROR_BRIDGE="You will also need support for 802.1d"
			ERROR_BRIDGE+=" Ethernet Bridging for some network configurations."
			use vhost-net && CONFIG_CHECK+=" ~VHOST_NET"
			ERROR_VHOST_NET="You must enable VHOST_NET to have vhost-net"
			ERROR_VHOST_NET+=" support"

			if use amd64 || use x86 || use amd64-linux || use x86-linux; then
				CONFIG_CHECK+=" ~KVM_AMD ~KVM_INTEL"
			fi

			use python && CONFIG_CHECK+=" ~DEBUG_FS"
			ERROR_DEBUG_FS="debugFS support required for kvm_stat"

			# Now do the actual checks setup above
			check_extra_config
		fi
	fi

	if grep -qs '/usr/bin/qemu-kvm' "${EROOT}"/etc/libvirt/qemu/*.xml; then
		eerror "The kvm/qemu-kvm wrappers no longer exist, but your libvirt"
		eerror "instances are still pointing to it.  Please update your"
		eerror "configs in /etc/libvirt/qemu/ to use the -enable-kvm flag"
		eerror "and the right system binary (e.g. qemu-system-x86_64)."
		die "update your virt configs to not use qemu-kvm"
	fi
}

pkg_setup() {
	enewgroup kvm 78
}

# Sanity check to make sure target lists are kept up-to-date.
check_targets() {
	local var=$1 mak=$2
	local detected sorted

	pushd "${S}"/default-configs >/dev/null || die

	# Force C locale until glibc is updated. #564936
	detected=$(echo $(printf '%s\n' *-${mak}.mak | sed "s:-${mak}.mak::" | LC_COLLATE=C sort -u))
	sorted=$(echo $(printf '%s\n' ${!var} | LC_COLLATE=C sort -u))
	if [[ ${sorted} != "${detected}" ]] ; then
		eerror "The ebuild needs to be kept in sync."
		eerror "${var}: ${sorted}"
		eerror "$(printf '%-*s' ${#var} configure): ${detected}"
		die "sync ${var} to the list of targets"
	fi

	popd >/dev/null
}

handle_locales() {
	# Make sure locale list is kept up-to-date.
	local detected sorted
	detected=$(echo $(cd po && printf '%s\n' *.po | grep -v messages.po | sed 's:.po$::' | sort -u))
	sorted=$(echo $(printf '%s\n' ${PLOCALES} | sort -u))
	if [[ ${sorted} != "${detected}" ]] ; then
		eerror "The ebuild needs to be kept in sync."
		eerror "PLOCALES: ${sorted}"
		eerror " po/*.po: ${detected}"
		die "sync PLOCALES"
	fi

	# Deal with selective install of locales.
	if use nls ; then
		# Delete locales the user does not want. #577814
		rm_loc() { rm po/$1.po || die; }
		l10n_for_each_disabled_locale_do rm_loc
	else
		# Cheap hack to disable gettext .mo generation.
		rm -f po/*.po
	fi
}

src_prepare() {
	check_targets IUSE_SOFTMMU_TARGETS softmmu
	check_targets IUSE_USER_TARGETS linux-user

	# Alter target makefiles to accept CFLAGS set via flag-o
	sed -i -r \
		-e 's/^(C|OP_C|HELPER_C)FLAGS=/\1FLAGS+=/' \
		Makefile Makefile.target || die

	default

	# Fix ld and objcopy being called directly
	tc-export AR LD OBJCOPY

	# Verbose builds
	MAKEOPTS+=" V=1"

	# Run after we've applied all patches.
	handle_locales
}

##
# configures qemu based on the build directory and the build type
# we are using.
#
qemu_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	local buildtype=$1
	local builddir="${S}/${buildtype}-build"

	mkdir "${builddir}"

	local conf_opts=(
		--prefix=/usr
		--sysconfdir=/etc
		--libdir=/usr/$(get_libdir)
		--docdir=/usr/share/doc/${PF}/html
		--disable-bsd-user
		--disable-guest-agent
		--disable-strip
		--disable-werror
		# We support gnutls/nettle for crypto operations.  It is possible
		# to use gcrypt when gnutls/nettle are disabled (but not when they
		# are enabled), but it's not really worth the hassle.  Disable it
		# all the time to avoid automatically detecting it. #568856
		--disable-gcrypt
		--python="${PYTHON}"
		--cc="$(tc-getCC)"
		--cxx="$(tc-getCXX)"
		--host-cc="$(tc-getBUILD_CC)"
		$(use_enable debug debug-info)
		$(use_enable debug debug-tcg)
		--enable-docs
		$(use_enable tci tcg-interpreter)
		$(use_enable xattr attr)
	)

	# Disable options not used by user targets. This simplifies building
	# static user targets (USE=static-user) considerably.
	conf_notuser() {
		if [[ ${buildtype} == "user" ]] ; then
			echo "--disable-${2:-$1}"
		else
			use_enable "$@"
		fi
	}
	conf_opts+=(
		$(conf_notuser accessibility brlapi)
		$(conf_notuser aio linux-aio)
		$(conf_notuser bzip2)
		$(conf_notuser bluetooth bluez)
		$(conf_notuser caps cap-ng)
		$(conf_notuser curl)
		$(conf_notuser fdt)
		$(conf_notuser glusterfs)
		$(conf_notuser gnutls)
		$(conf_notuser gnutls nettle)
		$(conf_notuser gtk)
		$(conf_notuser infiniband rdma)
		$(conf_notuser iscsi libiscsi)
		$(conf_notuser jpeg vnc-jpeg)
		$(conf_notuser kernel_linux kvm)
		$(conf_notuser lzo)
		$(conf_notuser ncurses curses)
		$(conf_notuser nfs libnfs)
		$(conf_notuser numa)
		$(conf_notuser opengl)
		$(conf_notuser png vnc-png)
		$(conf_notuser rbd)
		$(conf_notuser sasl vnc-sasl)
		$(conf_notuser sdl)
		$(conf_notuser seccomp)
		$(conf_notuser smartcard)
		$(conf_notuser snappy)
		$(conf_notuser spice)
		$(conf_notuser ssh libssh2)
		$(conf_notuser usb libusb)
		$(conf_notuser usbredir usb-redir)
		$(conf_notuser vde)
		$(conf_notuser vhost-net)
		$(conf_notuser virgl virglrenderer)
		$(conf_notuser virtfs)
		$(conf_notuser vnc)
		$(conf_notuser vte)
		$(conf_notuser xen)
		$(conf_notuser xen xen-pci-passthrough)
		$(conf_notuser xfs xfsctl)
	)

	if [[ ! ${buildtype} == "user" ]] ; then
		# audio options
		local audio_opts="oss"
		use alsa && audio_opts="alsa,${audio_opts}"
		use sdl && audio_opts="sdl,${audio_opts}"
		use pulseaudio && audio_opts="pa,${audio_opts}"
		conf_opts+=(
			--audio-drv-list="${audio_opts}"
		)
		use gtk && conf_opts+=( --with-gtkabi=$(usex gtk2 2.0 3.0) )
		use sdl && conf_opts+=( --with-sdlabi=$(usex sdl2 2.0 1.2) )
	fi

	case ${buildtype} in
	user)
		conf_opts+=(
			--enable-linux-user
			--disable-system
			--disable-blobs
			--disable-tools
		)
		local static_flag="static-user"
		;;
	softmmu)
		conf_opts+=(
			--disable-linux-user
			--enable-system
			--disable-tools
			--with-system-pixman
		)
		local static_flag="static"
		;;
	tools)
		conf_opts+=(
			--disable-linux-user
			--disable-system
			--disable-blobs
			--enable-tools
		)
		local static_flag="static"
		;;
	esac

	local targets="${buildtype}_targets"
	[[ -n ${targets} ]] && conf_opts+=( --target-list="${!targets}" )

	# Add support for SystemTAP
	use systemtap && conf_opts+=( --enable-trace-backend=dtrace )

	# We always want to attempt to build with PIE support as it results
	# in a more secure binary. But it doesn't work with static or if
	# the current GCC doesn't have PIE support.
	if use ${static_flag}; then
		conf_opts+=( --static --disable-pie )
	else
		gcc-specs-pie && conf_opts+=( --enable-pie )
	fi

	echo "../configure ${conf_opts[*]}"
	cd "${builddir}"
	../configure "${conf_opts[@]}" || die "configure failed"

	# FreeBSD's kernel does not support QEMU assigning/grabbing
	# host USB devices yet
	use kernel_FreeBSD && \
		sed -i -E -e "s|^(HOST_USB=)bsd|\1stub|" "${S}"/config-host.mak
}

src_configure() {
	local target

	python_setup

	softmmu_targets= softmmu_bins=()
	user_targets= user_bins=()

	for target in ${IUSE_SOFTMMU_TARGETS} ; do
		if use "qemu_softmmu_targets_${target}"; then
			softmmu_targets+=",${target}-softmmu"
			softmmu_bins+=( "qemu-system-${target}" )
		fi
	done

	for target in ${IUSE_USER_TARGETS} ; do
		if use "qemu_user_targets_${target}"; then
			user_targets+=",${target}-linux-user"
			user_bins+=( "qemu-${target}" )
		fi
	done

	softmmu_targets=${softmmu_targets#,}
	user_targets=${user_targets#,}

	[[ -n ${softmmu_targets} ]] && qemu_src_configure "softmmu"
	[[ -n ${user_targets}    ]] && qemu_src_configure "user"
	qemu_src_configure "tools"
}

src_compile() {
	if [[ -n ${user_targets} ]]; then
		cd "${S}/user-build"
		default
	fi

	if [[ -n ${softmmu_targets} ]]; then
		cd "${S}/softmmu-build"
		default
	fi

	cd "${S}/tools-build"
	default
}

src_test() {
	if [[ -n ${softmmu_targets} ]]; then
		cd "${S}/softmmu-build"
		pax-mark m */qemu-system-* #515550
		emake -j1 check
		emake -j1 check-report.html
	fi
}

qemu_python_install() {
	python_domodule "${S}/scripts/qmp/qmp.py"

	python_doscript "${S}/scripts/kvm/vmxcap"
	python_doscript "${S}/scripts/qmp/qmp-shell"
	python_doscript "${S}/scripts/qmp/qemu-ga-client"
}

# Generate binfmt support files.
#   - /etc/init.d/qemu-binfmt script which registers the user handlers (openrc)
#   - /usr/share/qemu/binfmt.d/qemu.conf (for use with systemd-binfmt)
generate_initd() {
	local out="${T}/qemu-binfmt"
	local out_systemd="${T}/qemu.conf"
	local d="${T}/binfmt.d"

	einfo "Generating qemu binfmt scripts and configuration files"

	# Generate the debian fragments first.
	mkdir -p "${d}"
	"${S}"/scripts/qemu-binfmt-conf.sh \
		--debian \
		--exportdir "${d}" \
		--qemu-path "${EPREFIX}/usr/bin" \
		|| die
	# Then turn the fragments into a shell script we can source.
	sed -E -i \
		-e 's:^([^ ]+) (.*)$:\1="\2":' \
		"${d}"/* || die

	# Generate the init.d script by assembling the fragments from above.
	local f qcpu package interpreter magic mask
	cat "${FILESDIR}"/qemu-binfmt.initd.head >"${out}" || die
	for f in "${d}"/qemu-* ; do
		source "${f}"

		# Normalize the cpu logic like we do in the init.d for the native cpu.
		qcpu=${package#qemu-}
		case ${qcpu} in
		arm*)   qcpu="arm";;
		mips*)  qcpu="mips";;
		ppc*)   qcpu="ppc";;
		s390*)  qcpu="s390";;
		sh*)    qcpu="sh";;
		sparc*) qcpu="sparc";;
		esac

		cat <<EOF >>"${out}"
	if [ "\${cpu}" != "${qcpu}" -a -x "${interpreter}" ] ; then
		echo ':${package}:M::${magic}:${mask}:${interpreter}:'"\${QEMU_BINFMT_FLAGS}" >/proc/sys/fs/binfmt_misc/register
	fi
EOF

		echo ":${package}:M::${magic}:${mask}:${interpreter}:OC" >>"${out_systemd}"

	done
	cat "${FILESDIR}"/qemu-binfmt.initd.tail >>"${out}" || die
}

src_install() {
	if [[ -n ${user_targets} ]]; then
		cd "${S}/user-build"
		emake DESTDIR="${ED}" install

		# Install binfmt handler init script for user targets.
		generate_initd
		doinitd "${T}/qemu-binfmt"

		# Install binfmt/qemu.conf.
		insinto "/usr/share/qemu/binfmt.d"
		doins "${T}/qemu.conf"
	fi

	if [[ -n ${softmmu_targets} ]]; then
		cd "${S}/softmmu-build"
		emake DESTDIR="${ED}" install

		# This might not exist if the test failed. #512010
		[[ -e check-report.html ]] && dohtml check-report.html

		if use kernel_linux; then
			udev_newrules "${FILESDIR}"/65-kvm.rules-r1 65-kvm.rules
		fi

		if use python; then
			python_foreach_impl qemu_python_install
		fi
	fi

	cd "${S}/tools-build"
	emake DESTDIR="${ED}" install

	# Disable mprotect on the qemu binaries as they use JITs to be fast #459348
	pushd "${ED}"/usr/bin >/dev/null
	pax-mark mr "${softmmu_bins[@]}" "${user_bins[@]}" # bug 575594
	popd >/dev/null

	# Install config file example for qemu-bridge-helper
	insinto "/etc/qemu"
	doins "${FILESDIR}/bridge.conf"

	cd "${S}"
	dodoc Changelog MAINTAINERS docs/specs/pci-ids.txt
	newdoc pc-bios/README README.pc-bios
	dodoc docs/qmp-*.txt

	if [[ -n ${softmmu_targets} ]]; then
		# Remove SeaBIOS since we're using the SeaBIOS packaged one
		rm "${ED}/usr/share/qemu/bios.bin"
		rm "${ED}/usr/share/qemu/bios-256k.bin"
		if use qemu_softmmu_targets_x86_64 || use qemu_softmmu_targets_i386; then
			dosym ../seabios/bios.bin /usr/share/qemu/bios.bin
			dosym ../seabios/bios-256k.bin /usr/share/qemu/bios-256k.bin
		fi

		# Remove vgabios since we're using the seavgabios packaged one
		rm "${ED}/usr/share/qemu/vgabios.bin"
		rm "${ED}/usr/share/qemu/vgabios-cirrus.bin"
		rm "${ED}/usr/share/qemu/vgabios-qxl.bin"
		rm "${ED}/usr/share/qemu/vgabios-stdvga.bin"
		rm "${ED}/usr/share/qemu/vgabios-virtio.bin"
		rm "${ED}/usr/share/qemu/vgabios-vmware.bin"
		if use qemu_softmmu_targets_x86_64 || use qemu_softmmu_targets_i386; then
			dosym ../seavgabios/vgabios-isavga.bin /usr/share/qemu/vgabios.bin
			dosym ../seavgabios/vgabios-cirrus.bin /usr/share/qemu/vgabios-cirrus.bin
			dosym ../seavgabios/vgabios-qxl.bin /usr/share/qemu/vgabios-qxl.bin
			dosym ../seavgabios/vgabios-stdvga.bin /usr/share/qemu/vgabios-stdvga.bin
			dosym ../seavgabios/vgabios-virtio.bin /usr/share/qemu/vgabios-virtio.bin
			dosym ../seavgabios/vgabios-vmware.bin /usr/share/qemu/vgabios-vmware.bin
		fi

		# Remove sgabios since we're using the sgabios packaged one
		rm "${ED}/usr/share/qemu/sgabios.bin"
		if use qemu_softmmu_targets_x86_64 || use qemu_softmmu_targets_i386; then
			dosym ../sgabios/sgabios.bin /usr/share/qemu/sgabios.bin
		fi

		# Remove iPXE since we're using the iPXE packaged one
		rm "${ED}"/usr/share/qemu/pxe-*.rom
		if use qemu_softmmu_targets_x86_64 || use qemu_softmmu_targets_i386; then
			dosym ../ipxe/8086100e.rom /usr/share/qemu/pxe-e1000.rom
			dosym ../ipxe/80861209.rom /usr/share/qemu/pxe-eepro100.rom
			dosym ../ipxe/10500940.rom /usr/share/qemu/pxe-ne2k_pci.rom
			dosym ../ipxe/10222000.rom /usr/share/qemu/pxe-pcnet.rom
			dosym ../ipxe/10ec8139.rom /usr/share/qemu/pxe-rtl8139.rom
			dosym ../ipxe/1af41000.rom /usr/share/qemu/pxe-virtio.rom
		fi
	fi

	DISABLE_AUTOFORMATTING=true
	readme.gentoo_create_doc
}

firmware_abi_change() {
	local pv
	for pv in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least ${FIRMWARE_ABI_VERSION} ${pv}; then
			return 0
		fi
	done
	return 1
}

pkg_postinst() {
	if [[ -n ${softmmu_targets} ]] && use kernel_linux; then
		udev_reload
	fi

	fcaps cap_net_admin /usr/libexec/qemu-bridge-helper

	DISABLE_AUTOFORMATTING=true
	readme.gentoo_print_elog

	if use pin-upstream-blobs && firmware_abi_change; then
		ewarn "This version of qemu pins new versions of firmware blobs:"
		ewarn "	$(best_version sys-firmware/edk2-ovmf)"
		ewarn "	$(best_version sys-firmware/ipxe)"
		ewarn "	$(best_version sys-firmware/seabios)"
		ewarn "	$(best_version sys-firmware/sgabios)"
		ewarn "This might break resume of hibernated guests (started with a different"
		ewarn "firmware version) and live migration to/from qemu versions with different"
		ewarn "firmware. Please (cold) restart all running guests. For functional"
		ewarn "guest migration ensure that all"
		ewarn "hosts run at least"
		ewarn "	app-emulation/qemu-${FIRMWARE_ABI_VERSION}."
	fi
}

pkg_info() {
	echo "Using:"
	echo "  $(best_version app-emulation/spice-protocol)"
	echo "  $(best_version sys-firmware/edk2-ovmf)"
	if has_version 'sys-firmware/edk2-ovmf[binary]'; then
		echo "    USE=binary"
	else
		echo "    USE=''"
	fi
	echo "  $(best_version sys-firmware/ipxe)"
	echo "  $(best_version sys-firmware/seabios)"
	if has_version 'sys-firmware/seabios[binary]'; then
		echo "    USE=binary"
	else
		echo "    USE=''"
	fi
	echo "  $(best_version sys-firmware/sgabios)"
}
