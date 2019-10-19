# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm font

RPM_P="${P}-705.noarch"

DESCRIPTION="SGI fonts collection"
HOMEPAGE="http://oss.sgi.com/projects/sgi_propack"
SRC_URI="ftp://ftp.suse.com/pub/suse/i386/9.1/suse/noarch/${RPM_P}.rpm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~ppc ppc64 s390 sh sparc x86"

S="${WORKDIR}/usr/X11R6/lib/X11/fonts/misc/sgi"

FONT_S="${S}"
FONT_SUFFIX="pcf.gz"
