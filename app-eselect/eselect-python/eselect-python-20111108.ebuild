# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Keep the EAPI low here because everything else depends on it.
# We want to make upgrading simpler.

ESVN_PROJECT="eselect-python"
ESVN_REPO_URI="https://overlays.gentoo.org/svn/proj/python/projects/eselect-python/trunk"

if [[ ${PV} == "99999999" ]] ; then
	inherit autotools subversion
else
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
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
	unpack ${A}
	cd "${S}"
	[[ -x configure ]] || eautoreconf
}

src_install() {
	keepdir /etc/env.d/python
	emake DESTDIR="${D}" install || die
}

pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-20090804" || ! has_version "${CATEGORY}/${PN}"; then
		run_eselect_python_update="1"
	fi
}

pkg_postinst() {
	if [[ "${run_eselect_python_update}" == "1" ]]; then
		ebegin "Running \`eselect python update\`"
		eselect python update --ignore 3.0 --ignore 3.1 --ignore 3.2 > /dev/null
		eend "$?"
	fi
}
