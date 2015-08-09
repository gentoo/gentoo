# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils multilib libtool

MY_P=${P/-prefix/}  # just use "upstream" sources
EINFO=einfo-1.0.6
DESCRIPTION="Minimal baselayout and e-functions for Gentoo Prefix installs"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2
	http://dev.gentoo.org/~vapier/dist/${MY_P}.tar.bz2
	http://dev.gentoo.org/~redlizard/distfiles/${EINFO}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~arm-linux ~ppc-aix ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="build kernel_linux"

S=${WORKDIR}/${EINFO}

pkg_preinst() {
	# This is written in src_install (so it's in CONTENTS), but punt all
	# pending updates to avoid user having to do etc-update (and make the
	# pkg_postinst logic simpler).
	rm -f "${EROOT}"/etc/._cfg????_gentoo-release
}

src_prepare() {
	# exotic platforms still aren't fixed in upstream libtool
	elibtoolize
}

src_configure() {
	econf --libexecdir="${EPREFIX}/usr/lib/einfo"
}

src_install() {
	emake DESTDIR="${D}" install || die

	# make functions.sh available in /etc/init.d
	# Note: we cannot replace the symlink with a file here, or Portage will
	# config-protect it, and etc-update can't handle symlink to file updates
	dodir etc/init.d
	dosym ../../usr/lib/einfo/sh/functions.sh /etc/init.d/functions.sh

	pushd "${WORKDIR}"/${MY_P} > /dev/null || die
	dodir etc
	sed \
		-e "/PATH=/!s:/\(etc\|usr/bin\|bin\):\"${EPREFIX}\"/\1:g" \
		-e "/PATH=/s|\([:\"]\)/|\1${EPREFIX}/|g" \
		-e "/PATH=.*\/sbin/s|\"$|:/usr/sbin:/sbin\"|" \
		-e "/PATH=.*\/bin/s|\"$|:/usr/bin:/bin\"|" \
		etc/profile > "${ED}"/etc/profile || die
	dodir etc/env.d
	sed \
		-e "s:/\(etc/env.d\|opt\|usr\):${EPREFIX}/\1:g" \
		-e "/^PATH=/s|\"$|:${EPREFIX}/usr/sbin:${EPREFIX}/sbin\"|" \
		etc/env.d/00basic > "${ED}"/etc/env.d/00basic || die
	dodoc ChangeLog.svn
	popd > /dev/null

	# add the host OS MANPATH
	if [[ -d "${ROOT}"/usr/share/man ]] ; then
		echo 'MANPATH="/usr/share/man"' > "${ED}"/etc/env.d/99basic || die
	fi

	# rc-scripts version for testing of features that *should* be present
	echo "Gentoo Prefix Base System release ${PV}" > "${ED}"/etc/gentoo-release

	# FHS compatibility symlinks stuff
	dosym /var/tmp /usr/tmp

	# add a dummy to avoid Portage shebang errors
	dodir sbin
	cat > "${ED}"/sbin/runscript <<- EOF
		#!/bin/sh

		echo "runscript not supported by Gentoo Prefix Base System release ${PV}" 1>&2
		exit 1
	EOF
	chmod 755 "${ED}"/sbin/runscript || die
}

pkg_postinst() {
	# Take care of the etc-update for the user
	if [ -e "${EROOT}"/etc/._cfg0000_gentoo-release ] ; then
		mv "${EROOT}"/etc/._cfg0000_gentoo-release "${EROOT}"/etc/gentoo-release
	fi

	# baselayout leaves behind a lot of .keep files, so let's clean them up
	find "${EROOT}"/lib/rcscripts/ -name .keep -exec rm -f {} + 2>/dev/null
	find "${EROOT}"/lib/rcscripts/ -depth -type d -exec rmdir {} + 2>/dev/null
}
