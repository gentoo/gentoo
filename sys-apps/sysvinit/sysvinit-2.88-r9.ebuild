# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="/sbin/init - parent of all processes"
HOMEPAGE="https://savannah.nongnu.org/projects/sysvinit"
SRC_URI="mirror://nongnu/${PN}/${P}dsf.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="selinux ibm static kernel_FreeBSD"

CDEPEND="
	selinux? (
		>=sys-libs/libselinux-1.28
	)"
DEPEND="${CDEPEND}
	virtual/os-headers"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-shutdown )
"

S=${WORKDIR}/${P}dsf

PATCHES=(
	"${FILESDIR}/${PN}-2.86-kexec.patch" #80220
	"${FILESDIR}/${PN}-2.86-shutdown-single.patch" #158615
	"${FILESDIR}/${P}-makefile.patch" #319197
	"${FILESDIR}/${P}-selinux.patch" #326697
	"${FILESDIR}/${P}-shutdown-h.patch" #449354
	"${FILESDIR}/${PN}-2.88-sysmacros.patch"
	"${FILESDIR}/${PN}-2.88-ttydefaults.patch" #551626
)

src_prepare() {
	epatch "${PATCHES[@]}"
	sed -i '/^CPPFLAGS =$/d' src/Makefile || die

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

	# Mung inittab for specific architectures
	cd "${WORKDIR}"
	cp "${FILESDIR}"/inittab-2.88 inittab || die "cp inittab"
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
	(use arm || use mips || use sh || use sparc) && sed -i '/ttyS0/s:#::' inittab
	if use kernel_FreeBSD ; then
		sed -i \
			-e 's/linux/cons25/g' \
			-e 's/ttyS0/cuaa0/g' \
			-e 's/ttyS1/cuaa1/g' \
			inittab #121786
	fi
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
	local myconf

	tc-export CC
	append-lfs-flags
	export DISTRO= #381311
	use static && append-ldflags -static
	use selinux && myconf=WITH_SELINUX=yes
	emake -C src ${myconf} || die
}

src_install() {
	emake -C src install ROOT="${D}"
	dodoc README doc/*

	insinto /etc
	doins "${WORKDIR}"/inittab

	# dead symlink
	rm "${D}"/usr/bin/lastb || die
}

pkg_postinst() {
	# Reload init to fix unmounting problems of / on next reboot.
	# This is really needed, as without the new version of init cause init
	# not to quit properly on reboot, and causes a fsck of / on next reboot.
	if [[ ${ROOT} == / ]] ; then
		# Do not return an error if this fails
		/sbin/telinit U &>/dev/null
	fi

	elog "The last/lastb/mesg/mountpoint/sulogin/utmpdump/wall tools have been moved to"
	elog "sys-apps/util-linux. The pidof tool has been moved to sys-process/procps."
}
