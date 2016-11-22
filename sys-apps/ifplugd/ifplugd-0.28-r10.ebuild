# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Brings up/down ethernet ports automatically with cable detection"
HOMEPAGE="http://0pointer.de/lennart/projects/ifplugd/"
SRC_URI="http://0pointer.de/lennart/projects/ifplugd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~hppa ~ppc ~x86"
IUSE="doc selinux"

DEPEND="virtual/pkgconfig
	doc? ( www-client/lynx )
	>=dev-libs/libdaemon-0.5"
RDEPEND=">=dev-libs/libdaemon-0.5
	>=sys-apps/baselayout-1.12
	selinux? ( sec-policy/selinux-ifplugd )"

PATCHES=(
	"${FILESDIR}/${P}-nlapi.diff"
	"${FILESDIR}/${P}-interface.patch"
	"${FILESDIR}/${P}-strictalias.patch"
	"${FILESDIR}/${P}-noip.patch"
	"${FILESDIR}/${P}-musl.patch"
	)
DOCS=( doc/README doc/SUPPORTED_DRIVERS )
HTML_DOCS=( doc/README.html doc/style.css )

src_configure() {
	econf \
		$(use_enable doc lynx) \
		--with-initdir=/etc/init.d \
		--disable-xmltoman \
		--disable-subversion
}

src_install() {
	default

	# Remove init.d configuration as we no longer use it
	rm -rf "${ED}/etc/ifplugd" "${ED}/etc/init.d/${PN}" || die

	exeinto "/etc/${PN}"
	newexe "${FILESDIR}/${PN}.action" "${PN}.action"
}
