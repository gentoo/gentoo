# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake

PATCHLEVEL=42
DESCRIPTION="Standard Linux telnet client and server"
HOMEPAGE="https://wiki.linuxfoundation.org/networking/netkit"
# http://packages.debian.org/stablesource/netkit-telnet
# http://packages.debian.org/testing/source/netkit-telnet
SRC_URI="http://ftp.linux.org.uk/pub/linux/Networking/netkit/netkit-telnet-${PV}.tar.gz
	mirror://debian/pool/main/n/netkit-telnet/netkit-telnet_0.17-${PATCHLEVEL}.debian.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"
IUSE="selinux"

DEPEND="
	>=sys-libs/ncurses-5.2:=
	!net-misc/telnet-bsd
	!net-misc/inetutils[telnet(-)]
	!net-misc/inetutils[telnetd(-)]
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-telnet )
"

S=${WORKDIR}/netkit-telnet-${PV}

src_prepare() {
	# Patch: [0]
	# Gentoo used to lack a maintainer for this package.
	# A security problem arose. While reviewing our options for how
	# should we proceed with the security bug we decided it would be
	# better to just stay in sync with debian's own netkit-telnet
	# package. Lots of bug fixes by them over time which were not in
	# our telnetd.
	rm "${WORKDIR}/debian/patches/use-cmake-as-buildsystem-debian-extras.patch" || die
	eapply "${WORKDIR}/debian/patches"
	eapply "${FILESDIR}/netkit-telnetd-0.17-r13-gentooification.patch"

	cmake_src_prepare
}

src_install() {
	cmake_src_install

	dosym telnetd /usr/sbin/in.telnetd
	dodoc "${FILESDIR}/net.issue.sample"
	newdoc telnet/README README.telnet
	newdoc telnet/TODO TODO.telnet
	insinto /etc/xinetd.d
	newins "${FILESDIR}/telnetd.xinetd" telnetd
}
