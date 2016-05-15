# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils flag-o-matic

DESCRIPTION="Modifies ELFs to avoid runtime symbol resolutions resulting in faster load times"
HOMEPAGE="https://people.redhat.com/jakub/prelink"

SRC_URI="mirror://gentoo/${P}.tar.bz2"
#SRC_URI="https://people.redhat.com/jakub/prelink/${P}.tar.bz2"

# if not available on jakub's dev space extract the distfile with rpm2tarbz2 from
# https://mirrors.kernel.org/fedora/development/rawhide/source/SRPMS/p/prelink-[ver].src.rpm
#
# track http://pkgs.fedoraproject.org/cgit/prelink.git/ for updates

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 -arm ~ppc ~ppc64 ~x86"
IUSE="selinux"

DEPEND=">=dev-libs/elfutils-0.100[static-libs(+)]
	selinux? ( sys-libs/libselinux[static-libs(+)] )
	!dev-libs/libelf
	>=sys-libs/glibc-2.8"
RDEPEND="${DEPEND}
	>=sys-devel/binutils-2.18"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-20130503-prelink-conf.patch
	epatch "${FILESDIR}"/${PN}-20130503-libiberty-md5.patch
	epatch "${FILESDIR}"/${PN}-armhf-dynamic-linker.patch

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.in || die #469126

	sed -i -e '/^CC=/s: : -Wl,--disable-new-dtags :' testsuite/functions.sh #100147
	# >=binutils-2.22 --no-copy-dt-needed-entries is the default
	# --copy-dt-needed-entries was renamed from --add-needed in 2.21, use the
	# former so we don't have to bump the dep
	sed -i \
		-e '/CCLINK=/s:CCLINK="$(CC):& -Wl,--add-needed :' \
		-e '/CXXLINK=/s:CXXLINK="$(CXX):& -Wl,--add-needed :' \
		testsuite/Makefile.am

	has_version 'dev-libs/elfutils[threads]' && append-ldflags -pthread

	eautoreconf # prevent maintainer mode

	# have to do this after eautoreconf or automake barfs on the trailing
	# backslash of the previous line
	sed -i -e 's:undosyslibs.sh::' testsuite/Makefile.in #254201

	export ac_cv_{header_selinux_selinux_h,lib_selinux_is_selinux_enabled}=$(usex selinux)
}

src_install() {
	default

	insinto /etc
	doins doc/prelink.conf

	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/prelink.cron prelink
	newconfd "${FILESDIR}"/prelink.confd prelink
}

pkg_postinst() {
	if [ -z "${REPLACING_VERSIONS}" ] ; then
		elog "You may wish to read the Gentoo Linux Prelink Guide, which can be"
		elog "found online at:"
		elog "    https://wiki.gentoo.org/wiki/Prelink"
		elog "Please edit /etc/conf.d/prelink to enable and configure prelink"
	fi
}
