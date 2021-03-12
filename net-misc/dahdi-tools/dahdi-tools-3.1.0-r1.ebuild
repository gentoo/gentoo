# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1 perl-functions

DESCRIPTION="Userspace tools to configure the kernel modules from net-misc/dahdi"
HOMEPAGE="https://www.asterisk.org"
SRC_URI="https://downloads.asterisk.org/pub/telephony/${PN}/releases/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="ppp"
PATCHES=(
	"${FILESDIR}/dahdi-nondigium-blacklist.patch"
	"${FILESDIR}/dahdi-tools-3.1.0-parallel-make-no-config.patch"
	"${FILESDIR}/dahdi-tools-3.1.0-fno-common.patch"
	"${FILESDIR}/dahdi-tools-3.1.0-execinfo.patch"
	"${FILESDIR}/dahdi-tools-3.1.0-cplusplusexternc.patch"
)

DEPEND="dev-libs/newt
	net-misc/dahdi
	sys-kernel/linux-headers
	virtual/libusb:0
	ppp? ( net-dialup/ppp )"
RDEPEND="${DEPEND}
	dev-lang/perl:=
	dev-perl/CGI"
BDEPEND="dev-lang/perl
	sys-apps/file"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with ppp) --with-perllib="$(perl_get_vendorlib)"
	sed -re 's/ -Werror($|[[:space:]])//' -i xpp/oct612x/Makefile.in || die "sed to eliminate -Werror failed."
	sed -re '/[[:space:]]*-Werror[[:space:]]*\\$/ d' -i xpp/xtalk/Makefile || die "sed to eliminate -Werror failed."
}

src_install() {
	local bashcompdir="$(get_bashcompdir)"
	local bashcmd bashcmdtarget

	emake DESTDIR="${ED}" bashcompdir="${bashcompdir}" udevrulesdir=/lib/udev/rules.d install
	emake DESTDIR="${ED}" install-config

	dosbin patgen pattest patlooptest hdlcstress hdlctest hdlcgen hdlcverify timertest

	# install init scripts
	newinitd "${FILESDIR}"/dahdi.init2 dahdi
	newinitd "${FILESDIR}"/dahdi-autoconf.init2 dahdi-autoconf
	newconfd "${FILESDIR}"/dahdi-autoconf.conf2 dahdi-autoconf

	bashcomp_alias dahdi $(sed -nre 's/^complete -F .* //p' "${ED}${bashcompdir}/dahdi" ||
		die "Error parsing dahdi bash completion file for commands")

	rm "${ED}"/usr/$(get_libdir)/libtonezone.{la,a} || die "Unable to remove static libs from install."
}
