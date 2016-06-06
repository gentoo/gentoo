# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ncurses,readline"

PLOCALES="de_DE fr_FR hu it tr zh_CN"

inherit eutils flag-o-matic linux-info toolchain-funcs multilib python-r1 \
	user udev fcaps readme.gentoo pax-utils l10n

BACKPORTS=

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://git.qemu.org/qemu.git"
	inherit git-2
	SRC_URI=""
else
	SRC_URI="http://wiki.qemu-project.org/download/${P}.tar.bz2
	${BACKPORTS:+
		https://dev.gentoo.org/~cardoe/distfiles/${P}-${BACKPORTS}.tar.xz}"
	KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86 ~x86-fbsd"
fi

DESCRIPTION="QEMU + Kernel-based Virtual Machine userland tools"
HOMEPAGE="http://www.qemu.org http://www.linux-kvm.org"

LICENSE="GPL-2 LGPL-2 BSD-2"
SLOT="0"
IUSE="accessibility +aio alsa bluetooth +caps +curl debug +fdt glusterfs \
gnutls gtk gtk2 infiniband iscsi +jpeg \
kernel_linux kernel_FreeBSD lzo ncurses nfs nls numa opengl +pin-upstream-blobs
+png pulseaudio python \
rbd sasl +seccomp sdl sdl2 selinux smartcard snappy spice ssh static static-softmmu
static-user systemtap tci test +threads usb usbredir +uuid vde +vhost-net \
virgl virtfs +vnc vte xattr xen xfs"

COMMON_TARGETS="aarch64 alpha arm cris i386 m68k microblaze microblazeel mips
mips64 mips64el mipsel or32 ppc ppc64 s390x sh4 sh4eb sparc sparc64 unicore32
x86_64"
IUSE_SOFTMMU_TARGETS="${COMMON_TARGETS} lm32 moxie ppcemb tricore xtensa xtensaeb"
IUSE_USER_TARGETS="${COMMON_TARGETS} armeb mipsn32 mipsn32el ppc64abi32 ppc64le sparc32plus tilegx"

use_softmmu_targets=$(printf ' qemu_softmmu_targets_%s' ${IUSE_SOFTMMU_TARGETS})
use_user_targets=$(printf ' qemu_user_targets_%s' ${IUSE_USER_TARGETS})
IUSE+=" ${use_softmmu_targets} ${use_user_targets}"

# Allow no targets to be built so that people can get a tools-only build.
# Block USE flag configurations known to not work.
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	gtk2? ( gtk )
	qemu_softmmu_targets_arm? ( fdt )
	qemu_softmmu_targets_microblaze? ( fdt )
	qemu_softmmu_targets_ppc? ( fdt )
	qemu_softmmu_targets_ppc64? ( fdt )
	sdl2? ( sdl )
	static? ( static-softmmu static-user )
	static-softmmu? ( !alsa !pulseaudio !bluetooth !opengl !gtk !gtk2 )
	virtfs? ( xattr )
	vte? ( gtk )"

# Yep, you need both libcap and libcap-ng since virtfs only uses libcap.
#
# The attr lib isn't always linked in (although the USE flag is always
# respected).  This is because qemu supports using the C library's API
# when available rather than always using the extranl library.
#
# Older versions of gnutls are supported, but it's simpler to just require
# the latest versions.  This is also why we require nettle.
COMMON_LIB_DEPEND=">=dev-libs/glib-2.0[static-libs(+)]
	sys-libs/zlib[static-libs(+)]
	xattr? ( sys-apps/attr[static-libs(+)] )"
SOFTMMU_LIB_DEPEND="${COMMON_LIB_DEPEND}
	>=x11-libs/pixman-0.28.0[static-libs(+)]
	accessibility? ( app-accessibility/brltty[static-libs(+)] )
	aio? ( dev-libs/libaio[static-libs(+)] )
	alsa? ( >=media-libs/alsa-lib-1.0.13 )
	bluetooth? ( net-wireless/bluez )
	caps? ( sys-libs/libcap-ng[static-libs(+)] )
	curl? ( >=net-misc/curl-7.15.4[static-libs(+)] )
	fdt? ( >=sys-apps/dtc-1.4.0[static-libs(+)] )
	glusterfs? ( >=sys-cluster/glusterfs-3.4.0[static-libs(+)] )
	gnutls? (
		dev-libs/nettle[static-libs(+)]
		>=net-libs/gnutls-3.0[static-libs(+)]
	)
	gtk? (
		gtk2? (
			x11-libs/gtk+:2
			vte? ( x11-libs/vte:0 )
		)
		!gtk2? (
			x11-libs/gtk+:3
			vte? ( x11-libs/vte:2.90 )
		)
	)
	infiniband? ( sys-infiniband/librdmacm:=[static-libs(+)] )
	iscsi? ( net-libs/libiscsi )
	jpeg? ( virtual/jpeg:0=[static-libs(+)] )
	lzo? ( dev-libs/lzo:2[static-libs(+)] )
	ncurses? ( sys-libs/ncurses:0=[static-libs(+)] )
	nfs? ( >=net-fs/libnfs-1.9.3[static-libs(+)] )
	numa? ( sys-process/numactl[static-libs(+)] )
	opengl? (
		virtual/opengl
		media-libs/libepoxy[static-libs(+)]
		media-libs/mesa[static-libs(+)]
		media-libs/mesa[egl,gles2]
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
	uuid? ( >=sys-apps/util-linux-2.16.0[static-libs(+)] )
	vde? ( net-misc/vde[static-libs(+)] )
	virgl? ( media-libs/virglrenderer[static-libs(+)] )
	virtfs? ( sys-libs/libcap )
	xfs? ( sys-fs/xfsprogs[static-libs(+)] )"
USER_LIB_DEPEND="${COMMON_LIB_DEPEND}"
X86_FIRMWARE_DEPEND="
	>=sys-firmware/ipxe-1.0.0_p20130624
	pin-upstream-blobs? (
		~sys-firmware/seabios-1.8.2
		~sys-firmware/sgabios-0.1_pre8
		~sys-firmware/vgabios-0.7a
	)
	!pin-upstream-blobs? (
		sys-firmware/seabios
		sys-firmware/sgabios
		sys-firmware/vgabios
	)"
CDEPEND="
	!static-softmmu? ( $(printf "%s? ( ${SOFTMMU_LIB_DEPEND//\[static-libs(+)]} ) " ${use_softmmu_targets}) )
	!static-user? ( $(printf "%s? ( ${USER_LIB_DEPEND//\[static-libs(+)]} ) " ${use_user_targets}) )
	qemu_softmmu_targets_i386? ( ${X86_FIRMWARE_DEPEND} )
	qemu_softmmu_targets_x86_64? ( ${X86_FIRMWARE_DEPEND} )
	python? ( ${PYTHON_DEPS} )
	systemtap? ( dev-util/systemtap )
	xen? ( app-emulation/xen-tools:= )"
DEPEND="${CDEPEND}
	dev-lang/perl
	=dev-lang/python-2*
	sys-apps/texinfo
	virtual/pkgconfig
	kernel_linux? ( >=sys-kernel/linux-headers-2.6.35 )
	gtk? ( nls? ( sys-devel/gettext ) )
	static-softmmu? ( $(printf "%s? ( ${SOFTMMU_LIB_DEPEND} ) " ${use_softmmu_targets}) )
	static-user? ( $(printf "%s? ( ${USER_LIB_DEPEND} ) " ${use_user_targets}) )
	test? (
		dev-libs/glib[utils]
		sys-devel/bc
	)"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-qemu )
"

STRIP_MASK="/usr/share/qemu/palcode-clipper"

QA_PREBUILT="
	usr/share/qemu/openbios-ppc
	usr/share/qemu/openbios-sparc64
	usr/share/qemu/openbios-sparc32
	usr/share/qemu/palcode-clipper
	usr/share/qemu/s390-ccw.img
	usr/share/qemu/u-boot.e500
"

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
	usr/bin/qemu-or32
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

DOC_CONTENTS="If you don't have kvm compiled into the kernel, make sure
you have the kernel module loaded before running kvm. The easiest way to
ensure that the kernel module is loaded is to load it on boot.\n
For AMD CPUs the module is called 'kvm-amd'\n
For Intel CPUs the module is called 'kvm-intel'\n
Please review /etc/conf.d/modules for how to load these\n\n
Make sure your user is in the 'kvm' group\n
Just run 'gpasswd -a <USER> kvm', then have <USER> re-login."

qemu_support_kvm() {
	if use qemu_softmmu_targets_x86_64 || use qemu_softmmu_targets_i386 \
		use qemu_softmmu_targets_ppc || use qemu_softmmu_targets_ppc64 \
		use qemu_softmmu_targets_s390x; then
		return 0
	fi

	return 1
}

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

	epatch "${FILESDIR}"/qemu-2.5.0-cflags.patch
	[[ -n ${BACKPORTS} ]] && \
		EPATCH_FORCE=yes EPATCH_SUFFIX="patch" EPATCH_SOURCE="${S}/patches" \
			epatch

	epatch "${FILESDIR}"/${P}-CVE-2015-8567.patch #567868
	epatch "${FILESDIR}"/${P}-CVE-2015-8558.patch #568246
	epatch "${FILESDIR}"/${P}-CVE-2015-8701.patch #570110
	epatch "${FILESDIR}"/${P}-CVE-2015-8743.patch #570988
	epatch "${FILESDIR}"/${P}-CVE-2016-1568.patch #571566
	epatch "${FILESDIR}"/${P}-CVE-2015-8613.patch #569118
	epatch "${FILESDIR}"/${P}-CVE-2015-8619.patch #569300
	epatch "${FILESDIR}"/${P}-CVE-2016-1714.patch #571560
	epatch "${FILESDIR}"/${P}-CVE-2016-1922.patch #572082
	epatch "${FILESDIR}"/${P}-CVE-2016-1981.patch #572412
	epatch "${FILESDIR}"/${P}-usb-ehci-oob.patch #572454
	epatch "${FILESDIR}"/${P}-CVE-2016-2197.patch #573280
	epatch "${FILESDIR}"/${P}-CVE-2016-2198.patch #573314
	epatch "${FILESDIR}"/${P}-CVE-2016-2392.patch #574902
	epatch "${FILESDIR}"/${P}-usb-ndis-int-overflow.patch #575492
	epatch "${FILESDIR}"/${P}-rng-stack-corrupt-{0,1,2,3}.patch #576420
	epatch "${FILESDIR}"/${P}-sysmacros.patch

	# Fix ld and objcopy being called directly
	tc-export AR LD OBJCOPY

	# Verbose builds
	MAKEOPTS+=" V=1"

	epatch_user

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
	local static_flag="static-${buildtype}"

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

	# Disable options not used by user targets as the default configure
	# options will autoprobe and try to link in a bunch of unused junk.
	conf_softmmu() {
		if [[ ${buildtype} == "user" ]] ; then
			echo "--disable-${2:-$1}"
		else
			use_enable "$@"
		fi
	}
	conf_opts+=(
		$(conf_softmmu accessibility brlapi)
		$(conf_softmmu aio linux-aio)
		$(conf_softmmu bluetooth bluez)
		$(conf_softmmu caps cap-ng)
		$(conf_softmmu curl)
		$(conf_softmmu fdt)
		$(conf_softmmu glusterfs)
		$(conf_softmmu gnutls)
		$(conf_softmmu gnutls nettle)
		$(conf_softmmu gtk)
		$(conf_softmmu infiniband rdma)
		$(conf_softmmu iscsi libiscsi)
		$(conf_softmmu jpeg vnc-jpeg)
		$(conf_softmmu kernel_linux kvm)
		$(conf_softmmu lzo)
		$(conf_softmmu ncurses curses)
		$(conf_softmmu nfs libnfs)
		$(conf_softmmu numa)
		$(conf_softmmu opengl)
		$(conf_softmmu png vnc-png)
		$(conf_softmmu rbd)
		$(conf_softmmu sasl vnc-sasl)
		$(conf_softmmu sdl)
		$(conf_softmmu seccomp)
		$(conf_softmmu smartcard)
		$(conf_softmmu snappy)
		$(conf_softmmu spice)
		$(conf_softmmu ssh libssh2)
		$(conf_softmmu usb libusb)
		$(conf_softmmu usbredir usb-redir)
		$(conf_softmmu uuid)
		$(conf_softmmu vde)
		$(conf_softmmu vhost-net)
		$(conf_softmmu virgl virglrenderer)
		$(conf_softmmu virtfs)
		$(conf_softmmu vnc)
		$(conf_softmmu vte)
		$(conf_softmmu xen)
		$(conf_softmmu xen xen-pci-passthrough)
		$(conf_softmmu xfs xfsctl)
	)

	case ${buildtype} in
	user)
		conf_opts+=(
			--enable-linux-user
			--disable-system
			--disable-blobs
			--disable-tools
		)
		;;
	softmmu)
		# audio options
		local audio_opts="oss"
		use alsa && audio_opts="alsa,${audio_opts}"
		use sdl && audio_opts="sdl,${audio_opts}"
		use pulseaudio && audio_opts="pa,${audio_opts}"

		conf_opts+=(
			--disable-linux-user
			--enable-system
			--with-system-pixman
			--audio-drv-list="${audio_opts}"
		)
		use gtk && conf_opts+=( --with-gtkabi=$(usex gtk2 2.0 3.0) )
		use sdl && conf_opts+=( --with-sdlabi=$(usex sdl2 2.0 1.2) )
		;;
	tools)
		conf_opts+=(
			--disable-linux-user
			--disable-system
			--disable-blobs
		)
		static_flag="static"
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
	[[ -z ${softmmu_targets}${user_targets} ]] && qemu_src_configure "tools"
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

	if [[ -z ${softmmu_targets}${user_targets} ]]; then
		cd "${S}/tools-build"
		default
	fi
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

	python_doscript "${S}/scripts/kvm/kvm_stat"
	python_doscript "${S}/scripts/kvm/vmxcap"
	python_doscript "${S}/scripts/qmp/qmp-shell"
	python_doscript "${S}/scripts/qmp/qemu-ga-client"
}

