# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic

DESCRIPTION="a tool that builds a chroot and configures all the required files, directories and libraries"
HOMEPAGE="https://github.com/spiculator/jail"
SRC_URI="https://github.com/spiculator/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=sys-apps/sed-4"
RDEPEND="dev-lang/perl
	dev-util/strace"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.9-gentoo.patch \
		"${FILESDIR}"/${PN}-1.9-wrongshell.patch \
		"${FILESDIR}"/${PN}-1.9-multiuser-rsa.patch \
		"${FILESDIR}"/${PN}-1.9-ldflags.patch
}

src_compile() {
	# configuration files should be installed in /etc not /usr/etc
	sed -i "s:\$4/etc:\${D}/etc:g" install.sh || die

	# the destination directory should be /usr not /usr/local
	sed -i -e "s:usr/local:${D}/usr:g" \
		-e "s:^COPT =.*:COPT = -Wl,-z,no:g" src/Makefile || die

	# Below didn't work. Don't know why
	#append-ldflags -Wl,-z,now
	emake -C src CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	emake -C src install

	# remove //var/tmp/portage/${P}/image//usr from files
	FILES=( "${D}/usr/bin/mkjailenv"
		"${D}/usr/bin/addjailsw"
		"${D}/usr/bin/addjailuser"
		"${D}/etc/jail.conf"
		"${D}/usr/lib/libjail.pm"
		"${D}/usr/lib/arch/generic/definitions"
		"${D}/usr/lib/arch/generic/functions"
		"${D}/usr/lib/arch/linux/definitions"
		"${D}/usr/lib/arch/linux/functions"
		"${D}/usr/lib/arch/freebsd/definitions"
		"${D}/usr/lib/arch/freebsd/functions"
		"${D}/usr/lib/arch/irix/definitions"
		"${D}/usr/lib/arch/irix/functions"
		"${D}/usr/lib/arch/solaris/definitions"
		"${D}/usr/lib/arch/solaris/functions" )

	for f in "${FILES[@]}"; do
		sed -i "s:/${D}/usr:/usr:g" ${f} || die
	done

	sed -i "s:/usr/etc:/etc:" "${D}"/usr/lib/libjail.pm || die

	dodoc doc/{CHANGELOG,INSTALL,README,SECURITY,VERSION}
}
