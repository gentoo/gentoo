# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Software audio sampler engine with professional grade features"
HOMEPAGE="https://www.linuxsampler.org/"
SRC_URI="https://download.linuxsampler.org/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="alsa doc jack lv2 sf2 sqlite"
REQUIRED_USE="|| ( alsa jack )"

RDEPEND="
	>=media-libs/libgig-4.2.0
	media-libs/libsndfile[-minimal]
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	lv2? ( media-libs/lv2 )
	sqlite? ( >=dev-db/sqlite-3.3 )
"
DEPEND="${RDEPEND}
	media-libs/dssi
	media-libs/ladspa-sdk
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.0-nptl-hardened.patch"
	"${FILESDIR}/${PN}-2.0.0-lv2-automagic.patch"
)

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	default
	# Force regeneration of the file to let it build with all bison
	# versions, bug #556204
	rm src/network/lscpparser.cpp || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-arts-driver
		--disable-static
		$(use_enable alsa alsa-driver)
		$(use_enable jack jack-driver)
		$(use_enable lv2)
		$(use_enable sqlite instruments-db)
		$(use_enable sf2 sf2-engine)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake
	use doc && emake docs
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )
	default
	find "${D}" -name '*.la' -delete || die

	# lscp files conflict with nilfs-utils, bug #556330
	mv "${D}/usr/bin/lscp" "${D}/usr/bin/lscp-${PN}" || die
	mv "${D}/usr/share/man/man1/lscp.1" "${D}/usr/share/man/man1/lscp-${PN}.1" || die
}
