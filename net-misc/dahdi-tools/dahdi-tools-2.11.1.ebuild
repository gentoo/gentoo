# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1

DESCRIPTION="Userspace tools to configure the kernel modules from net-misc/dahdi"
HOMEPAGE="http://www.asterisk.org"
SRC_URI="http://downloads.asterisk.org/pub/telephony/${PN}/releases/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="ppp"
PATCHES=( "${FILESDIR}/dahdi-nondigium-blacklist.patch" )

DEPEND="dev-libs/newt
	ppp? ( net-dialup/ppp )
	>=net-misc/dahdi-2.5.0
	!net-misc/zaptel
	>=sys-kernel/linux-headers-2.6.35
	virtual/libusb:0"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with ppp)
}

src_install() {
	local bashcompdir="$(get_bashcompdir)"
	local bashcmd bashcmdtarget

	emake DESTDIR="${D}" bashcompdir="${bashcompdir}" udevrulesdir=/lib/udev/rules.d install
	emake DESTDIR="${D}" install-config

	dosbin patgen pattest patlooptest hdlcstress hdlctest hdlcgen hdlcverify timertest

	# install init scripts
	newinitd "${FILESDIR}"/dahdi.init2 dahdi
	newinitd "${FILESDIR}"/dahdi-autoconf.init2 dahdi-autoconf
	newconfd "${FILESDIR}"/dahdi-autoconf.conf2 dahdi-autoconf

	# Fix up bash completion ... to Gentoo standards...
	for bashcmd in $(sed -nre 's/^complete -F .* //p' "${D}${bashcompdir}/dahdi"); do
		if [ -z "${bashcmdtarget}" ]; then
			mv "${D}${bashcompdir}/dahdi" "${D}${bashcompdir}/${bashcmd}"
			bashcmdtarget="${bashcmd}"
		else
			dosym "${bashcmdtarget}" "${bashcompdir}/${bashcmd}"
		fi
	done
}
