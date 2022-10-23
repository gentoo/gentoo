# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Tiny program like wget, to upload files/whole directories via FTP"
HOMEPAGE="http://wput.sourceforge.net/"

if [[ ${PV} == *_p* ]] ; then
	MY_PV=$(ver_cut 1-3)
	SRC_URI=" mirror://debian/pool/main/w/wput/wput_${MY_PV}+git$(ver_cut 5).orig.tar.bz2"
	SRC_URI+=" mirror://debian/pool/main/w/wput/wput_${MY_PV}+git$(ver_cut 5)-$(ver_cut 7).debian.tar.xz"
	S="${WORKDIR}"/${PN}-${MY_PV}+git$(ver_cut 5)
else
	SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_PV}.tgz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="debug ssl"

RDEPEND="ssl? ( net-libs/gnutls:= )"
DEPEND="${RDEPEND}"
# Debian's patches to fix spelling means need gettext to regenerate
# It's so common that it's not really worth the 'touch' dance to avoid it
# or conditional patching.
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.2_p20130413_p11-xopen_source-strdup.patch
	"${FILESDIR}"/${PN}-0.6.2_p20130413_p11-no-compress-manpages.patch
)

src_prepare() {
	eapply $(sed -e "s:^:${WORKDIR}/debian/patches/:" "${WORKDIR}"/debian/patches/series)
	default

	eautoreconf
}

src_configure() {
	local myconf=(
		--enable-g-switch=no
		--enable-nls

		$(usev debug '--enable-memdbg=yes')
		$(use_with ssl)
	)

	econf "${myconf[@]}"
}
