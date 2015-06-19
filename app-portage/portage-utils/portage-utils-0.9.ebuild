# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/portage-utils/portage-utils-0.9.ebuild,v 1.4 2015/02/21 15:47:17 mgorny Exp $

EAPI="3"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="small and fast portage helper tools written in C"
HOMEPAGE="https://wiki.gentoo.org/wiki/Q_applets"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~ppc-aix ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static"

src_configure() {
	use static && append-ldflags -static

	# Avoid slow configure+gnulib+make if on an up-to-date Linux system
	if use prefix || ! use kernel_linux || \
	   has_version '<sys-libs/glibc-2.10'
	then
		econf --with-eprefix="${EPREFIX}"
	else
		tc-export CC
	fi
}

src_install() {
	emake install DESTDIR="${D}" || die
	prepalldocs

	exeinto /etc/portage/bin
	doexe "${FILESDIR}"/post_sync || die
	insinto /etc/portage/postsync.d
	doins "${FILESDIR}"/q-reinitialize || die

	# Portage fixes shebangs, we just need to fix the paths in the files
	sed -i \
		-e "s:\(/etc/portage/postsync.d\|/usr/bin/q\):${EPREFIX}&:g" \
		"${ED}"/etc/portage/bin/post_sync \
		"${ED}"/etc/portage/postsync.d/q-reinitialize || die
}

pkg_preinst() {
	# preserve +x bit on postsync files #301721
	local x
	pushd "${ED}" >/dev/null
	for x in etc/portage/postsync.d/* ; do
		[[ -x ${EROOT}/${x} ]] && chmod +x "${x}"
	done
}

pkg_postinst() {
	elog "${EPREFIX}/etc/portage/postsync.d/q-reinitialize has been installed for convenience"
	elog "If you wish for it to be automatically run at the end of every --sync:"
	elog "   # chmod +x ${EPREFIX}/etc/portage/postsync.d/q-reinitialize"
	elog "Normally this should only take a few seconds to run but file systems"
	elog "such as ext3 can take a lot longer.  To disable, simply do:"
	elog "   # chmod -x ${EPREFIX}/etc/portage/postsync.d/q-reinitialize"
}
