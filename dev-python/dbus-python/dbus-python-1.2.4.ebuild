# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
PYTHON_REQ_USE="threads(+)"

inherit autotools eutils python-r1

DESCRIPTION="Python bindings for the D-Bus messagebus"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/DBusBindings https://dbus.freedesktop.org/doc/dbus-python/"
SRC_URI="https://dbus.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~m68k-mint"
IUSE="doc examples test"
RESTRICT="!test? ( test )"
# API docs generated with epydoc, which is python2-only
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	doc? ( python_targets_python2_7 )"

RDEPEND="
	>=dev-libs/dbus-glib-0.100:=
	>=sys-apps/dbus-1.6:=
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		dev-python/docutils[python_targets_python2_7?]
		=dev-python/epydoc-3*[python_targets_python2_7?] )
	test? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )"

src_prepare() {
	default
	# Update py-compile, bug 529502.
	eautoreconf
	python_copy_sources
}

src_configure() {
	configuring() {
		local PYTHON_CONFIG
		python_export PYTHON_CONFIG

		# epydoc is python2-only, bug #447642
		local apidocs=--disable-api-docs
		[[ ${EPYTHON/.*} = "python2" ]] && apidocs=$(use_enable doc api-docs)

		econf \
			--docdir="${EPREFIX}"/usr/share/doc/${PF} \
			--disable-html-docs \
			${apidocs} \
			PYTHON_INCLUDES="$(${PYTHON_CONFIG} --includes)" \
			PYTHON_LIBS="$(${PYTHON_CONFIG} --ldflags)"
		# configure assumes that ${PYTHON}-config executable exists :/
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
		[[ ${EPYTHON/.*} = "python2" ]] && use doc && dohtml -r api/*
	}
	python_foreach_impl run_in_build_dir installing
	prune_libtool_files --modules

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

run_in_build_dir() {
	pushd "${BUILD_DIR}" > /dev/null || die
	"$@"
	popd > /dev/null
}
