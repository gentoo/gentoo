# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/alsa-oss/alsa-oss-1.0.25-r1.ebuild,v 1.2 2014/08/10 21:07:26 slyfox Exp $

EAPI=5

inherit autotools eutils multilib multilib-minimal

MY_P="${P/_rc/rc}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Advanced Linux Sound Architecture OSS compatibility layer"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/oss-lib/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="static-libs"

RDEPEND=">=media-libs/alsa-lib-${PV}[${MULTILIB_USEDEP}]
	abi_x86_32? (
		!<app-emulation/emul-linux-x86-soundlibs-20140406-r1
		!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32]
	)"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/${PN}-1.0.12-hardened.patch" )

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static)
}

src_prepare() {
	eautoreconf
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all
	sed -i -e 's:\${exec_prefix}/\\$LIB/::' "${D}/usr/bin/aoss" || die
}
