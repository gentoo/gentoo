# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/icecream/icecream-0.9.7-r1.ebuild,v 1.3 2012/08/23 11:42:07 xarthisius Exp $

EAPI=4

inherit autotools base user

MY_P=icecc-${PV}

DESCRIPTION="icecc is a program for distributed compiling of C(++) code across several machines; based on distcc"
HOMEPAGE="http://en.opensuse.org/Icecream"
SRC_URI="ftp://ftp.suse.com/pub/projects/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sparc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/0.9.6-symlinks.patch"
	"${FILESDIR}/0.9.6-crosscompile.patch"
	"${FILESDIR}/${PV}-automake.patch"
	"${FILESDIR}/${PV}-glibc2.16.patch"
	"${FILESDIR}/${PN}-conf.d-verbosity.patch"
	"${FILESDIR}/${PN}-gentoo-multilib.patch"
)

pkg_setup() {
	enewgroup icecream
	enewuser icecream -1 -1 /var/cache/icecream icecream
}

src_prepare() {
	base_src_prepare
	sed -i -e "s/Defaut/Default/g" suse/sysconfig.icecream || die #275761
	eautoreconf
}

src_install() {
	default

	dosbin "${FILESDIR}"/icecream-config
	dosbin "${FILESDIR}"/icecream-create-env

	newconfd suse/sysconfig.icecream icecream
	doinitd "${FILESDIR}"/icecream

	diropts -m0755
	keepdir /usr/lib/icecc/bin
}

pkg_postinst() {
	ebegin "Scanning for compiler front-ends..."
	/usr/sbin/icecream-config --install-links
	/usr/sbin/icecream-config --install-links "${CHOST}"
	eend ${?}

	elog
	elog "If you have compiled binutils/gcc/glibc with processor-specific flags"
	elog "(as normal using Gentoo), there is a greater chance that your compiler"
	elog "won't work on other machines. The best would be to build gcc, glibc and"
	elog "binutils without those flags and then copy the needed files into your"
	elog "tarball for distribution to other machines. This tarball can be created"
	elog "by running /usr/bin/icecc --build-native, and used by setting"
	elog "ICECC_VERSION in /etc/conf.d/icecream"
	elog '  ICECC_VERSION=<filename_of_archive_containing_your_environment>'
	elog
	elog "To use icecream with portage add the following line to /etc/make.conf"
	elog '  PREROOTPATH=/usr/lib/icecc/bin'
	elog
	elog "To use icecream with normal make use (e.g. in /etc/profile)"
	elog '  PATH=/usr/lib/icecc/bin:$PATH'
	elog
	elog "N.B. To use icecream with ccache, the ccache PATH should come first:"
	elog '  PATH=/usr/lib/ccache/bin:/usr/lib/icecc/bin:$PATH'
	elog
	elog "Don't forget to open the following ports in your firewall(s):"
	elog " TCP/10245 on the daemon computers (required)"
	elog " TCP/8765 for the the scheduler computer (required)"
	elog " TCP/8766 for the telnet interface to the scheduler (optional)"
	elog " UDP/8765 for broadcast to find the scheduler (optional)"
	elog
	elog "Further usage instructions: ${HOMEPAGE}"
}
