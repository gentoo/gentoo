# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C-language BLAS module for eselect"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

# Need skel.bash lib
RDEPEND=">=app-admin/eselect-1.0.5"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}"/cblas.eselect-${PVR} cblas.eselect
	doman "${FILESDIR}"/cblas.eselect.5
}
