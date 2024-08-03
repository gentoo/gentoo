# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson xdg

DESCRIPTION="Web browser designed to organize and run Web applications"
HOMEPAGE="https://apps.gnome.org/app/re.sonny.Tangram/
	https://github.com/sonnyp/Tangram/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sonnyp/${PN^}.git"
else
	TROLL_COMMIT="63392a57392fb8ed944e859269a3751f649f64ec"
	SRC_URI="
		https://github.com/sonnyp/${PN^}/archive/refs/tags/v${PV}.tar.gz
			-> ${P}.tar.gz
		https://github.com/sonnyp/troll/archive/${TROLL_COMMIT}.tar.gz
			-> troll-${TROLL_COMMIT}.tar.gz
	"
	S="${WORKDIR}/${P^}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=dev-libs/gjs-1.76.0
	gui-libs/gtk:4
	gui-libs/libadwaita:1
	net-libs/webkit-gtk:6
"
BDEPEND="
	${RDEPEND}
	dev-libs/appstream-glib
	dev-util/blueprint-compiler
	dev-util/desktop-file-utils
"

PATCHES=(
	"${FILESDIR}/${PN}-2.0-dont-validate-appstream.patch"
)

DOCS=( README.md TODO.md )

src_prepare() {
	default

	rm -d "${S}/troll" || die
	cp -r "${WORKDIR}/troll-${TROLL_COMMIT}" "${S}/troll" || die
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}
