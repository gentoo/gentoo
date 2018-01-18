# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/autoconf.git"
	inherit git-r3
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.xz
		ftp://alpha.gnu.org/pub/gnu/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
fi

inherit toolchain-autoconf

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"

LICENSE="GPL-3"
SLOT="${PV}"
IUSE="emacs"

DEPEND=">=sys-devel/m4-1.4.16
	>=dev-lang/perl-5.6"
RDEPEND="${DEPEND}
	!~sys-devel/${P}:2.5
	>=sys-devel/autoconf-wrapper-13"
[[ ${PV} == "9999" ]] && DEPEND+=" >=sys-apps/texinfo-4.3"
PDEPEND="emacs? ( app-emacs/autoconf-mode )"

src_prepare() {
	# Avoid the "dirty" suffix in the git version by generating it
	# before we run later stages which might modify source files.
	local ver=$(./build-aux/git-version-gen .tarball-version)
	echo "${ver}" > .tarball-version || die

	autoreconf -f -i || die

	toolchain-autoconf_src_prepare
}
