# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 eutils

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://projects.archlinux.org/netctl.git"
	inherit git-r3
	DEPEND="app-text/asciidoc"
else
	SRC_URI="https://sources.archlinux.org/other/packages/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Profile based network connection tool from Arch Linux"
HOMEPAGE="https://wiki.archlinux.org/index.php/Netctl
	https://www.archlinux.org/packages/core/any/netctl/
	https://projects.archlinux.org/netctl.git/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND+="
	virtual/pkgconfig
	>=sys-apps/systemd-233
"
RDEPEND="
	>=app-shells/bash-4.0
	>=net-dns/openresolv-3.5.4-r1
	sys-apps/iproute2
	>=sys-apps/systemd-233
	!<net-misc/dhcpcd-6.4.0
"

src_prepare() {
	default
	sed -i -e "s:/usr/bin/ifplugd:/usr/sbin/ifplugd:" \
		"services/netctl-ifplugd@.service" || die
}

src_compile() {
	return 0
}

src_install() {
	emake DESTDIR="${D%/}" SHELL=bash install
	dodoc AUTHORS NEWS README
	newbashcomp contrib/bash-completion netctl
	bashcomp_alias netctl netctl-auto wifi-menu
	insinto /usr/share/zsh/site-functions
	newins contrib/zsh-completion _netctl
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "To get additional features, a number of optional runtime dependencies may be"
		elog "installed."
		optfeature "DHCP support" net-misc/dhcpcd ">=net-misc/dhcp-5.6.7[client]"
		optfeature "WPA support" net-wireless/wpa_supplicant
		optfeature "interactive assistant" dev-util/dialog
		optfeature "automatic connection" sys-apps/ifplugd
		optfeature "bonding support" net-misc/ifenslave
		optfeature "dialup support" net-dialup/ppp
	fi
	for v in ${REPLACING_VERSIONS}; do
		if ver_test "${v}" -lt "1.18" || ver_test "${v}" -eq "9999"; then
			grep -ls '^.include '  "${ROOT%/}"/etc/systemd/system/netctl@*.service | sed -r 's/.*@([^@]*)\.service/\1/' | \
			while read -r unit; do
				profile=$(systemd-escape --unescape "$unit")
				elog "The unit for profile '$profile' uses deprecated features."
				elog "Consider running: netctl reenable $(printf '%q' "$profile")"
			done
		fi
	done
}
