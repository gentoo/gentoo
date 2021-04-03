# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic linux-info toolchain-funcs

DESCRIPTION="Misc tools bundled with kernel sources"
HOMEPAGE="https://kernel.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs tcpd usbip"

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/-pre/-git}"

LINUX_V=$(ver_cut 1-2)

get_version_component_count() {
	local cnt=( $(ver_rs 1- ' ') )
	echo ${#cnt[@]} || die
}

if [ ${PV/_rc} != ${PV} ]; then
	LINUX_VER=$(ver_cut 1-2).$(($(ver_cut 3)-1))
	PATCH_VERSION=$(ver_cut 1-3)
	LINUX_PATCH=patch-${PV//_/-}.xz
	SRC_URI="https://www.kernel.org/pub/linux/kernel/v3.x/testing/${LINUX_PATCH}
		https://www.kernel.org/pub/linux/kernel/v3.x/testing/v${PATCH_VERSION}/${LINUX_PATCH}"
elif [ $(get_version_component_count) == 4 ]; then
	# stable-release series
	LINUX_VER=$(ver_cut 1-3)
	LINUX_PATCH=patch-${PV}.xz
	SRC_URI="https://www.kernel.org/pub/linux/kernel/v3.x/${LINUX_PATCH}"
else
	LINUX_VER=${PV}
fi

LINUX_SOURCES=linux-${LINUX_VER}.tar.xz
SRC_URI="${SRC_URI} https://www.kernel.org/pub/linux/kernel/v3.x/${LINUX_SOURCES}"

# pmtools also provides turbostat
# usbip available in seperate package now
RDEPEND="sys-apps/hwids
		>=dev-libs/glib-2.6
		>=sys-kernel/linux-headers-${LINUX_V}
		usbip? (
			!net-misc/usbip
			tcpd? ( sys-apps/tcp-wrappers )
			virtual/libudev
		)
		!sys-power/pmtools"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

S="${WORKDIR}/linux-${LINUX_VER}"

# All of these are integrated with the kernel build system,
# No make install, and ideally build with with the root Makefile
TARGETS_SIMPLE=(
	samples/watchdog/watchdog-simple.c
	tools/accounting/getdelays.c
	tools/cgroup/cgroup_event_listener.c
	tools/laptop/freefall/freefall.c
	tools/testing/selftests/net/timestamping.c
	tools/vm/slabinfo.c
	usr/gen_init_cpio.c
	# Broken:
	#tools/lguest/lguest.c # fails to compile
	#tools/vm/page-types.c # page-types.c:(.text+0xe2b): undefined reference to `debugfs__mount', not defined anywhere
	#tools/net/bpf_jit_disasm.c # /usr/include/x86_64-pc-linux-gnu/bfd.h:35:2: error: #error config.h must be included before this header
)
# tools/vm/page-types.c - broken, header path issue
# tools/hv/hv_kvp_daemon.c - broken in 3.7 by missing linux/hyperv.h userspace
# Documentation/networking/ifenslave.c - obsolete
# Documentation/ptp/testptp.c - pending linux-headers-3.0

# These have a broken make install, no DESTDIR
TARGET_MAKE_SIMPLE=(
	samples/mei:mei-amt-version
	tools/firewire:nosy-dump
	tools/iio:iio_event_monitor
	tools/iio:iio_generic_buffer
	tools/iio:lsiio
	tools/laptop/dslm:dslm
	tools/power/x86/turbostat:turbostat
	tools/power/x86/x86_energy_perf_policy:x86_energy_perf_policy
	tools/thermal/tmon:tmon
)
# tools/perf - covered by dev-utils/perf
# tools/usb - testcases only
# tools/virtio - testcaes only

	#for _pattern in {Documentation,scripts,tools,usr,include,lib,"arch/*/include",Makefile,Kbuild,Kconfig}; do
src_unpack() {
	unpack ${LINUX_SOURCES}

	MY_A=
	for _AFILE in ${A}; do
		[[ ${_AFILE} == ${LINUX_SOURCES} ]] && continue
		[[ ${_AFILE} == ${LINUX_PATCH} ]] && continue
		MY_A="${MY_A} ${_AFILE}"
	done
	[[ -n ${MY_A} ]] && unpack ${MY_A}
}

src_prepare() {
	if [[ -n ${LINUX_PATCH} ]]; then
		eapply "${DISTDIR}"/${LINUX_PATCH}
	fi

	pushd tools/usb/usbip/ >/dev/null &&
	sed -i 's/-Werror[^ ]* //g' configure.ac &&
	eautoreconf -i -f -v &&
	popd >/dev/null || die "usbip"

	sed -i \
		-e '/^nosy-dump.*LDFLAGS/d' \
		-e '/^nosy-dump.*CFLAGS/d' \
		-e '/^nosy-dump.*CPPFLAGS/s,CPPFLAGS =,CPPFLAGS +=,g' \
		"${S}"/tools/firewire/Makefile

	eapply_user
}

kernel_asm_arch() {
	a="${1:${ARCH}}"
	case ${a} in
		# Merged arches
		x86|amd64) echo x86 ;;
		ppc*) echo powerpc ;;
		# Non-merged
		alpha|arm|ia64|m68k|mips|sh|sparc*) echo ${1} ;;
		*) die "TODO: Update the code for your asm-ARCH symlink" ;;
	esac
}

