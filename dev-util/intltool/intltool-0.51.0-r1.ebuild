# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Internationalization Tool Collection"
HOMEPAGE="https://launchpad.net/intltool/"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="
	>=dev-lang/perl-5.8.1
	dev-perl/XML-Parser
"
RDEPEND="${DEPEND}
	sys-devel/gettext
"
DOCS=( AUTHORS ChangeLog NEWS README TODO doc/I18N-HOWTO )

src_prepare() {
	# Fix handling absolute paths in single file key output, bug #470040
	# https://bugs.launchpad.net/intltool/+bug/1168941
	epatch "${FILESDIR}/${PN}-0.50.2-absolute-paths.patch"
	epatch "${FILESDIR}"/${PN}-0.51.0-perl-5.22.patch
}
