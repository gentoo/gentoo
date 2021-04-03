# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Builds a chroot and configures all the required files, directories and libraries"
HOMEPAGE="https://github.com/spiculator/jail"
SRC_URI="https://github.com/spiculator/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"

RDEPEND="
	dev-lang/perl
	dev-util/strace
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9-gentoo.patch
	"${FILESDIR}"/${PN}-1.9-wrongshell.patch
	"${FILESDIR}"/${PN}-1.9-multiuser-rsa.patch
	"${FILESDIR}"/${PN}-1.9-ldflags.patch
	"${FILESDIR}"/${PN}-2.0-sysmacros.patch
	"${FILESDIR}"/${PN}-2.0-symlinks.patch #659094
	"${FILESDIR}"/${PN}-2.0-fix-paths.patch #646116
	# https://github.com/spiculator/jail/issues/2
	"${FILESDIR}"/${PN}-2.0-openat-syscall.patch
	# https://github.com/spiculator/jail/issues/3
	"${FILESDIR}"/${PN}-2.0-ldd-call.patch
	"${FILESDIR}"/${PN}-2.0-duplicate-jail.patch #668898
)

src_compile() {
	emake -C src CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	# configuration files should be installed in /etc not /usr/etc
	sed -i "s:\$4/etc:\${D}/etc:g" install.sh || die

	# the destination directory should be /usr not /usr/local
	sed -i \
		-e "s:usr/local:${D}/usr:g" \
		-e "s:^COPT =.*:COPT = -Wl,-z,no:g" \
		src/Makefile || die

	emake -C src install

	# remove //var/tmp/portage/${P}/image//usr from files
	FILES=(
		"${ED}/usr/bin/mkjailenv"
		"${ED}/usr/bin/addjailsw"
		"${ED}/usr/bin/addjailuser"
		"${ED}/etc/jail.conf"
		"${ED}/usr/lib/libjail.pm"
		"${ED}/usr/lib/arch/generic/definitions"
		"${ED}/usr/lib/arch/generic/functions"
		"${ED}/usr/lib/arch/linux/definitions"
		"${ED}/usr/lib/arch/linux/functions"
		"${ED}/usr/lib/arch/freebsd/definitions"
		"${ED}/usr/lib/arch/freebsd/functions"
		"${ED}/usr/lib/arch/irix/definitions"
		"${ED}/usr/lib/arch/irix/functions"
		"${ED}/usr/lib/arch/solaris/definitions"
		"${ED}/usr/lib/arch/solaris/functions"
	)

	for f in "${FILES[@]}"; do
		sed -i "s:/${D}/usr:/usr:g" ${f} || die
	done

	sed -i "s:/usr/etc:/etc:" "${ED}"/usr/lib/libjail.pm || die

	dodoc doc/{CHANGELOG,INSTALL,README,SECURITY,VERSION}
}
