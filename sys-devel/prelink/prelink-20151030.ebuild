# Copyright 2002-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

MY_PN="${PN}-cross"
MY_P="${MY_PN}-${PV}"

inherit autotools eutils flag-o-matic

DESCRIPTION="Modifies ELFs to avoid runtime symbol resolutions resulting in faster load times"
HOMEPAGE="https://git.yoctoproject.org/cgit/cgit.cgi/prelink-cross/ https://people.redhat.com/jakub/prelink"
SRC_URI="https://git.yoctoproject.org/cgit/cgit.cgi/${MY_PN}/snapshot/${MY_P}.tar.bz2
	doc? ( https://people.redhat.com/jakub/prelink/prelink.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="doc selinux"

RDEPEND=">=dev-libs/elfutils-0.100
	selinux? ( sys-libs/libselinux )
	!dev-libs/libelf"
DEPEND="${RDEPEND}
	sys-libs/binutils-libs"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-20130503-prelink-conf.patch
	epatch "${FILESDIR}"/${PN}-20130503-libiberty-md5.patch

	sed -i -e '/^CC=/s: : -Wl,--disable-new-dtags :' testsuite/functions.sh #100147

	has_version 'dev-libs/elfutils[threads]' && append-ldflags -pthread

	eautoreconf
}

src_configure() {
	econf $(use_enable selinux)
}

src_install() {
	default

	use doc && dodoc "${DISTDIR}"/prelink.pdf

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
