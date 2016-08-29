# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# At some point URW++ released fonts under GPL license. After that they were took
# and improved by Valek Filippov and this work was somehow related with AFPL...
# At least it can be found on their svn server:
# http://svn.ghostscript.com/ghostscript/trunk/urw-fonts/

# Also, some time ago, sources where published on sf.net:
# https://sourceforge.net/projects/gs-fonts/files/
# At this point this package was published on a nuber of other sites
# (gimp.org/cups.org) and media-fonts/gnu-gs-fonts-std was added to the tree.
# But nobody use that old releases any mover and everybody syncs with
# svn.ghostscript.com. The most recent tag there is:
# http://svn.ghostscript.com/ghostscript/tags/urw-fonts-1.0.7pre44/

# But note that version we have is different from upstream tag. This happened
# because we started to use redhat versions and followed their versioning. It's
# hard to say why they use such strange version since they also sync with
# svn.ghostscript.com. Redhat's ChangeLog states:
# Tue Jan 8 23:00:00 2008 Than Ngo 2.4-2
#  - update to 1.0.7pre44

inherit eutils rpm font versionator

MY_PV=$(replace_version_separator 2 -)

DESCRIPTION="free good quality fonts gpl'd by URW++"
HOMEPAGE="http://www.urwpp.de/"
SRC_URI="mirror://gentoo/${PN}-${MY_PV}.fc13.src.rpm"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x64-solaris ~x86-solaris"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="${DEPEND}
	!media-fonts/gnu-gs-fonts-std
	!media-fonts/gnu-gs-fonts-other"

S=${WORKDIR}
FONT_S=${S}
FONT_SUFFIX="afm pfb pfm"
DOCS="ChangeLog README*"

pkg_postinst() {
	font_pkg_postinst
	elog "If you upgraded from ${PN}-2.1-r2 some fonts will look a bit"
	elog "different. Take a look at bug #208990 if interested."
}
