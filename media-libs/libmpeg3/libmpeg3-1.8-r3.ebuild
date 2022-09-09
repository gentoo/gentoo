# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="An MPEG library for linux"
HOMEPAGE="http://heroinewarrior.com/libmpeg3.php"
SRC_URI="
	mirror://sourceforge/heroines/${P}-src.tar.bz2
	https://dev.gentoo.org/~soap/distfiles/${P}-patches-r0.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="cpu_flags_x86_mmx"

RDEPEND="
	media-libs/a52dec
	media-libs/libjpeg-turbo:=
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="cpu_flags_x86_mmx? ( dev-lang/nasm )"

PATCHES=(
	"${WORKDIR}"/patches/${PN}-1.7-mpeg3split.patch
	"${WORKDIR}"/patches/${PN}-1.7-textrel.patch
	"${WORKDIR}"/patches/${PN}-1.7-gnustack.patch
	"${WORKDIR}"/patches/${PN}-1.7-a52.patch
	"${WORKDIR}"/patches/${PN}-1.7-all_gcc4.patch
	"${WORKDIR}"/patches/${PN}-1.7-all_pthread.patch
	"${WORKDIR}"/patches/${P}-impldecl.patch
)

src_prepare() {
	default

	cp -rf "${WORKDIR}"/patches/1.7/. . || die
	eautoreconf
}

src_configure() {
	# disabling css since it's a fake one.
	# One can find in the sources this message :
	#   Stubs for deCSS which can't be distributed in source form
	econf \
		$(use_enable cpu_flags_x86_mmx mmx) \
		--disable-css
}

src_install() {
	HTML_DOCS=( docs/. )

	default

	# This is a workaround, it wants to rebuild
	# everything if the headers have changed
	# So we patch them after install...
	cd "${ED}"/usr/include/libmpeg3 || die
	# This patch patches the .h files that get installed into /usr/include
	# to show the correct include syntax '<>' instead of '""'  This patch
	# was also generated using info from SF's src.rpm
	eapply "${WORKDIR}"/patches/gentoo-p2.patch

	find "${ED}" -name '*.la' -delete || die
}
