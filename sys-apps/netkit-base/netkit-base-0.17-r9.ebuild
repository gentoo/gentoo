# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Old-style inetd"
HOMEPAGE="https://wiki.linuxfoundation.org/networking/netkit"
SRC_URI="http://ftp.linux.org.uk/pub/linux/Networking/netkit/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86"

PATCHES=(
	"${FILESDIR}"/003_all_netkit-base-0.17-gcc4.patch
	"${FILESDIR}"/004_all_netkit-base-0.17-misc-fixes.patch
	"${FILESDIR}"/005_all_netkit-base-0.17-no-rpc.patch
)

src_configure() {
	tc-export CC

	./configure || die
	sed -i \
		-e "/^CFLAGS=/s:=.*:=${CFLAGS} -Wall -Wbad-function-cast -Wcast-qual -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Winline:" \
		-e "/^LDFLAGS=/s:=.*:=${LDFLAGS}:" \
		MCONFIG || die
}

src_install() {
	sed -i \
		-e 's:in\.telnetd$:in.telnetd -L /usr/sbin/telnetlogin:' \
		etc.sample/inetd.conf || die

	dosbin inetd/inetd
	doman inetd/inetd.8
	newinitd "${FILESDIR}"/inetd.rc6 inetd

	dodoc BUGS ChangeLog README
	docinto samples
	dodoc -r etc.sample/.
}