src_configure() {
	append-cflags -fcommon
	if use usbip; then
		pushd tools/usb/usbip/ || die
		econf \
			$(use_enable static-libs static) \
			$(use tcpd || echo --without-tcp-wrappers) \
			--with-usbids-dir=/usr/share/misc
		popd
	fi
}

src_compile() {
	local karch=$(kernel_asm_arch "${ARCH}")
	# This is the minimal amount needed to start building host binaries.
	#emake allmodconfig ARCH=${karch}
	#emake prepare modules_prepare ARCH=${karch}
	#touch Module.symvers

	# Now we can start building
	append-cflags -I./tools/lib
	for s in ${TARGETS_SIMPLE[@]} ; do
		dir=$(dirname $s) src=$(basename $s) bin=${src%.c}
		einfo "Building $s => $bin"
		emake -f /dev/null M=${dir} ARCH=${karch} ${s%.c}
	done

	for t in ${TARGET_MAKE_SIMPLE[@]} ; do
		dir=${t/:*} target_binfile=${t#*:}
		target=${target_binfile/:*} binfile=${target_binfile/*:}
		[ -z "${binfile}" ] && binfile=$target
		einfo "Building $dir => $binfile (via emake $target)"
		emake -C $dir ARCH=${karch} $target
	done

	if use usbip; then
		emake -C tools/usb/usbip
	fi
}

src_install() {
	into /usr
	for s in ${TARGETS_SIMPLE[@]} ; do
		dir=$(dirname $s) src=$(basename $s) bin=${src%.c}
		einfo "Installing $s => $bin"
		dosbin ${dir}/${bin}
	done

	for t in ${TARGET_MAKE_SIMPLE[@]} ; do
		dir=${t/:*} target_binfile=${t#*:}
		target=${target_binfile/:*} binfile=${target_binfile/*:}
		[ -z "${binfile}" ] && binfile=$target
		einfo "Installing $dir => $binfile"
		dosbin ${dir}/${binfile}
	done

	if use usbip; then
		pushd tools/usb/usbip/ >/dev/null || die "usbip"
		emake DESTDIR="${D}" install
		newdoc README README.usbip
		newdoc AUTHORS AUTHORS.usbip
		popd >/dev/null
		dodoc Documentation/usb/usbip_protocol.rst
		find "${D}" -name 'libusbip*.la' -delete || die
	fi

	# At one point upstream it was moved, but be generic to detect if it's
	# happened already
	if [[ -f "${D}"/usr/sbin/generic_buffer ]] && \
		[[ ! -f "${D}"/usr/sbin/iio_generic_buffer ]]; then
		mv -f "${D}"/usr/sbin/{,iio_}generic_buffer || die
	fi

	newconfd "${FILESDIR}"/freefall.confd freefall
	newinitd "${FILESDIR}"/freefall.initd freefall
}

pkg_postinst() {
	echo
	elog "The cpupower utility is maintained separately at sys-power/cpupower"
	elog "The lguest utility no longer builds, and has been dropped."
	elog "The hpfall tool has been renamed by upstream to freefall; update your config if needed"
	if find "${ROOT}"/etc/runlevels/ -name hpfall ; then
		ewarn "You must change hpfall to freefall in your runlevels!"
	fi
	if use usbip; then
		elog "For using USB/IP you need to enable USBIP_VHCI_HCD in the client"
		elog "machine's kernel config and USBIP_HOST on the server."
	fi
}
