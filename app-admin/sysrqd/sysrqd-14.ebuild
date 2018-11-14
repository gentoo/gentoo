# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="daemon providing access to the kernel sysrq functions via network"
HOMEPAGE="http://julien.danjou.info/projects/sysrqd"
#SRC_URI="http://julien.danjou.info/${PN}/${P}.tar.gz"
SRC_URI="https://dev.gentoo.org/~wschlich/src/${CATEGORY}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${PN}-config.patch
	"${FILESDIR}"/${PN}-14-fix-build-system.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dosbin sysrqd
	newinitd "${FILESDIR}/sysrqd.init" sysrqd

	local bindip='127.0.0.1' secret
	declare -i secret
	let secret=${RANDOM}*${RANDOM}*${RANDOM}*${RANDOM}
	echo ${bindip} > sysrqd.bind || die
	echo ${secret} > sysrqd.secret || die

	diropts -m 0700 -o root -g root
	dodir /etc/sysrqd
	insinto /etc/sysrqd
	insopts -m 0600 -o root -g root
	doins sysrqd.bind
	doins sysrqd.secret

	einstalldocs
}

pkg_postinst() {
	elog
	elog "Be sure to change the initial secret in /etc/sysrqd/sysrqd.secret !"
	elog "As a security precaution, sysrqd is configured to only listen on"
	elog "127.0.0.1 by default. Change the content of /etc/sysrqd/sysrqd.bind"
	elog "to an IPv4 address you want it to listen on or remove the file"
	elog "to make it listen on any IP address (0.0.0.0)."
	elog
}
