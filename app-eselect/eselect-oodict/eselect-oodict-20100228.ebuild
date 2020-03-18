# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Manages configuration of dictionaries for OpenOffice.Org"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

SRC_URI="mirror://gentoo/oodict.eselect-${PVR}.bz2"

S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}"/oodict.eselect-${PVR} oodict.eselect
}
