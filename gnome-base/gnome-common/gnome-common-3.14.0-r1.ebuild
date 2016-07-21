# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit gnome.org

DESCRIPTION="Common files for development of Gnome packages"
HOMEPAGE="https://git.gnome.org/browse/gnome-common"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+autoconf-archive"

RDEPEND="autoconf-archive? ( >=sys-devel/autoconf-archive-2015.02.04 )
	!autoconf-archive? ( !>=sys-devel/autoconf-archive-2015.02.04 )
"
DEPEND=""

src_install() {
	default
	if use autoconf-archive; then
		# do not install macros owned by autoconf-archive, bug #540138
		rm "${ED}"/usr/share/aclocal/ax_{check_enable_debug,code_coverage}.m4 || die "removing macros failed"
	fi
	mv doc-build/README README.doc-build || die "renaming doc-build/README failed"
	dodoc ChangeLog README*
}
