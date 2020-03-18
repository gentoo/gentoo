# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

if [[ ${PV} == "99999999" ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/r/config.git"

	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~whissi/dist/${PN}/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
	S="${WORKDIR}"
fi

DESCRIPTION="Updated config.sub and config.guess file from GNU"
HOMEPAGE="https://savannah.gnu.org/projects/config"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

maint_pkg_create() {
	cd "${S}"

	local ver=$(gawk '{ gsub(/-/, "", $1); print $1; exit }' ChangeLog)
	[[ ${#ver} != 8 ]] && die "invalid version '${ver}'"

	cp "${FILESDIR}"/${PV}/*.patch . || die

	local tar="${T}/gnuconfig-${ver}.tar.bz2"
	tar -jcf "${tar}" ./* || die "creating tar failed"
	einfo "Packaged tar now available:"
	einfo "$(du -b "${tar}")"
}

src_unpack() {
	if [[ ${PV} == "99999999" ]] ; then
		git-r3_src_unpack
		maint_pkg_create
	else
		unpack ${A}
	fi
}

src_prepare() {
	default
	eapply "${S}"/*.patch
	use elibc_uclibc && sed -i 's:linux-gnu:linux-uclibc:' testsuite/config-guess.data #180637
}

src_compile() { :;}

src_test() {
	emake check
}

src_install() {
	insinto /usr/share/${PN}
	doins config.{sub,guess}
	fperms +x /usr/share/${PN}/config.{sub,guess}
	dodoc ChangeLog
}
