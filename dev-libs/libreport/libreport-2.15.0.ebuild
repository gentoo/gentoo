# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit autotools python-r1

DESCRIPTION="Generic library for reporting software bugs"
HOMEPAGE="https://github.com/abrt/libreport"
SRC_URI="https://github.com/abrt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="gtk +python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	app-admin/augeas
	app-arch/libarchive:0=
	>=dev-libs/glib-2.43.4:2
	dev-libs/satyr:0=
	dev-libs/json-c:=
	dev-libs/libxml2:2
	dev-libs/nettle:=
	dev-libs/newt:=
	dev-libs/xmlrpc-c:=
	net-libs/libproxy:=
	net-misc/curl:=[ssl]
	sys-apps/dbus
	sys-apps/systemd
	gtk? ( >=x11-libs/gtk+-3.3.12:3 )
	python? ( ${PYTHON_DEPS} )
	x11-misc/xdg-utils
"
RDEPEND="${DEPEND}
	acct-user/abrt
	acct-group/abrt
"
BDEPEND="
	app-text/asciidoc
	app-text/xmlto
	>=dev-util/intltool-0.3.50
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

# Tests require python-meh, which is highly redhat-specific.
RESTRICT="test"

src_prepare() {
	default
	./gen-version || die # Needed to be run before autoreconf
	eautoreconf
	use python && python_copy_sources
}

src_configure() {
	use python && python_setup

	local myargs=(
		--localstatedir="${EPREFIX}/var"
		--without-bugzilla
		$(use_with gtk)
		$(use_with python python3)
	)
	if use python; then
		python_foreach_impl run_in_build_dir econf "${myargs[@]}"
	else
		econf "${myargs[@]}"
	fi
}

src_compile() {
	if use python; then
		python_foreach_impl run_in_build_dir default
	else
		default
	fi
}

src_install() {
	if use python; then
		python_install() {
			default
			python_optimize
		}
		python_foreach_impl run_in_build_dir python_install
	else
		default
	fi

	# Need to set correct ownership for use by app-admin/abrt
	diropts -o abrt -g abrt
	keepdir /var/spool/abrt

	find "${D}" -name '*.la' -exec rm -f {} + || die
}
