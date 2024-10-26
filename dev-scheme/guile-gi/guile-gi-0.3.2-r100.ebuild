# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit virtualx autotools guile

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

REQUIRED_USED="${GUILE_REQUIRED_USE}"

DEPEND="
	${GUILE_DEPS}
	dev-libs/gobject-introspection
	x11-libs/gtk+:3[introspection]
"
RDEPEND="${DEPEND}"
BDEPEND="sys-apps/texinfo"

PATCHES=(
	"${FILESDIR}"/guile-gi-0.3.2-function-cast.patch
)

src_prepare() {
	guile_src_prepare

	eautoreconf
}

src_configure() {
	guile_foreach_impl econf --enable-introspection=yes
}

src_compile() {
	my_compile() {
		mkdir test || die
		default
	}
	guile_foreach_impl my_compile
}

src_test() {
	guile_foreach_impl virtx default
}

src_install() {
	guile_src_install

	mv "${ED}"/usr/share/doc/${PN} "${ED}"/usr/share/doc/${PF} || die
	find "${ED}" -type f -name '*.la' -delete || die
}
