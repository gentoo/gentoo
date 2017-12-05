# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils systemd

DESCRIPTION="A simple entropy daemon using the HAVEGE algorithm"
HOMEPAGE="http://www.issihosts.com/haveged/"
SRC_URI="http://www.issihosts.com/haveged/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="selinux"

DEPEND=""
RDEPEND="!<sys-apps/openrc-0.11.8
		 selinux? ( sec-policy/selinux-entropyd )"

# threads are broken right now, but eventually
# we should add $(use_enable threads)
src_configure() {
	local myeconfargs=(
		--bindir=/usr/sbin
		--enable-nistest
		--disable-static
		--disable-threads
	)

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	# Install gentoo ones instead
	newinitd "${FILESDIR}"/haveged-init.d.3 haveged
	newconfd "${FILESDIR}"/haveged-conf.d haveged

	systemd_newunit "${FILESDIR}"/service.gentoo ${PN}.service
	insinto /etc
	doins "${FILESDIR}"/haveged.conf
}
