# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

MY_P="${P/6/5}"

DESCRIPTION="A Fast CJK (Chinese/Japanese/Korean) Console Environment"
HOMEPAGE="http://zhcon.sourceforge.net/"
SRC_URI="mirror://sourceforge/zhcon/${MY_P}.tar.gz
		mirror://sourceforge/zhcon/zhcon-0.2.5-to-0.2.6.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ggi gpm"

DEPEND="ggi? ( media-libs/libggi[X] )
	gpm? ( sys-libs/gpm )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}.sysconfdir.patch
	"${FILESDIR}"/${P}.configure.in.patch
	"${FILESDIR}"/${P}+gcc-4.3.patch
	"${FILESDIR}"/${P}+linux-headers-2.6.26.patch
	"${FILESDIR}"/${P}-curses.patch
	"${FILESDIR}"/${P}-amd64.patch
	"${FILESDIR}"/${P}-automagic-fix.patch
	"${FILESDIR}"/${P}.make-fix.patch
)

src_prepare() {
	eapply "${WORKDIR}"/zhcon-0.2.5-to-0.2.6.diff
	default
	for f in $(grep -lir HAVE_GGI_LIB *); do
		sed -i -e "s/HAVE_GGI_LIB/HAVE_LIBGGI/" "${f}" || die "sed failed"
	done
	# Required for newer automake
	touch config.rpath || die
	eautoreconf
}

src_configure() {
	econf $(use_with ggi) \
		$(use_with gpm)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog README NEWS TODO THANKS
	dodoc README.BSD README.gpm README.utf8
}
