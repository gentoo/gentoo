# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="SELinux policy compiler"
HOMEPAGE="http://userspace.selinuxproject.org"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="https://github.com/SELinuxProject/selinux/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

DEPEND=">=sys-libs/libsepol-${PV}"
BDEPEND="sys-devel/flex
	sys-devel/bison"

RDEPEND=">=sys-libs/libsepol-${PV}"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		YACC="bison -y" \
		LIBDIR="\$(PREFIX)/$(get_libdir)"
}

src_install() {
	default

	if use debug; then
		dobin "${S}/test/dismod"
		dobin "${S}/test/dispol"
	fi
}

pkg_postinst() {
	if ! tc-is-cross-compiler; then
		einfo "This checkpolicy can compile version `checkpolicy -V | cut -f 1 -d ' '` policy."
	fi
}
