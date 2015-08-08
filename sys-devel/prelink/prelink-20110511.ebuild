# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils flag-o-matic

DESCRIPTION="Modifies ELFs to avoid runtime symbol resolutions resulting in faster load times"
HOMEPAGE="http://people.redhat.com/jakub/prelink"

SRC_URI="mirror://gentoo/${P}.tar.bz2"
#SRC_URI="http://people.redhat.com/jakub/prelink/${P}.tar.bz2"
#
# if not available rip the distfile with rpm2targz from
# http://mirrors.kernel.org/fedora/development/rawhide/source/SRPMS/prelink-[ver].src.rpm

# track http://pkgs.fedoraproject.org/gitweb/?p=prelink.git;a=summary for
# version bumps

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 -arm ppc ppc64 x86"
IUSE=""

DEPEND=">=dev-libs/elfutils-0.100[static-libs(+)]
	!dev-libs/libelf
	>=sys-libs/glibc-2.8"
RDEPEND="${DEPEND}
	>=sys-devel/binutils-2.18"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-20061201-prelink-conf.patch

	sed -i -e 's:undosyslibs.sh::' testsuite/Makefile.in #254201
	sed -i -e '/^CC=/s: : -Wl,--disable-new-dtags :' testsuite/functions.sh #100147

	# older GCCs don't support this flag
	# sed it from the Makefile then add it back to CFLAGS so we can use
	# strip-unsupported-flags
	sed -i -e 's:-Wno-pointer-sign::' src/Makefile.in #325269
	append-cflags -Wno-pointer-sign
	strip-unsupported-flags
}

src_install() {
	default

	insinto /etc
	doins doc/prelink.conf

	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/prelink.cron prelink
	newconfd "${FILESDIR}"/prelink.confd prelink

	dodir /var/{lib/misc,log}
	touch "${D}/var/lib/misc/prelink.full"
	touch "${D}/var/lib/misc/prelink.quick"
	touch "${D}/var/lib/misc/prelink.force"
	touch "${D}/var/log/prelink.log"
}

pkg_postinst() {
	echo
	elog "You may wish to read the Gentoo Linux Prelink Guide, which can be"
	elog "found online at:"
	elog
	elog "    https://wiki.gentoo.org/wiki/Prelink"
	elog
	elog "Please edit /etc/conf.d/prelink to enable and configure prelink"
	echo
	touch "${ROOT}/var/lib/misc/prelink.force"
}
