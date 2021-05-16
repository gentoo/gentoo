# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="A set of tools for DVD+RW/-RW drives"
HOMEPAGE="http://fy.chalmers.se/~appro/linux/DVD+RW/"
SRC_URI="http://fy.chalmers.se/~appro/linux/DVD+RW/tools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="app-cdr/cdrtools"
DEPEND="${RDEPEND}
	sys-devel/m4"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0-sysmacros.patch
	"${FILESDIR}"/${PN}-7.0-wctomb-r1.patch
	"${FILESDIR}"/${PN}-7.0-glibc2.6.90.patch
	"${FILESDIR}"/${PN}-7.0-dvddl-r1.patch
	"${FILESDIR}"/${PN}-7.0-wexit.patch
	"${FILESDIR}"/${PN}-7.0-reload.patch
	"${FILESDIR}"/${PN}-7.1-noevent.patch
	"${FILESDIR}"/${PN}-7.1-lastshort.patch
	"${FILESDIR}"/${PN}-7.1-bluray_srm+pow.patch
	"${FILESDIR}"/${PN}-7.1-bluray_pow_freespace.patch
	"${FILESDIR}"/${PN}-7.1-clang.patch
)

# this is a text file, not html
DOCS=( index.html )

src_prepare() {
	# Linux compiler flags only include -O2 and are incremental.
	sed -i '/FLAGS/s:-O2::' Makefile.m4 || die "failed to sed out FLAGS"
	default
}

src_compile() {
	emake SHELL="${EPREFIX}"/bin/bash CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}

src_install() {
	emake SHELL="${EPREFIX}"/bin/bash prefix="${ED}/usr" install
	einstalldocs
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog 'If you receive an error, "unable to anonymously mmap...'
		elog 'Resource temporarily unavailable" when running growisofs,'
		elog 'then you may need to run "ulimit -l unlimited".'
	fi
}
