# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manages configuration of TiMidity++ patchsets"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/timidity.eselect-${PV}.bz2"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86"

RDEPEND=">=app-admin/eselect-1.2.3"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/timidity.eselect-${PV}" timidity.eselect
}
