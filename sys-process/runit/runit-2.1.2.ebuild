# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs flag-o-matic versionator

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="http://smarden.org/runit/"
SRC_URI="http://smarden.org/runit/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="static"

S=${WORKDIR}/admin/${P}/src

src_prepare() {
	# we either build everything or nothing static
	sed -i -e 's:-static: :' Makefile

	# see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=726008
	[[ ${COMPILER} == "diet" ]] &&
		use ppc &&
		filter-flags "-mpowerpc-gpopt"
}

src_configure() {
	use static && append-ldflags -static

	echo "$(tc-getCC) ${CFLAGS}"  > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
}

src_install() {
	into /
	dobin $(<../package/commands)
	dodir /sbin
	mv "${ED}"/bin/{runit-init,runit,utmpset} "${ED}"/sbin/ || die "dosbin"
	dosym ../etc/runit/2 /sbin/runsvdir-start
	into /usr

	cd ..
	dodoc package/{CHANGES,README,THANKS,TODO}
	dohtml doc/*.html
	doman man/*.[18]

dodir /etc/runit
	exeinto /etc/runit
	doexe "${FILESDIR}"/{1,ctrlaltdel}
	newexe "${FILESDIR}"/2-${PV} 2
	newexe "${FILESDIR}"/3-${PV} 3

	dodir /etc/sv
	for tty in tty1 tty2 tty3 tty4 tty5 tty6; do
		exeinto /etc/sv/getty-$tty/
		newexe "${FILESDIR}"/finish.getty finish
		newexe "${FILESDIR}"/run.getty-${PV} run
		for script in finish run; do
			sed -i -e "s:TTY:${tty}:g" "${ED}"/etc/sv/getty-$tty/$script
		done
	done

	# make sv command work
	cat <<-EOF > "${T}"/env.d
		#/etc/env.d/20runit
		SVDIR="/etc/service/"
	EOF
	insinto /etc/env.d
	newins "${T}"/env.d 20runit
}

pkg_preinst() {
	if has_version 'sys-process/runit' &&
		has_version '<sys-process/runit-2.1.2' &&
		[ -d "${EROOT}"etc/runit/runsvdir/all ]; then
		if [ -e "${EROOT}"etc/sv ]; then
			mv -f "${EROOT}"etc/sv "${EROOT}"etc/sv.bak || die
			ewarn "${EROOT}etc/sv was moved to ${EROOT}etc/sv.bak"
		fi
		mv "${EROOT}"etc/runit/runsvdir/all "${EROOT}"etc/sv|| die
		ln -sf "${EROOT}"etc/sv "${EROOT}"etc/runit/runsvdir/all || die
		cp -a "${EROOT}"etc/runit/runsvdir "${T}" || die
		touch "${T}"/make_var_service || die
	fi
}

default_config() {
	local sv="${EROOT}"etc/sv
	local service="${EROOT}"etc/service
	mkdir -p "${service}" || die
	for x in tty1 tty2 tty3 tty4 tty5 tty6; do
	ln -sf "${sv}"/getty-$x "${service}"/getty-$x || die
	done
	einfo "The links to services runit will supervise are installed"
	einfo "in $service."
	einfo "If you need multiple runlevels, please see the documentation"
	einfo "for how to set them up."
	einfo
}

migrate_from_211() {
	# Create /etc/service and /var/service if requested
	if [ -e "${T}"/make_var_service ]; then
		ln -sf "${EROOT}"etc/runit/runsvdir/current "${EROOT}"etc/service || die
		ln -sf "${EROOT}"etc/runit/runsvdir/current "${EROOT}"var/service || die
	fi
	if [ -d "${T}"/runsvdir ]; then
		cp -a "${T}"/runsvdir "${EROOT}"etc/runit || die
	fi
	return 0
}

pkg_postinst() {
	if [ -z "$REPLACING_VERSIONS" ]; then
		default_config
	elif [ ! version_is_at_least 2.1.2 $REPLACING_VERSIONS ]; then
		migrate_from_211
	fi

	ewarn "To make sure sv works correctly in your currently open"
	ewarn "shells, please run the following command:"
	ewarn
	ewarn "source /etc/profile"
	ewarn

	if [ -L "${EROOT}"var/service ]; then
		ewarn "Once this version of runit is active, please remove the"
		ewarn "compatibility symbolic link at ${EROOT}var/service"
		ewarn "The correct path now is ${EROOT}etc/service"
		ewarn
	fi

	if [ -L "${EROOT}"etc/runit/runsvdir/all ]; then
		ewarn "${EROOT}etc/runit/runsvdir/all has moved to"
		iewarn "${EROOT}etc/sv."
		ewarn "Any symbolic links under ${EROOT}etc/runit/runsvdir"
		ewarn "which point to services through ../all should be updated to"
		ewarn "point to them through ${EROOT}etc/sv."
		ewarn "Once that is done, ${EROOT}etc/runit/runsvdir/all should be"
		ewarn "removed."
		ewarn
	fi
}
