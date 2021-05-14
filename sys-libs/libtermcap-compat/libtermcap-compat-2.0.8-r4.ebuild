# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# We only want this for binary-only packages, so we will only be installing
# the lib used at runtime; no headers and no files to link against

EAPI=7

inherit toolchain-funcs multilib-minimal

PATCHVER="2"

MY_P="termcap-${PV}"
DESCRIPTION="Compatibility package for old termcap-based programs"
HOMEPAGE="http://www.catb.org/~esr/terminfo/"
SRC_URI="http://www.catb.org/~esr/terminfo/termtypes.tc.gz
	mirror://gentoo/${MY_P}.tar.bz2
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${MY_P}-patches-${PATCHVER}.tar.xz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2 LGPL-2 BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ppc sparc x86"

PATCHES=(
	# Gentoo patchset
	"${WORKDIR}"/patch/002_all_termcap-setuid.patch
	"${WORKDIR}"/patch/003_all_termcap-inst-no-root.patch
	"${WORKDIR}"/patch/004_all_termcap-compat-glibc21.patch
	"${WORKDIR}"/patch/005_all_termcap-xref.patch
	"${WORKDIR}"/patch/006_all_termcap-fix-tc.patch
	"${WORKDIR}"/patch/007_all_termcap-ignore-p.patch
	"${WORKDIR}"/patch/008_all_termcap-buffer.patch
	"${WORKDIR}"/patch/009_all_termcap-bufsize--needs-011.patch
	"${WORKDIR}"/patch/010_all_termcap-colon.patch
	"${WORKDIR}"/patch/011_all_termcap-AAARGH.patch
	"${WORKDIR}"/patch/012_all_libtermcap-compat-2.0.8-fPIC.patch
	"${WORKDIR}"/patch/013_all_libtermcap-compat_bcopy_fix.patch
	"${WORKDIR}"/patch/014_all_libtermcap-build-settings.patch
	"${WORKDIR}"/patch/015_all_libtermcap-only-shared-lib.patch
	# termcap
	"${WORKDIR}"/patch/tc.file/001_all_termcap-linuxlat.patch
	"${WORKDIR}"/patch/tc.file/002_all_termcap-xtermchanges.patch
	"${WORKDIR}"/patch/tc.file/003_all_termcap-utf8.patch
	"${WORKDIR}"/patch/tc.file/004_all_termcap-xterm-X11R6.patch
	"${WORKDIR}"/patch/tc.file/005_all_termcap-Eterm.patch
)

src_prepare() {
	mv "${WORKDIR}"/termtypes.tc "${S}"/termcap || die

	default

	multilib_copy_sources
}

src_configure() {
	tc-export CC
}

multilib_src_install() {
	dolib.so libtermcap.so.${PV}
	dosym libtermcap.so.${PV} /usr/$(get_libdir)/libtermcap.so.2
}

multilib_src_install_all() {
	insinto /etc
	doins "${S}"/termcap

	dodoc ChangeLog README
}
