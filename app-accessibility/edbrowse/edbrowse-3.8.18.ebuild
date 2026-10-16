# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )

inherit edo optfeature python-single-r1 toolchain-funcs

DESCRIPTION="Combination editor, browser, and mail client that is 100% text based"
HOMEPAGE="https://edbrowse.org"
SRC_URI="https://github.com/edbrowse/edbrowse/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ curl MIT CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-db/unixODBC
	dev-libs/libpcre2:=
	dev-libs/openssl:=
	dev-libs/quickjs-ng
	net-misc/curl
	sys-libs/readline:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
"

PATCHES=(
	# adapt makefile for shared quickjs-ng
	"${FILESDIR}"/${PN}-3.8.17-quickjs-ng.patch
)

src_compile() {
	tc-export CC PKG_CONFIG
	emake STRIP=
}

src_test() {
	# create an empty config file
	CONFIG_FILE="${HOME}/.ebrc"
	touch "${CONFIG_FILE}" || die
	# basic test
	echo -e "b ${S}/doc/usersguide.html\n1,3p\nqt" | edo ./src/edbrowse -c "${CONFIG_FILE}" -d3 -e
}

src_install() {
	local myemakeargs=(
		DESTDIR="${D}"
		PREFIX="${EPREFIX}"/usr
		DOCDIR="${ED}/usr/share/doc/${PF}/html"
		FILESDIR="${ED}"/usr/share/edbrowse
	)
	emake "${myemakeargs[@]}" install

	local DOCS=( CHANGES README.md lang/ebrc-* )
	einstalldocs

	newman doc/man-edbrowse-debian.1 edbrowse.1

	python_doscript plugins/scripts/edbrowse-plugin-chrome
}

pkg_postinst() {
	elog "Various plugins for ${PN} are also installed to handle many formats."
	optfeature_header "They may require additional dependencies to function properly:"
	optfeature "Google Chrome plugin" "dev-python/selenium"
	optfeature "Microsoft Office files" "app-text/catdoc app-text/docx2txt"
	optfeature "doc, docx, epub, markdown, rtf files" "app-text/pandoc"
	optfeature "various media files" "media-video/mpv"
	optfeature "pdf files" "app-text/poppler"
	optfeature "audio files" "media-sound/mpg123 media-sound/sox"
}
