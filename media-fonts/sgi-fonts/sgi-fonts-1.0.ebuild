# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm font

RPM_P="${P}-705.noarch"

DESCRIPTION="SGI fonts collection"
HOMEPAGE="http://oss.sgi.com/projects/sgi_propack"
SRC_URI="ftp://ftp.suse.com/pub/suse/i386/9.1/suse/noarch/${RPM_P}.rpm"
S="${WORKDIR}/usr/X11R6/lib/X11/fonts/misc/sgi"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~loong ~ppc ppc64 ~s390 ~sparc x86"

FONT_S="${S}"
FONT_SUFFIX="pcf.gz"