src_install() {
	if [[ -n ${user_targets} ]]; then
		cd "${S}/user-build"
		emake DESTDIR="${ED}" install

		# Install binfmt handler init script for user targets
		newinitd "${FILESDIR}/qemu-binfmt.initd-r1" qemu-binfmt
	fi

	if [[ -n ${softmmu_targets} ]]; then
		cd "${S}/softmmu-build"
		emake DESTDIR="${ED}" install

		# This might not exist if the test failed. #512010
		[[ -e check-report.html ]] && dohtml check-report.html

		if use kernel_linux; then
			udev_dorules "${FILESDIR}"/65-kvm.rules
		fi

		if use python; then
			python_foreach_impl qemu_python_install
		fi
	fi

	if [[ -z ${softmmu_targets}${user_targets} ]]; then
		cd "${S}/tools-build"
		emake DESTDIR="${ED}" install
	fi

	# Disable mprotect on the qemu binaries as they use JITs to be fast #459348
	pushd "${ED}"/usr/bin >/dev/null
	pax-mark m "${softmmu_bins[@]}" "${user_bins[@]}"
	popd >/dev/null

	# Install config file example for qemu-bridge-helper
	insinto "/etc/qemu"
	doins "${FILESDIR}/bridge.conf"

	# Remove the docdir placed qmp-commands.txt
	mv "${ED}/usr/share/doc/${PF}/html/qmp-commands.txt" "${S}/docs/" || die

	cd "${S}"
	dodoc Changelog MAINTAINERS docs/specs/pci-ids.txt
	newdoc pc-bios/README README.pc-bios
	dodoc docs/qmp-*.txt

	if [[ -n ${softmmu_targets} ]]; then
		# Remove SeaBIOS since we're using the SeaBIOS packaged one
		rm "${ED}/usr/share/qemu/bios.bin"
		if use qemu_softmmu_targets_x86_64 || use qemu_softmmu_targets_i386; then
			dosym ../seabios/bios.bin /usr/share/qemu/bios.bin
		fi

		# Remove vgabios since we're using the vgabios packaged one
		rm "${ED}/usr/share/qemu/vgabios.bin"
		rm "${ED}/usr/share/qemu/vgabios-cirrus.bin"
		rm "${ED}/usr/share/qemu/vgabios-qxl.bin"
		rm "${ED}/usr/share/qemu/vgabios-stdvga.bin"
		rm "${ED}/usr/share/qemu/vgabios-vmware.bin"
		if use qemu_softmmu_targets_x86_64 || use qemu_softmmu_targets_i386; then
			dosym ../vgabios/vgabios.bin /usr/share/qemu/vgabios.bin
			dosym ../vgabios/vgabios-cirrus.bin /usr/share/qemu/vgabios-cirrus.bin
			dosym ../vgabios/vgabios-qxl.bin /usr/share/qemu/vgabios-qxl.bin
			dosym ../vgabios/vgabios-stdvga.bin /usr/share/qemu/vgabios-stdvga.bin
			dosym ../vgabios/vgabios-vmware.bin /usr/share/qemu/vgabios-vmware.bin
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

	qemu_support_kvm && readme.gentoo_create_doc
}

pkg_postinst() {
	if qemu_support_kvm; then
		readme.gentoo_print_elog
	fi

	if [[ -n ${softmmu_targets} ]] && use kernel_linux; then
		udev_reload
	fi

	fcaps cap_net_admin /usr/libexec/qemu-bridge-helper
}

pkg_info() {
	echo "Using:"
	echo "  $(best_version app-emulation/spice-protocol)"
	echo "  $(best_version sys-firmware/ipxe)"
	echo "  $(best_version sys-firmware/seabios)"
	if has_version 'sys-firmware/seabios[binary]'; then
		echo "    USE=binary"
	else
		echo "    USE=''"
	fi
	echo "  $(best_version sys-firmware/vgabios)"
}
