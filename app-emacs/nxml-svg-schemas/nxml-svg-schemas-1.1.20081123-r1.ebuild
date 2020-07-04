# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Extension for nxml-mode with SVG 1.1 schemas"
HOMEPAGE="http://www.w3.org/TR/SVG11/"
# original SRC_URI is http://www.w3.org/Graphics/SVG/1.1/rng/rng.zip
# but since it's unversioned, I versioned it and got it locally.
SRC_URI="http://www.flameeyes.eu/gentoo-distfiles/w3c-svg-rng-${PV}.zip"

LICENSE="HPND"
# In a future we might have 1.2 schemas too, but for now we can only
# install this one anyway because the schemas.xml syntax is not
# sophisticated enough.
SLOT="1.1"
KEYWORDS="amd64 x86"

# Yes this requires Java, but I'd rather not repackage this, if you
# know something better in C, I'll be glad to use that.
BDEPEND="app-arch/unzip
	app-text/trang"

S="${WORKDIR}"
SITEFILE="60${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare
	# we don't need the doctype for our work
	sed -i -e '/DOCTYPE grammar/d' *.rng || die "sed failed"
}

src_compile() {
	emake -f "${FILESDIR}/Makefile-trang"
}

src_install() {
	insinto "${SITEETC}/${PN}"
	doins "${FILESDIR}/schemas.xml" *.rnc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}
