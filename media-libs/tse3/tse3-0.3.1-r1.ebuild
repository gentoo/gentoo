# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic

DESCRIPTION="TSE3 Sequencer library"
HOMEPAGE="http://TSE3.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${P}-awe_voice.h.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="alsa oss"

RDEPEND="alsa? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.2.7-size_t-64bit.patch"
	"${FILESDIR}/${PN}-0.2.7-gcc4.patch"
	"${FILESDIR}/${P}-parallelmake.patch"
	"${FILESDIR}/${P}+gcc-4.3.patch"
)

src_prepare() {
	default
	mv configure.in configure.ac || die "Moving configure.in -> .ac failed"
	if use oss; then
		cp "${WORKDIR}"/awe_voice.h src/ || die "copy failed"
		append-cppflags -DHAVE_AWE_VOICE_H
	fi

	eautoreconf
}

src_configure() {
	local myconf

	use alsa || myconf="${myconf} --without-alsa"
	use oss || myconf="${myconf} --without-oss"

	econf \
		--without-doc-install \
		--without-aRts \
		${myconf}
}

src_install() {
	HTML_DOCS=( doc/*.{html,gif,png} )
	default
	dodoc doc/History
}
