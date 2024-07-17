# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 99999999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/r/config.git"

	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	S="${WORKDIR}"
fi

DESCRIPTION="Updated config.sub and config.guess file from GNU"
HOMEPAGE="https://savannah.gnu.org/projects/config"

LICENSE="GPL-3+-with-autoconf-exception"
SLOT="0"

maint_pkg_create() {
	cd "${S}" || die

	emake ChangeLog
	local ver=$(gawk '{ gsub(/-/, "", $1); print $1; exit }' ChangeLog)
	[[ ${#ver} != 8 ]] && die "invalid version '${ver}'"

	local tar="${T}/gnuconfig-${ver}.tar.xz"
	tar -Jcf "${tar}" ./* || die "creating tar failed"
	einfo "Packaged tar now available:"
	einfo "$(du -b "${tar}")"
}

src_unpack() {
	if [[ ${PV} == 99999999 ]] ; then
		git-r3_src_unpack
		maint_pkg_create
	else
		unpack ${A}
	fi
}

src_install() {
	insinto /usr/share/${PN}
	doins config.{sub,guess}
	fperms +x /usr/share/${PN}/config.{sub,guess}
	dodoc ChangeLog
}
