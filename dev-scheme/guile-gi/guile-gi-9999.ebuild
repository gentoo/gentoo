# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit virtualx autotools

DESCRIPTION="Bindings for GObject Introspection and libgirepository for Guile"
HOMEPAGE="https://spk121.github.io/guile-gi/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/spk121/${PN}.git"
else
	SRC_URI="https://github.com/spk121/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
RESTRICT="strip"

DEPEND="
	>=dev-scheme/guile-2.0.9:=
	dev-libs/gobject-introspection
	x11-libs/gtk+:3[introspection]
"
RDEPEND="${DEPEND}"
BDEPEND="sys-apps/texinfo"

# guile generates ELF files without use of C or machine code
# It's a portage's false positive. bug #677600
QA_PREBUILT='*[.]go'

src_prepare() {
	default

	# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112
	find "${S}" -name "*.scm" -exec touch {} + || die

	eautoreconf
}

src_configure() {
	econf --disable-static --enable-introspection=yes
}

src_test() {
	virtx default
}

src_install() {
	default

	mv "${D}"/usr/share/doc/${PN} "${D}"/usr/share/doc/${PF} || die
	find "${ED}" -type f -name '*.la' -delete || die
}
