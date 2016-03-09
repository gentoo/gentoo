# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

PATCHLEVEL=40
DESCRIPTION="Standard Linux telnet client and server"
#old HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
# This might be the best HOMEPAGE now?
HOMEPAGE="https://launchpad.net/netkit-telnet"
# http://packages.debian.org/stablesource/netkit-telnet
# http://packages.debian.org/testing/source/netkit-telnet
# No upstream mirror exists anymore?
# old ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/netkit-telnet-${PV}.tar.gz
SRC_URI="mirror://gentoo/netkit-telnet-${PV}.tar.gz
	mirror://debian/pool/main/n/netkit-telnet/netkit-telnet_0.17-${PATCHLEVEL}.debian.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.2:=
	!net-misc/telnet-bsd"
RDEPEND="${DEPEND}"

S=${WORKDIR}/netkit-telnet-${PV}

src_prepare() {
	# Patch: [0]
	# Gentoo lacks a maintainer for this package right now. And a
	# security problem arose. While reviewing our options for how
	# should we proceed with the security bug we decided it would be
	# better to just stay in sync with debian's own netkit-telnet
	# package. Lots of bug fixes by them over time which were not in
	# our telnetd.
	EPATCH_FORCE="yes" EPATCH_SUFFIX="diff" epatch "${WORKDIR}"/debian/patches

	# Patch: [1]
	# after the deb patch we need to add a small patch that defines
	# gnu source. This is needed for gcc-3.4.x (needs to be pushed
	# back to the deb folk?)
	epatch "${FILESDIR}"/netkit-telnetd-0.17-cflags-gnu_source.patch

	# Fix portability issues.
	sed -i \
		-e 's:echo -n:printf %s:' \
		configure || die
}

src_configure() {
	tc-export CC CXX

	# Not a real autoconf script.
	./configure --prefix=/usr || die

	sed -i \
		-e "s:-pipe -O2:${CFLAGS}:" \
		-e "s:^\(LDFLAGS=\).*:\1${LDFLAGS}:" \
		-e "s:-Wpointer-arith::" \
		MCONFIG || die
}

src_compile() {
	emake
	emake -C telnetlogin
}

src_install() {
	dobin telnet/telnet

	dosbin telnetd/telnetd
	dosym telnetd /usr/sbin/in.telnetd
	dosbin telnetlogin/telnetlogin
	doman telnet/telnet.1
	doman telnetd/*.8
	doman telnetd/issue.net.5
	dosym telnetd.8 /usr/share/man/man8/in.telnetd.8
	doman telnetlogin/telnetlogin.8
	dodoc BUGS ChangeLog README
	dodoc "${FILESDIR}"/net.issue.sample
	newdoc telnet/README README.telnet
	newdoc telnet/TODO TODO.telnet
	insinto /etc/xinetd.d
	newins "${FILESDIR}"/telnetd.xinetd telnetd
}
