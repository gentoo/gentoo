# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils vala

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ximion/${PN}"
else
	MY_PN="AppStream"
	SRC_URI="https://www.freedesktop.org/software/appstream/releases/${MY_PN}-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="Cross-distro effort for providing metadata for software in the Linux ecosystem"
HOMEPAGE="https://www.freedesktop.org/wiki/Distributions/AppStream/"

LICENSE="LGPL-2.1+ GPL-2+"
# check as_api_level
SLOT="0/5"
IUSE="apt compose doc +introspection qt6 systemd test vala"
RESTRICT="test" # bug 691962

RDEPEND="
	app-arch/zstd:=
	>=dev-libs/glib-2.62:2
	dev-libs/libxml2:2
	>=dev-libs/libxmlb-0.3.14:=
	dev-libs/libyaml
	dev-libs/snowball-stemmer:=
	>=net-misc/curl-7.62
	compose? (	dev-libs/glib:2
				dev-libs/libyaml
				gnome-base/librsvg:2
				media-libs/fontconfig:1.0
				media-libs/freetype:2
				x11-libs/cairo
				x11-libs/gdk-pixbuf:2 )
	introspection? ( >=dev-libs/gobject-introspection-1.56:= )
	qt6? ( dev-qt/qtbase:6 )
	systemd? ( sys-apps/systemd:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxslt
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	doc? ( app-text/docbook-xml-dtd:4.5 )
	test? ( dev-qt/qttools:6[linguist] )
	vala? ( $(vala_depend) )
"

PATCHES=( "${FILESDIR}"/${PN}-1.0.0-disable-Werror-flags.patch ) # bug 733774

src_prepare() {
	default
	sed -e "/^as_doc_target_dir/s/appstream/${PF}/" -i docs/meson.build || die
	if ! use test; then
		sed -e "/^subdir.*tests/s/^/#DONT /" -i {,qt/}meson.build || die # bug 675944
	fi

	use vala && vala_setup
}

src_configure() {
	xdg_environment_reset

	local emesonargs=(
		-Dapidocs=false
		-Ddocs=false
		-Dcompose=false
		-Dmaintainer=false
		-Dstatic-analysis=false
		-Dstemming=true
		-Dvapi=$(usex vala true false)
		-Dapt-support=$(usex apt true false)
		-Dcompose=$(usex compose true false)
		-Dinstall-docs=$(usex doc true false)
		-Dgir=$(usex introspection true false)
		-Dqt=$(usex qt6 true false)
		-Dsystemd=$(usex systemd true false)
	)

	meson_src_configure
}
