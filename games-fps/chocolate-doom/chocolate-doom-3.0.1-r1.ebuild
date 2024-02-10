# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
inherit autotools prefix python-any-r1 xdg

DESCRIPTION="A Doom source port that is minimalist and historically accurate"
HOMEPAGE="https://www.chocolate-doom.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz
	https://gist.githubusercontent.com/vilhelmgray/28d4713cb6387ad62ab76cfac1443355/raw/f7600d93ca45a5102969b8f89974a3c36a3563f5/${P}-overhaul-manpages-add-parameters.patch"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="doc libsamplerate +midi png vorbis"

DEPEND="
	media-libs/libsdl2[video]
	media-libs/sdl2-mixer[midi?,vorbis?]
	media-libs/sdl2-net
	libsamplerate? ( media-libs/libsamplerate )
	png? ( media-libs/libpng:= )"
RDEPEND="${DEPEND}"
# ${PYTHON_DEPS} for bash-completion
BDEPEND="
	${PYTHON_DEPS}
	doc? ( ${PYTHON_DEPS} )"

S="${WORKDIR}/${PN}-${P}"

PATCHES=(
	"${DISTDIR}/${P}-overhaul-manpages-add-parameters.patch"
	"${FILESDIR}/${P}-further-manpage-substitutions-and-fixes.patch"
	"${FILESDIR}/${P}-bash-completion-run-docgen-with-z-argument.patch"
	"${FILESDIR}/${P}-install-AppStream-metadata-into-the-proper-location.patch"
	"${FILESDIR}/${P}-Update-AppStream-XML-files-to-current-0.11-standards.patch"
	"${FILESDIR}/${P}-bash-completion-Build-from-actual-shell-script-templ.patch"
	"${FILESDIR}/${P}-configure-add-AM_PROG_AR-macro.patch"
	"${FILESDIR}/${P}-bash-completion-always-install-into-datadir-bash-com.patch"
	"${FILESDIR}/${P}-Update-to-latest-AppStream-formerly-AppData-standard.patch"
	"${FILESDIR}/${P}-use-reverse-DNS-naming-for-installing-.desktop-files.patch"
	"${FILESDIR}/${P}-Remove-redundant-demoextend-definition.patch"
	"${FILESDIR}/${P}-Introduce-configure-options-for-bash-completion-doc-.patch"
	"${FILESDIR}/${P}-Add-support-for-usr-share-doom-IWAD-search-path.patch"
	"${FILESDIR}/${P}-Update-documentation-about-usr-share-doom-IWAD-locat.patch"
	"${FILESDIR}/${P}-Fix-Python-check.patch"
)

DOCS=(
	"AUTHORS"
	"ChangeLog"
	"NEWS.md"
	"NOT-BUGS.md"
	"PHILOSOPHY.md"
	"README.md"
	"README.Music.md"
	"README.Strife.md"
)

src_prepare() {
	default

	hprefixify src/d_iwad.c

	eautoreconf
}

src_configure() {
	econf \
		--enable-bash-completion \
		$(use_enable doc) \
		--disable-fonts \
		--disable-icons \
		$(use_with libsamplerate) \
		$(use_with png libpng)
}

src_install() {
	emake DESTDIR="${D}" install

	# Remove redundant documentation files
	rm -r "${ED}/usr/share/doc/"* || die

	einstalldocs
}
