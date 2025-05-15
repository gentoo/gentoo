# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="https://smarden.org/runit/"
PATCH_VER=20240905
SRC_URI="
	https://smarden.org/runit/${P}.tar.gz
"
S=${WORKDIR}/admin/${P}/src

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="+scripts split-usr static"

src_prepare() {
	default

	cd "${S}" || die

	# We either build everything or nothing static
	sed -i -e 's:-static: :' Makefile || die

	# see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=726008
	[[ ${COMPILER} == "diet" ]] &&
		use ppc &&
		filter-flags "-mpowerpc-gpopt"
}

src_configure() {
	use static && append-ldflags -static

	append-flags -std=gnu17  # XXX https://bugs.gentoo.org/946137, workaround for gcc15
	echo "$(tc-getCC) ${CFLAGS}"  > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
	sed -i -e "s:ar cr:$(tc-getAR) cr:" print-ar.sh || die
	sed -i -e "s:ranlib :$(tc-getRANLIB) :" print-ar.sh || die
}

src_install() {
	dobin $(<../package/commands)
	dodir /sbin
	mv "${ED}"/usr/bin/{runit-init,runit,utmpset} "${ED}"/sbin/ || die "dosbin"
	if use split-usr ; then
		dosym ../etc/runit/2 /sbin/runsvdir-start
	else
		dosym ../../etc/runit/2 /sbin/runsvdir-start
	fi

	DOCS=( ../package/{CHANGES,README,THANKS} )
	HTML_DOCS=( ../doc/*.html )
	einstalldocs
	doman ../man/*.[18]

	if use scripts ; then
		exeinto /etc/runit
		doexe "${FILESDIR}"/ctrlaltdel
		newexe "${FILESDIR}"/1-r2 1
		newexe "${FILESDIR}"/2-r1 2
		newexe "${FILESDIR}"/3-r2 3
		doexe "${FILESDIR}"/rc.sh
		insinto /etc/runit/rc
		doins "${FILESDIR}"/1.openrc.example
		doins "${FILESDIR}"/3.openrc.example
	fi

	dodir /etc/sv
	for tty in tty1 tty2 tty3 tty4 tty5 tty6; do
		exeinto /etc/sv/getty-$tty/
		newexe "${FILESDIR}"/finish.getty finish
		newexe "${FILESDIR}"/run.getty run
		for script in finish run; do
			sed -i -e "s:TTY:${tty}:g" "${ED}"/etc/sv/getty-$tty/$script
		done
	done

	# make sv command work
	newenvd - 20runit <<- EOF
		#/etc/env.d/20runit
		SVDIR="/etc/service/"
	EOF
}

default_config() {
	local sv="${EROOT}"/etc/sv
	local service="${EROOT}"/etc/service
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
	if [[ -e "${T}"/make_var_service ]]; then
		ln -sf "${EROOT}"/etc/runit/runsvdir/current "${EROOT}"/etc/service || die
		ln -sf "${EROOT}"/etc/runit/runsvdir/current "${EROOT}"/var/service || die
	fi
	if [[ -d "${T}"/runsvdir ]]; then
		cp -a "${T}"/runsvdir "${EROOT}"/etc/runit || die
	fi
	return 0
}

pkg_preinst() {
	if  has_version '<sys-process/runit-2.1.2'; then
		pre_212=yes
	fi
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		default_config
	elif [[ -n ${pre_212} ]]; then
		migrate_from_211
	fi

	ewarn "To make sure sv works correctly in your currently open"
	ewarn "shells, please run the following command:"
	ewarn
	ewarn "source /etc/profile"
	ewarn

	if use scripts; then
		ewarn "Currently, no task(s) will run in stage 1 & 3, you're on your own"
		ewarn "to put script(s) into /etc/runit/rc/, please see /etc/runit/rc.sh"
		ewarn "for name in different stages."
		ewarn
	else
		ewarn "This build with USE=\"-scripts\" doesn\'t include any boot scripts"
		ewarn "into /etc/runit, you are on your own to put the scripts."
		ewarn "Also, /sbin/runsvdir-start is a broken symlink to /etc/runit/2, you will"
		ewarn "need to create script /etc/runit/2 before use it."
		ewarn
	fi

	if [[ -L "${EROOT}"/var/service ]]; then
		ewarn "Once this version of runit is active, please remove the"
		ewarn "compatibility symbolic link at ${EROOT}/var/service"
		ewarn "The correct path now is ${EROOT}/etc/service"
		ewarn
	fi

	if [[ -L "${EROOT}"/etc/runit/runsvdir/all ]]; then
		ewarn "${EROOT}/etc/runit/runsvdir/all has moved to"
		ewarn "${EROOT}/etc/sv."
		ewarn "Any symbolic links under ${EROOT}/etc/runit/runsvdir"
		ewarn "which point to services through ../all should be updated to"
		ewarn "point to them through ${EROOT}/etc/sv."
		ewarn "Once that is done, ${EROOT}/etc/runit/runsvdir/all should be"
		ewarn "removed."
		ewarn
	fi
}
