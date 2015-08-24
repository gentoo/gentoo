# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

MY_P="${P/_/-}"
DESCRIPTION="Tools to deal with shar archives"
HOMEPAGE="https://www.gnu.org/software/sharutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="nls"

DEPEND="app-arch/xz-utils
	sys-apps/texinfo
	nls? ( >=sys-devel/gettext-0.10.35 )"

S=${WORKDIR}/${MY_P}

src_configure() {
	strip-linguas -u po
	econf $(use_enable nls)
}
