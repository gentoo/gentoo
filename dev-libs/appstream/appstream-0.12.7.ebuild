# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg-utils

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ximion/${PN}"
else
	MY_PN="AppStream"
	SRC_URI="https://www.freedesktop.org/software/appstream/releases/${MY_PN}-${PV}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="Cross-distro effort for providing metadata for software in the Linux ecosystem"
HOMEPAGE="https://www.freedesktop.org/wiki/Distributions/AppStream/"

LICENSE="LGPL-2.1+ GPL-2+"
# check as_api_level
SLOT="0/4"
IUSE="apt +introspection qt5 test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-text/docbook-xml-dtd:4.5
	dev-libs/appstream-glib
	dev-util/itstool
	>=dev-util/meson-0.42.0
	>=sys-devel/gettext-0.19.8
	test? (
		dev-qt/linguist-tools:5
		qt5? ( dev-qt/qttest:5 )
	)
"
DEPEND="
	dev-db/lmdb:=
	>=dev-libs/glib-2.54:2
	dev-libs/libxml2:2
	dev-libs/libyaml
	dev-libs/snowball-stemmer
	introspection? ( >=dev-libs/gobject-introspection-1.56:= )
	qt5? ( dev-qt/qtcore:5 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -e "/^as_doc_target_dir/s/appstream/${PF}/" -i docs/meson.build || die
	if ! use test; then
		sed -e "/^subdir.*tests/s/^/#DONT /" -i {,qt/}meson.build || die # bug 675944
	fi
}

src_configure() {
	xdg_environment_reset

	local emesonargs=(
		-Dapidocs=false
		-Ddocs=false
		-Dmaintainer=false
		-Dstemming=true
		-Dvapi=false
		-Dapt-support=$(usex apt true false)
		-Dgir=$(usex introspection true false)
		-Dqt=$(usex qt5 true false)
	)

	meson_src_configure
}
