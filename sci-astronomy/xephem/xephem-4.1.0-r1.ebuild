# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Interactive tool for astronomical ephemeris and sky simulation"
HOMEPAGE="https://xephem.github.io/XEphem/Site/xephem.html"
SRC_URI="https://github.com/XEphem/XEphem/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/XEphem-${PV}"

LICENSE="MIT"
SLOT=0
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-libs/openssl:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	>=x11-libs/motif-2.3:0
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/groff"

HTML_DOCS=( GUI/xephem/help/. )

# NOTE: order is relevant - parallel build patch requires respect env vars
# patch to be already applied
PATCHES=(
	"${FILESDIR}/${PN}-3.7.7-implicits.patch"
	"${FILESDIR}/${P}-respect_env_vars.patch"
	"${FILESDIR}/${P}-allow-parallel-builds.patch"
)

src_compile() {
	tc-export CC AR RANLIB
	emake -C GUI/xephem
}

src_install() {
	insinto /usr/share/X11/app-defaults
	newins - XEphem <<-EOF
		XEphem.ShareDir: /usr/share/${PN}
	EOF
	newenvd - 99xephem <<-EOF
		XEHELPURL=/usr/share/doc/${PF}/html/xephem.html
	EOF
	einstalldocs

	cd GUI/xephem || die
	dobin xephem
	doman xephem.1
	newicon XEphem.png ${PN}.png
	insinto /usr/share/${PN}
	doins -r auxil catalogs fifos fits gallery lo
	make_desktop_entry xephem XEphem ${PN}
}
