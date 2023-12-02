# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://git.code.sf.net/p/net-tools/code"
	inherit git-r3
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Standard Linux networking tools"
HOMEPAGE="https://net-tools.sourceforge.io/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+arp +hostname ipv6 nis nls plipconfig selinux slattach static"
REQUIRED_USE="nis? ( hostname )"

DEPEND="selinux? ( sys-libs/libselinux )"
RDEPEND="${DEPEND}
	hostname? ( !sys-apps/coreutils[hostname] )
	nis? ( !net-nds/yp-tools )"
BDEPEND="
	selinux? ( virtual/pkgconfig )
	app-arch/xz-utils
"
if [[ ${PV} == "9999" ]]; then
	BDEPEND+=" nls? ( sys-devel/gettext )"
fi

set_opt() {
	local opt=$1 ans
	shift
	ans=$("$@" && echo y || echo n)
	einfo "Setting option ${opt} to ${ans}"
	sed -i \
		-e "/^bool.* ${opt} /s:[yn]$:${ans}:" \
		config.in || die
}

src_configure() {
	# Clear out env vars from the user. #599602
	unset BASEDIR BINDIR SBINDIR

	set_opt I18N use nls
	set_opt HAVE_AFINET6 use ipv6
	set_opt HAVE_HWIB has_version '>=sys-kernel/linux-headers-2.6'
	set_opt HAVE_HWTR has_version '<sys-kernel/linux-headers-3.5'
	set_opt HAVE_HWSTRIP has_version '<sys-kernel/linux-headers-3.6'
	set_opt HAVE_SELINUX use selinux
	set_opt HAVE_ARP_TOOLS use arp
	set_opt HAVE_HOSTNAME_TOOLS use hostname
	set_opt HAVE_HOSTNAME_SYMLINKS use nis
	set_opt HAVE_PLIP_TOOLS use plipconfig
	set_opt HAVE_SERIAL_TOOLS use slattach
	if use static ; then
		append-flags -static
		append-ldflags -static
	fi
	tc-export AR CC
	yes "" | ./configure.sh config.in || die
}

src_install() {
	# We need to use emake by hand to pass ED. #567300
	emake DESTDIR="${ED}" install
	dodoc README THANKS TODO
}
