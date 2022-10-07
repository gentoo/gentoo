# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )

inherit font python-any-r1

DESCRIPTION="Google Noto Emoji fonts"
HOMEPAGE="https://www.google.com/get/noto/ https://github.com/googlefonts/noto-emoji"

COMMIT="e8073ab740292f8d5f19b5de144087ac58044d06"
SRC_URI="https://github.com/googlefonts/noto-emoji/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="buildfont"

BDEPEND="
	buildfont? (
		${PYTHON_DEPS}
		app-arch/zopfli
		$(python_gen_any_dep '
			>=dev-python/fonttools-4.7.0[${PYTHON_USEDEP}]
			>=dev-python/nototools-0.2.13[${PYTHON_USEDEP}]
		')
		media-gfx/pngquant
		x11-libs/cairo
		|| ( media-gfx/imagemagick[png] media-gfx/graphicsmagick[png] )
	)
"

RESTRICT="binchecks strip"

S="${WORKDIR}/${PN}-${COMMIT}"

python_check_deps() {
	python_has_version -b ">=dev-python/fonttools-4.7.0[${PYTHON_USEDEP}]" &&
	python_has_version -b ">=dev-python/nototools-0.2.13[${PYTHON_USEDEP}]"
}

pkg_setup() {
	font_pkg_setup
}

src_prepare() {
	default

	# Drop font for Windows 10
	rm fonts/NotoColorEmoji_WindowsCompatible.ttf || die

	if use buildfont; then
		# From Fedora
		eapply "${FILESDIR}/${PN}-build-all-flags.patch"

		# https://github.com/googlei18n/noto-emoji/issues/240
		eapply "${FILESDIR}/${PN}-20180823-build-path.patch"

		# Be more verbose, bug #717654
		eapply "${FILESDIR}"/${PN}-pngquant-verbose.patch
		sed -i -e 's:@$(ZOPFLIPNG) -y "$<" "$@" 1> /dev/null 2>&1:@$(ZOPFLIPNG) -y "$<" "$@":g' Makefile || die

		# Based on Fedora patch to allow graphicsmagick usage
		if has_version -b media-gfx/graphicsmagick; then
			eapply "${FILESDIR}/${PN}-20190328-use-gm.patch"
		fi
	fi
}

src_compile() {
	if ! use buildfont; then
		einfo "Installing pre-built fonts provided by upstream."
		einfo "They could be not fully updated or miss some items."
		einfo "To build fonts based on latest images enable 'buildfont'"
		einfo "USE (that will require more time and resources too)."
	else
		python_setup
		einfo "Building fonts..."

		# From Debian:
		# The build requires a VIRTUAL_ENV variable and sequence check isn't working
		VIRTUAL_ENV=true \
		BYPASS_SEQUENCE_CHECK=true \
		default
	fi
}

src_install() {
	if ! use buildfont; then
		FONT_S="${S}/fonts"
		# Drop non used fonts
		rm -f fonts/*COLR*.ttf || die
	else
		# Drop Windows compatible fonts and temporal files
		rm -f *tmpl.ttf *Windows*.ttf *COLR*.ttf || die

		# Built fonts
		FONT_S="${S}"

		# Don't lose fancy emoji icons
		for i in 32 72 128 512; do
			insinto "/usr/share/icons/${PN}/${i}/emotes/"
			doins png/"${i}"/*.png
		done

		insinto /usr/share/icons/"${PN}"/scalable/emotes/
		doins svg/*.svg
	fi

	FONT_SUFFIX="ttf"
	font_src_install

	dodoc README.md
}
