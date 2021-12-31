# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm font

RESTRICT="mirror strip binchecks"

RPM_V=1.0

DESCRIPTION="Hong Kong Official Reference Chinese Font that implements ISO10646 & HKSCS-2001"
HOMEPAGE="http://www.ogcio.gov.hk/en/business/tech_promotion/ccli/hkscs/"
SRC_URI="http://www.ogcio.gov.hk/en/business/tech_promotion/ccli/terms/doc/mandrake_setup.bin"

LICENSE="HKSCS-2001"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ia64 ppc s390 sh sparc x86"
IUSE=""

DEPEND=""

S=${WORKDIR}
FONT_S="${S}/usr/share/inputmethod"
FONT_SUFFIX="ttf"

src_unpack() {
	# complicated and convoluted unpack procedure
	local linenumber=237
	cd "${S}"; tail -n +${linenumber} "${DISTDIR}/${A}" | tar zxvf - || die "unpack failed"

	# then we rpm_unpack the fonts package
	rpm_unpack "${S}/package_mdk/imfont-${RPM_V}-0.i386.rpm"
}

src_compile() { :; }

pkg_postinst() {
	elog "The font name installed is 'Ming(for ISO10646)'. To add make it"
	elog "the default Chinese font, you should add entries to your"
	elog "/etc/fonts/local.conf similar to:"
	elog
	elog "<alias>"
	elog "	   <family>Luxi Sans</family>"
	elog "	   <family>Bitstream Vera Sans</family>"
	elog "	   <family>Ming(for ISO10646)</family>"
	elog "	   <default><family>sans-serif</family></default>"
	elog "</alias>"
	elog
}
