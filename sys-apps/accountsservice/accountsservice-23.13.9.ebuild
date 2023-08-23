# Copyright 2011-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
inherit meson python-any-r1 systemd plocale

PLOCALES="af ar as ast az be bg bn_IN ca ca@valencia cs cy da de el en_GB en eo es et eu fa fi fo fr fur ga gl gu he hi hr hu ia id it ja ka kk kn ko ky lt lv ml mr ms nb nl nn oc or pa pl pt_BR pt ro ru sk sl sq sr@latin sr sv ta te th tr uk vi wa zh_CN zh_HK zh_TW"

DESCRIPTION="D-Bus interfaces for querying and manipulating user account information"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/AccountsService/"
SRC_URI="https://www.freedesktop.org/software/${PN}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv ~sparc x86"

IUSE="doc elogind gtk-doc +introspection selinux systemd test"
RESTRICT="!test? ( test )"
REQUIRED_USE="^^ ( elogind systemd )"

CDEPEND="
	>=dev-libs/glib-2.63.5:2
	sys-auth/polkit
	virtual/libcrypt:=
	elogind? ( >=sys-auth/elogind-229.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	systemd? ( >=sys-apps/systemd-186:0= )
"
DEPEND="${CDEPEND}
	sys-apps/dbus
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
	doc? (
		dev-libs/libxslt
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto
	)
	gtk-doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3
	)
	test? (
		$(python_gen_any_dep '
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-accountsd )
"

PATCHES=(
	"${FILESDIR}"/${PN}-22.04.62-gentoo-system-users.patch
	"${FILESDIR}"/${PN}-23.13.9-generate-version.patch #905770
)

python_check_deps() {
	if use test; then
		python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
	fi
}

src_prepare() {
	default
	plocale_get_locales > po/LINGUAS || die
}

src_configure() {
	# No option to disable tests
	if ! use test; then
		sed -e "/subdir('tests')/d" -i meson.build || die
	fi

	local emesonargs=(
		--localstatedir="${EPREFIX}/var"
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Dadmin_group="wheel"
		$(meson_use elogind)
		$(meson_use introspection)
		$(meson_use doc docbook)
		$(meson_use gtk-doc gtk_doc)
		-Dvapi=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# https://gitlab.freedesktop.org/accountsservice/accountsservice/-/issues/90
	if use doc; then
		mv "${ED}/usr/share/doc/${PN}" "${ED}/usr/share/doc/${PF}" || die
	fi

	# This directories are created at runtime when needed
	rm -r "${ED}"/var/lib || die
}
