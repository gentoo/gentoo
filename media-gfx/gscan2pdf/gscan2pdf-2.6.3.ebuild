# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_TEST="do"

inherit eutils perl-module virtualx

DESCRIPTION="Scan documents, perform OCR, produce PDFs and DjVus"
HOMEPAGE="http://gscan2pdf.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Config-General
	dev-perl/Data-UUID
	dev-perl/Date-Calc
	dev-perl/Filesys-Df
	dev-perl/glib-perl
	dev-perl/GooCanvas2
	dev-perl/Gtk3
	dev-perl/Gtk3-SimpleList
	dev-perl/HTML-Parser
	dev-perl/Image-Sane
	dev-perl/List-MoreUtils
	dev-perl/Locale-gettext
	dev-perl/Log-Log4perl
	dev-perl/PDF-API2
	dev-perl/Proc-ProcessTable
	dev-perl/Readonly
	dev-perl/Set-IntSpan
	dev-perl/Try-Tiny
	virtual/perl-Archive-Tar
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-File-Temp
	virtual/perl-Getopt-Long
	virtual/perl-threads
	virtual/perl-threads-shared
	media-gfx/imagemagick[png,tiff,perl]
	media-gfx/sane-backends
	media-libs/tiff"

BDEPEND="
	test? (
		${RDEPEND}
		dev-perl/Sub-Override
		media-libs/fontconfig

		app-text/djvu[tiff]
		app-text/poppler[utils]
		app-text/tesseract[-opencl,osd(+),tiff]
		app-text/unpaper
		media-gfx/imagemagick[djvu,png,tiff,perl]
		media-gfx/sane-backends[sane_backends_test]
		media-gfx/sane-frontends
	)"

PERL_RM_FILES=( t/{90_MANIFEST,91_critic,99_pod}.t )

mydoc="History"

pkg_postinst() {
	optfeature "DjVu file support" "app-text/djvu[tiff] media-gfx/imagemagick[djvu]"
	optfeature "encrypting PDFs" app-text/pdftk
	optfeature "creating PostScript files from PDFs" app-text/poppler[utils]
	optfeature "adding to an existing PDF" app-text/poppler[utils]
	optfeature "Optical Character Recognition" app-text/tesseract[osd,tiff]
	optfeature "scan post-processing" app-text/unpaper
	optfeature "automatic document feeder support" media-gfx/sane-frontends
	optfeature "sending PDFs as email attachments" x11-misc/xdg-utils
}

src_test(){
	local confdir="${HOME}/.config/ImageMagick"
	mkdir -p "${confdir}" || die
	cat > "${confdir}/policy.xml" <<-EOT || die
		<policymap>
			<policy domain="coder" rights="read|write" pattern="PDF" />
			<policy domain="coder" rights="read" pattern="PS" />
		</policymap>
	EOT
	virtx perl-module_src_test
}
