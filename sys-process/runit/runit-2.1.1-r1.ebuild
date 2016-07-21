# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="http://smarden.org/runit/"
SRC_URI="http://smarden.org/runit/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="static"

S=${WORKDIR}/admin/${P}/src

src_prepare() {
	# we either build everything or nothing static
	sed -i -e 's:-static: :' Makefile
}

src_configure() {
	use static && append-ldflags -static

	echo "$(tc-getCC) ${CFLAGS}"  > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
}

src_install() {
	dodir /var
	keepdir /etc/runit{,/runsvdir{,/default,/all}}
	dosym default /etc/runit/runsvdir/current
	dosym ../etc/runit/runsvdir/current /var/service
	dosym ../etc/runit/2 /sbin/runsvdir-start

	dobin $(<../package/commands) || die "dobin"
	dodir /sbin
	mv "${ED}"/usr/bin/{runit-init,runit,utmpset} "${ED}"/sbin/ || die "dosbin"

	cd "${S}"/..
	dodoc package/{CHANGES,README,THANKS,TODO}
	dohtml doc/*.html
	doman man/*.[18]

	exeinto /etc/runit
	doexe "${FILESDIR}"/{1,2,3,ctrlaltdel} || die
	for tty in tty1 tty2 tty3 tty4 tty5 tty6; do
		exeinto /etc/runit/runsvdir/all/getty-$tty/
		for script in run finish; do
			newexe "${FILESDIR}"/$script.getty $script
			dosed "s:TTY:${tty}:g" /etc/runit/runsvdir/all/getty-$tty/$script
		done
		dosym ../all/getty-$tty /etc/runit/runsvdir/default/getty-$tty
	done

	# make sv command work
	cd "${S}"
	insinto /etc/env.d
	cat <<-EOF > env.d
		#/etc/env.d/20runit
		SVDIR="/var/service/"
	EOF
	newins env.d 20runit
}

pkg_postinst() {
	ewarn "/etc/profile was updated. Please run:"
	ewarn "source /etc/profile"
	ewarn "to make 'sv' work correctly on your currently open shells"
}
