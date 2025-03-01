# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P=netkit-ntalk-${PV}

DESCRIPTION="Netkit - talkd: Daemon to help set up talk sessions"
HOMEPAGE="https://wiki.linuxfoundation.org/networking/netkit"
SRC_URI="http://ftp.linux.org.uk/pub/linux/Networking/netkit/${MY_P}.tar.gz"
S="${WORKDIR}"/netkit-ntalk-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~mips ppc ppc64 sparc x86"

DEPEND=">=sys-libs/ncurses-5.2:="
BDEPEND="virtual/pkgconfig"
RDEPEND="
	${DEPEND}
	virtual/inetd
	!net-misc/inetutils[talkd(+)]
"

PATCHES=(
	"${FILESDIR}"/${P}-time.patch
	"${FILESDIR}"/${P}-ipv6.patch
)

src_prepare() {
	default
	sed -i configure -e '/^LDFLAGS=/d' || die
}

src_configure() {
	# not autotools based?
	./configure --with-c-compiler="$(tc-getCC)" || die
}

src_compile() {
	emake LIBCURSES="$( $(tc-getPKG_CONFIG) --libs ncurses )"
}

src_install() {
	insinto /etc/xinetd.d
	newins "${FILESDIR}"/talk.xinetd talk
	dobin talk/talk
	doman talk/talk.1
	dosbin talkd/talkd
	dosym talkd /usr/sbin/in.talkd
	doman talkd/talkd.8
	dosym talkd.8 /usr/share/man/man8/in.talkd.8
	dodoc README ChangeLog BUGS
}
