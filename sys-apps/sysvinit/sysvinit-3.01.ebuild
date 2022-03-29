# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

DESCRIPTION="/sbin/init - parent of all processes"
HOMEPAGE="https://savannah.nongnu.org/projects/sysvinit"
SRC_URI="mirror://nongnu/${PN}/${P/_/-}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
[[ "${PV}" == *beta* ]] || \
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="selinux ibm static"

CDEPEND="
	selinux? (
		>=sys-libs/libselinux-1.28
	)"
DEPEND="${CDEPEND}
	virtual/os-headers"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-shutdown )
	!<sys-apps/openrc-0.13
"

S="${WORKDIR}/${P/_*}"

PATCHES=(
	"${FILESDIR}/${PN}-2.86-kexec.patch" #80220
	"${FILESDIR}/${PN}-2.94_beta-shutdown-single.patch" #158615
	"${FILESDIR}/${PN}-2.99-shutdown-h.patch" #449354
)

src_prepare() {
	default

	sed -i \
		-e '/^CPPFLAGS =$/d' \
		-e '/^override CFLAGS +=/s/ -fstack-protector-strong//' \
		src/Makefile || die

	# last/lastb/mesg/mountpoint/sulogin/utmpdump/wall have moved to util-linux
	sed -i -r \
		-e '/^(USR)?S?BIN/s:\<(last|lastb|mesg|mountpoint|sulogin|utmpdump|wall)\>::g' \
		-e '/^MAN[18]/s:\<(last|lastb|mesg|mountpoint|sulogin|utmpdump|wall)[.][18]\>::g' \
		src/Makefile || die

	# pidof has moved to >=procps-3.3.9
	sed -i -r \
		-e '/\/bin\/pidof/d' \
		-e '/^MAN8/s:\<pidof.8\>::g' \
		src/Makefile || die

	# logsave is already in e2fsprogs
	sed -i -r \
		-e '/^(USR)?S?BIN/s:\<logsave\>::g' \
		-e '/^MAN8/s:\<logsave.8\>::g' \
		src/Makefile || die

	# Mung inittab for specific architectures
	cd "${WORKDIR}" || die
	cp "${FILESDIR}"/inittab-2.98-r1 inittab || die "cp inittab"
	local insert=()
	use ppc && insert=( '#psc0:12345:respawn:/sbin/agetty 115200 ttyPSC0 linux' )
	use arm && insert=( '#f0:12345:respawn:/sbin/agetty 9600 ttyFB0 vt100' )
	use arm64 && insert=( 'f0:12345:respawn:/sbin/agetty 9600 ttyAMA0 vt100' )
	use hppa && insert=( 'b0:12345:respawn:/sbin/agetty 9600 ttyB0 vt100' )
	use s390 && insert=( 's0:12345:respawn:/sbin/agetty 38400 console dumb' )
	if use ibm ; then
		insert+=(
			'#hvc0:2345:respawn:/sbin/agetty -L 9600 hvc0'
			'#hvsi:2345:respawn:/sbin/agetty -L 19200 hvsi0'
		)
	fi
	(use arm || use mips || use sparc) && sed -i '/ttyS0/s:#::' inittab
	if use x86 || use amd64 ; then
		sed -i \
			-e '/ttyS[01]/s:9600:115200:' \
			inittab
	fi
	if [[ ${#insert[@]} -gt 0 ]] ; then
		printf '%s\n' '' '# Architecture specific features' "${insert[@]}" >> inittab
	fi
}

src_compile() {
	tc-export CC
	append-lfs-flags
	export DISTRO= #381311
	export VERSION="${PV}"
	use static && append-ldflags -static
	emake -C src $(usex selinux 'WITH_SELINUX=yes' '')
}

src_install() {
	emake -C src install ROOT="${D}"
	dodoc README doc/*

	insinto /etc
	doins "${WORKDIR}"/inittab

	newinitd "${FILESDIR}"/bootlogd.initd bootlogd
	newconfd "${FILESDIR}"/bootlogd.confd bootlogd
	into /
	dosbin "${FILESDIR}"/halt.sh

	keepdir /etc/inittab.d

	# dead symlink
	find "${ED}" -xtype l -delete || die

	find "${ED}" -type d -empty -delete || die
}

pkg_postinst() {
	# Reload init to fix unmounting problems of / on next reboot.
	# This is really needed, as without the new version of init cause init
	# not to quit properly on reboot, and causes a fsck of / on next reboot.
	if [[ -z ${ROOT} ]] ; then
		if [[ -e /dev/initctl ]] && [[ ! -e /run/initctl ]] ; then
			ln -s /dev/initctl /run/initctl \
				|| ewarn "Failed to set /run/initctl symlink!"
		fi
		# Do not return an error if this fails
		/sbin/telinit U &>/dev/null
	fi

	elog "The last/lastb/mesg/mountpoint/sulogin/utmpdump/wall tools have been moved to"
	elog "sys-apps/util-linux. The pidof tool has been moved to sys-process/procps."

	# Required for new bootlogd service
	if [[ ! -e "${EROOT}/var/log/boot" ]] ; then
		touch "${EROOT}/var/log/boot"
	fi
}
