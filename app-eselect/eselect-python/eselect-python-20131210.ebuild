# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Keep the EAPI low here because everything else depends on it.
# We want to make upgrading simpler.

if [[ ${PV} == "99999999" ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/${PN}.git"
else
	SRC_URI="mirror://gentoo/${P}.tar.bz2
		https://dev.gentoo.org/~floppym/dist/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
fi

DESCRIPTION="Eselect module for management of multiple Python versions"
HOMEPAGE="https://www.gentoo.org/proj/en/Python/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.3"
# Avoid autotool deps for released versions for circ dep issues.
if [[ ${PV} == "99999999" ]] ; then
	DEPEND="sys-devel/autoconf"
else
	DEPEND=""
fi

src_unpack() {
	if [[ ${PV} == "99999999" ]] ; then
		git-r3_src_unpack
		cd "${S}"
		eautoreconf
	else
		unpack ${A}
	fi
}

src_install() {
	keepdir /etc/env.d/python
	emake DESTDIR="${D}" install || die
}

pkg_postinst() {
	local ret=0
	ebegin "Running 'eselect python update'"
	eselect python update --python2 --if-unset || ret=1
	eselect python update --python3 --if-unset || ret=1
	eend ${ret}
}
