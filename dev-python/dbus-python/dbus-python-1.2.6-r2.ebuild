# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )
PYTHON_REQ_USE="threads(+)"

inherit autotools python-r1

DESCRIPTION="Python bindings for the D-Bus messagebus"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/DBusBindings https://dbus.freedesktop.org/doc/dbus-python/"
SRC_URI="https://dbus.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"
# API docs generated with epydoc, which is python2-only
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	doc? ( python_targets_python2_7 )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=sys-apps/dbus-1.8:=
	>=dev-libs/glib-2.40
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		dev-python/docutils[python_targets_python2_7?]
		=dev-python/epydoc-3*[python_targets_python2_7?] )
	test? ( dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/tappy[${PYTHON_USEDEP}] )"
# TODO: Half the tests require tap.py from PyPI now, which we didn't have packaged; those tests just get skipped then though

src_prepare() {
	default
	# Update py-compile, bug 529502.
	eautoreconf
	python_copy_sources
}

src_configure() {
	configuring() {
		# epydoc is python2-only, bug #447642
		local apidocs=--disable-api-docs
		[[ ${EPYTHON/.*} = "python2" ]] && apidocs=$(use_enable doc api-docs)

		econf \
			--disable-html-docs \
			${apidocs}
	}
	python_foreach_impl run_in_build_dir configuring
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installing() {
		default
		[[ ${EPYTHON/.*} = "python2" ]] && use doc && dodoc -r api
	}
	python_foreach_impl run_in_build_dir installing
	find "${D}" -name "*.la" -delete || die

	use examples && dodoc -r examples
}
