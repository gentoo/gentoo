# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

DESCRIPTION="Subversion output colorizer"
HOMEPAGE="http://colorsvn.tigris.org"
SRC_URI="http://www.console-colors.de/downloads/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="dev-lang/perl
	dev-vcs/subversion"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/0001-Don-t-colorize-svn-mkdir-bug-321451.-Use-IPC-open2-i.patch"
)

src_prepare() {
	default
	# rxvt-unicode isn't listed by default :)
	sed -i -e 's:rxvt:rxvt rxvt-unicode:' colorsvnrc-original || die
	# Fix confdir location for Prefix, #435434
	sed -i \
		-e '/^confdir/d' \
		-e 's/$(confdir)/$(sysconfdir)/g' \
		Makefile.in || die
}

src_compile() {
	# bug 335134
	emake -j1 || die
}

pkg_postinst() {
	elog
	elog "The default settings are stored in /etc/colorsvnrc."
	elog "They can be locally overridden by ~/.colorsvnrc."
	elog "An alias to colorsvn was installed for the svn command."
	elog "In order to immediately activate it do:"
	elog "\tsource /etc/profile"
	elog "NOTE: If you don't see colors,"
	elog "append the output of 'echo \$TERM' to 'colortty' in your colorsvnrc."
	elog
}
