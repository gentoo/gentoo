# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="collection of Gentoo eclass manpages"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE=""

DEPEND="app-arch/xz-utils"

# How to create a snapshot and upload it to your dev-space:
#
# mkdir eclass-manpages-$(date +%Y%m%d)
# cp "$(portageq get_repo_path / gentoo)"/eclass/*.eclass eclass-manpages-$(date +%Y%m%d)/
# tar -cf eclass-manpages-$(date +%Y%m%d).tar eclass-manpages-$(date +%Y%m%d)
# xz -9e eclass-manpages-$(date +%Y%m%d).tar
# scp eclass-manpages-$(date +%Y%m%d).tar.xz dev.gentoo.org:public_html/dist/
#
# Then copy the ebuild and update your name in SRC_URI ;-).

src_compile() {
	env ECLASSDIR="${S}" bash "${FILESDIR}"/eclass-to-manpage.sh || die
}

src_install() {
	doman *.5
}
