# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools subversion

DESCRIPTION="Software audio sampler engine with professional grade features"
HOMEPAGE="https://www.linuxsampler.org/"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/linuxsampler/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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

	emake -f Makefile.svn

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
