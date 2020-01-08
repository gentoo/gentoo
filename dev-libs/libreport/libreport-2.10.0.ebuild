# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit autotools python-r1 user

DESCRIPTION="Generic library for reporting software bugs"
HOMEPAGE="https://github.com/abrt/libreport"
SRC_URI="https://github.com/abrt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+gtk python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	app-admin/augeas
	>=dev-libs/glib-2.43.4:2
	dev-libs/satyr:0=
	dev-libs/json-c:=
	dev-libs/libtar
	dev-libs/libxml2:2
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
RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	app-text/asciidoc
	app-text/xmlto
	>=dev-util/intltool-0.3.50
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

# Tests require python-meh, which is highly redhat-specific.
RESTRICT="test"

pkg_setup() {
	enewgroup abrt
	enewuser abrt -1 -1 -1 abrt
}

src_prepare() {
	default
	./gen-version || die # Needed to be run before autoreconf
	eautoreconf
	use python && python_copy_sources
}

src_configure() {
	local myargs=(
		--localstatedir="${EPREFIX}/var"
		--without-bugzilla
		# Fixes "syntax error in VERSION script" and we aren't supporting Python2 anyway
		--without-python2
		$(usex python "--with-python3" "--without-python3")
	)
	if use python; then
		python_foreach_impl run_in_build_dir \
			econf "${myargs[@]}"
	else
		econf "${myargs[@]}"
	fi
}

src_compile() {
	use python && python_foreach_impl run_in_build_dir default
}

src_install() {
	use python && python_foreach_impl run_in_build_dir default
	# Need to set correct ownership for use by app-admin/abrt
	diropts -o abrt -g abrt
	keepdir /var/spool/abrt

	find "${D}" -name '*.la' -exec rm -f {} + || die
}
