# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit readme.gentoo versionator

MY_PV=$(replace_all_version_separators "-")
DESCRIPTION="A set of font rendering and replacement rules for fontconfig-infinality"
HOMEPAGE="http://bohoomil.com/"
SRC_URI="https://github.com/bohoomil/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-eselect/eselect-infinality
	app-eselect/eselect-lcdfilter
	media-libs/fontconfig-infinality
	media-libs/freetype:2[infinality]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${MY_PV}

DISABLE_AUTOFORMATTING="1"
DOC_CONTENTS="1. Disable all rules but 52-infinality.conf using eselect fontconfig
2. Enable one of the \"ultimate\" presets using eselect infinality
3. Select ultimate lcdfilter settings using eselect lcdfilter"

BLACKLIST="43-wqy-zenhei-sharp.conf"

src_prepare() {
	pushd fontconfig_patches/fonts-settings || die
	rm ${BLACKLIST} || die
	popd

	# Generate lcdfilter config
	echo -e "################# FONTCONFIG ULTIMATE STYLE #################\n" \
	> "${T}"/ultimate || die

	local infinality_style
	infinality_style=$(sed --quiet \
		-e 's/^USE_STYLE="*\([1-9]\)"*/\1/p' \
		freetype/infinality-settings.sh) || die

	if ! [ -n "$infinality_style" ]; then
		ewarn "Missing USE_STYLE variable in package source."
		infinality_style=1
	fi

	sed --quiet \
		-e '/INFINALITY_FT_FILTER_PARAMS=/p' \
		freetype/infinality-settings.sh \
	| sed --quiet \
		-e "${infinality_style} s/[ \t]*export[ \t]*//p" \
	>> "${T}"/ultimate
	assert

	sed --quiet \
		-e '/INFINALITY_FT_FILTER_PARAMS/ d' \
		-e 's/^[ \t]*export[ \t]*INFINALITY_FT/INFINALITY_FT/p' \
		freetype/infinality-settings.sh \
	>> "${T}"/ultimate || die
}

src_install() {
	insinto /etc/fonts/infinality/conf.src.ultimate
	doins conf.d.infinality/*.conf
	doins fontconfig_patches/{ms,free,combi}/*.conf

	# Cut a list of default .conf files out of Makefile.am
	local default_configs config fonts_settings
	default_configs=$(sed --quiet \
		-e ':again' \
		-e '/\\$/ N' \
		-e 's/\\\n/ /' \
		-e 't again' \
		-e 's/^CONF_LINKS =//p' \
		conf.d.infinality/Makefile.am) || die

	# Install per-font settings
	pushd fontconfig_patches/fonts-settings || die
	doins *.conf
	fonts_settings=$(echo *.conf)
	popd

	# Install font presets
	pushd fontconfig_patches/ms || die
	for config in ${default_configs} ${fonts_settings} *.conf; do
		dosym ../../conf.src.ultimate/"${config}" \
			/etc/fonts/infinality/styles.conf.avail/ultimate-ms/"${config}"
	done
	popd
	pushd fontconfig_patches/free || die
	for config in ${default_configs} ${fonts_settings} *.conf; do
		dosym ../../conf.src.ultimate/"${config}" \
			/etc/fonts/infinality/styles.conf.avail/ultimate-free/"${config}"
	done
	popd
	pushd fontconfig_patches/combi || die
	for config in ${default_configs} ${fonts_settings} *.conf; do
		dosym ../../conf.src.ultimate/"${config}" \
			/etc/fonts/infinality/styles.conf.avail/ultimate-combi/"${config}"
	done
	popd

	insinto /usr/share/eselect-lcdfilter/env.d
	doins "${T}"/ultimate

	readme.gentoo_create_doc
}
